import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurahelp/app/data/models/doctor_model.dart';
import 'package:nurahelp/app/data/models/message_models/message_model.dart';
import 'package:nurahelp/app/data/services/app_service.dart';
import 'package:nurahelp/app/data/services/network_manager.dart';
import 'package:nurahelp/app/data/services/socket_service.dart';
import 'package:nurahelp/app/data/services/file_management_service.dart';
import 'package:nurahelp/app/data/services/audio_recorder_service.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';

class DirectMessageController extends GetxController {
  final DoctorModel doctor;

  DirectMessageController({required this.doctor});

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isTyping = false.obs;
  final RxBool hasNetworkTimeout = false.obs; // Track timeout
  final RxBool hasNoInternet = false.obs; // Track no internet
  final TextEditingController messageController = TextEditingController();

  late SocketService socketService;
  late AppNetworkManager networkManager;
  late String currentUserId;
  late String doctorId;
  Timer? typingTimer;
  Timer? connectivityCheckTimer;
  final appService = AppService.instance;
  late AudioRecorderService audioRecorderService;

  // Map temp message IDs to real server IDs
  final Map<String, String> _tempToRealIdMap = {};

  // Upload progress tracking
  final RxMap<String, double> uploadProgress = <String, double>{}.obs;

  // Voice recording state
  final RxBool isRecordingVoice = false.obs;

  // Reply state
  final Rxn<MessageModel> replyingTo = Rxn<MessageModel>();

  // Edit state
  final Rxn<MessageModel> editingMessage = Rxn<MessageModel>();

  static const int networkTimeoutSeconds = 90; // 1.5 minutes

  @override
  void onInit() {
    super.onInit();
    debugPrint(
      '🟢 [DirectMessage] Controller initialized for doctor: ${doctor.name}',
    );
    _initializeSocket();
    _initializeNetworkManager();
    _initializeAudioRecorder();
    fetchMessages(); // First load → full fetch; subsequent → incremental
  }

  /// Call this when the page is re-opened to pick up any missed messages.
  void onPageResumed() {
    if (messages.isNotEmpty) {
      fetchMessages(); // incremental – only fetches new messages
    }
  }

  void _initializeAudioRecorder() {
    try {
      audioRecorderService = Get.find<AudioRecorderService>();
    } catch (e) {
      // If not found, create and register a new instance
      audioRecorderService = AudioRecorderService();
      Get.put(audioRecorderService);
    }
    debugPrint('🎤 [DirectMessage] Audio recorder service initialized');
  }

  void _initializeNetworkManager() {
    try {
      networkManager = Get.find<AppNetworkManager>();
    } catch (e) {
      // If not found, create a new instance
      networkManager = AppNetworkManager();
    }
    // Start monitoring connectivity while loading
    _startConnectivityCheck();
  }

  void _startConnectivityCheck() {
    connectivityCheckTimer = Timer.periodic(const Duration(seconds: 3), (
      _,
    ) async {
      if (isLoading.value && messages.isEmpty) {
        final isConnected = await networkManager.isConnected();
        hasNoInternet.value = !isConnected;
        debugPrint(
          '🔌 [DirectMessage] Connectivity check: isConnected=$isConnected',
        );
      } else {
        // Stop checking once loading is done
        connectivityCheckTimer?.cancel();
      }
    });
  }

  void _initializeSocket() {
    debugPrint('🔌 [DirectMessage] Initializing socket');
    socketService = Get.find<SocketService>();
    final patientController = Get.find<PatientController>();
    currentUserId = patientController.patient.value.id ?? '';
    doctorId =
        doctor.id ??
        doctor.name; // Use doctor ID if available, fallback to name

    debugPrint('🔌 [DirectMessage] Current User ID: $currentUserId');
    debugPrint('🔌 [DirectMessage] Doctor ID: $doctorId');
    debugPrint(
      '🔌 [DirectMessage] Socket connected: ${socketService.isConnected.value}',
    );

    // Set up socket listeners
    socketService.onNewMessage = (message) {
      debugPrint('📨 [DirectMessage] New message received from socket');
      debugPrint(
        '📨 [DirectMessage] Sender: ${message.sender}, Receiver: ${message.receiver}',
      );

      // Only add messages from the doctor to avoid duplicates (we already add our own messages locally)
      if (message.sender == doctorId && message.receiver == currentUserId) {
        debugPrint('✅ [DirectMessage] Message from doctor - adding to list');
        messages.add(message);
        messages.refresh();

        // Mark as read if message is from doctor
        debugPrint('👁️ [DirectMessage] Marking message as read');
        _markAsRead();
      } else if (message.sender == currentUserId) {
        debugPrint(
          '⏭️ [DirectMessage] Skipping own message (already added locally)',
        );
      } else {
        debugPrint(
          '❌ [DirectMessage] Message not related to this conversation',
        );
      }
    };

    socketService.onUserTyping = (userId) {
      if (userId == doctorId) {
        isTyping.value = true;
      }
    };

    socketService.onUserStoppedTyping = (userId) {
      if (userId == doctorId) {
        isTyping.value = false;
      }
    };

    // Listen for message delivered events
    socketService.onMessageDelivered = (messageId) {
      debugPrint('📬 [DirectMessage] Message delivered: $messageId');
      _updateMessageStatus(messageId, delivered: true);
    };

    // Listen for message read events
    socketService.onMessageRead = (messageId) {
      debugPrint('👓 [DirectMessage] Message read: $messageId');
      _updateMessageStatus(messageId, read: true);
    };

    // TODO: Uncomment when backend supports delete/edit events
    // socketService.addMessageDeletedListener(_onMessageDeleted);
    // socketService.addMessageEditedListener(_onMessageEdited);
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;
      hasNetworkTimeout.value = false;
      hasNoInternet.value = false;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        debugPrint('⚠️ [DirectMessage] No authenticated user found');
        return;
      }

      // Determine the timestamp of the latest cached message so we can
      // request only newer messages from the server.
      DateTime? after;
      if (messages.isNotEmpty) {
        after = messages
            .map((m) => m.timestamp)
            .reduce((a, b) => a.isAfter(b) ? a : b);
      }

      debugPrint(
        '📥 [DirectMessage] Fetching chat history for doctor: $doctorId'
        '${after != null ? ' (after ${after.toIso8601String()})' : ' (full)'}',
      );

      // Fetch chat history from API with timeout
      final response = await appService
          .getChatHistory(doctorId, user, after: after)
          .timeout(
            const Duration(seconds: networkTimeoutSeconds),
            onTimeout: () {
              hasNetworkTimeout.value = true;
              throw Exception('Network timeout - unstable internet connection');
            },
          );

      if (response['messages'] != null) {
        final List<dynamic> messagesList = response['messages'];
        final newMessages = messagesList
            .map((json) => MessageModel.fromJson(json))
            .toList();

        if (after == null) {
          // First load – replace everything
          messages.value = newMessages;
          debugPrint('✅ [DirectMessage] Loaded ${messages.length} messages');
        } else {
          // Incremental – deduplicate by id and append only truly new ones
          final existingIds = messages.map((m) => m.id).toSet();
          final onlyNew = newMessages
              .where((m) => !existingIds.contains(m.id))
              .toList();
          if (onlyNew.isNotEmpty) {
            messages.addAll(onlyNew);
            messages.refresh();
            debugPrint(
              '✅ [DirectMessage] Appended ${onlyNew.length} new messages (total ${messages.length})',
            );
          } else {
            debugPrint('✅ [DirectMessage] No new messages since last fetch');
          }
        }
      } else {
        debugPrint('⚠️ [DirectMessage] No messages in response');
      }

      // Mark all messages as read
      await _markAsRead();
    } catch (e) {
      debugPrint('❌ [DirectMessage] Error fetching messages: $e');
      // Retry once after a delay only if not a timeout and no cached messages
      if (!hasNetworkTimeout.value && messages.isEmpty) {
        await Future.delayed(const Duration(seconds: 1));
        try {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final response = await appService.getChatHistory(doctorId, user);
            if (response['messages'] != null) {
              final List<dynamic> messagesList = response['messages'];
              messages.value = messagesList
                  .map((json) => MessageModel.fromJson(json))
                  .toList();
              debugPrint(
                '✅ [DirectMessage] Retry successful - loaded ${messages.length} messages',
              );
            }
          }
        } catch (retryError) {
          debugPrint('❌ [DirectMessage] Retry failed: $retryError');
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _markAsRead() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await appService.markMessagesAsRead(doctorId, user);
      socketService.markMessagesAsRead(currentUserId, doctorId);
    } catch (e) {
      debugPrint('Error marking messages as read: $e');
    }
  }

  void _updateMessageStatus(String messageId, {bool? delivered, bool? read}) {
    final index = messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      final message = messages[index];
      messages[index] = MessageModel(
        id: message.id,
        sender: message.sender,
        senderType: message.senderType,
        receiver: message.receiver,
        receiverType: message.receiverType,
        message: message.message,
        attachments: message.attachments,
        attachmentType: message.attachmentType,
        attachmentPreview: message.attachmentPreview,
        timestamp: message.timestamp,
        read: read ?? message.read,
        delivered: delivered ?? message.delivered,
      );
      messages.refresh();
      debugPrint('✅ [DirectMessage] Message status updated: $messageId');
    }
  }

  void sendMessage() {
    // If we're in edit mode, confirm the edit instead
    if (editingMessage.value != null) {
      confirmEdit();
      return;
    }

    final messageText = messageController.text.trim();
    debugPrint('🔵 [DirectMessage] sendMessage called');
    debugPrint('🔵 [DirectMessage] Message text: "$messageText"');
    debugPrint('🔵 [DirectMessage] Is empty: ${messageText.isEmpty}');

    if (messageText.isEmpty) {
      debugPrint('❌ [DirectMessage] Message is empty, not sending');
      return;
    }

    // Check internet connectivity before allowing send
    if (!socketService.isConnected.value) {
      debugPrint(
        '❌ [DirectMessage] No internet connection, cannot send message',
      );
      Get.snackbar(
        'No Internet',
        'Please check your internet connection',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    debugPrint('📤 [DirectMessage] Sending message via socket');
    debugPrint('📤 [DirectMessage] Sender: $currentUserId');
    debugPrint('📤 [DirectMessage] Receiver: $doctorId');

    socketService.sendMessage(
      sender: currentUserId,
      senderType: 'Patient',
      receiver: doctorId,
      message: messageText,
      replyToId: replyingTo.value?.id,
      replyToMessage: replyingTo.value?.displayText,
      replyToSender: replyingTo.value?.sender,
    );

    // Add message to local list immediately for better UX
    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: currentUserId,
      senderType: 'Patient',
      receiver: doctorId,
      receiverType: 'Doctor',
      message: messageText,
      timestamp: DateTime.now(),
      read: false,
      replyToId: replyingTo.value?.id,
      replyToMessage: replyingTo.value?.displayText,
      replyToSender: replyingTo.value?.sender,
    );

    messages.add(message);
    debugPrint(
      '✅ [DirectMessage] Message added to local list. Total messages: ${messages.length}',
    );

    messageController.clear();
    clearReply();
    debugPrint('🧹 [DirectMessage] Message controller cleared');

    // Stop typing indicator
    socketService.sendStopTyping(currentUserId, doctorId);
    debugPrint('⏹️ [DirectMessage] Stop typing indicator sent');
  }

  void onTyping() {
    socketService.sendTyping(currentUserId, doctorId);

    // Cancel previous timer
    typingTimer?.cancel();

    // Set new timer to send stop typing after 2 seconds of inactivity
    typingTimer = Timer(const Duration(seconds: 2), () {
      socketService.sendStopTyping(currentUserId, doctorId);
    });
  }

  /// Start voice recording
  Future<void> startVoiceRecording() async {
    try {
      await audioRecorderService.startRecording();
      isRecordingVoice.value = true;
      debugPrint('🎤 [DirectMessage] Voice recording started');
    } catch (e) {
      debugPrint('❌ [DirectMessage] Error starting voice recording: $e');
      Get.snackbar(
        'Recording Error',
        'Failed to start voice recording',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Stop and send voice recording
  Future<void> stopAndSendVoiceRecording() async {
    try {
      final audioPath = await audioRecorderService.stopRecording();
      isRecordingVoice.value = false;

      if (audioPath != null && audioPath.isNotEmpty) {
        final audioFile = File(audioPath);
        if (await audioFile.exists()) {
          await _sendVoiceNote(audioFile);
        } else {
          throw Exception('Audio file not found');
        }
      } else {
        throw Exception('Recording path is empty');
      }
    } catch (e) {
      debugPrint('❌ [DirectMessage] Error sending voice note: $e');
      isRecordingVoice.value = false;
      Get.snackbar(
        'Send Error',
        'Failed to send voice note',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Cancel voice recording
  Future<void> cancelVoiceRecording() async {
    try {
      await audioRecorderService.cancelRecording();
      isRecordingVoice.value = false;
      debugPrint('🗑️ [DirectMessage] Voice recording cancelled');
    } catch (e) {
      debugPrint('❌ [DirectMessage] Error cancelling voice recording: $e');
      isRecordingVoice.value = false;
    }
  }

  /// Send voice note file
  Future<void> _sendVoiceNote(File audioFile) async {
    try {
      // Check internet connectivity
      if (!socketService.isConnected.value) {
        debugPrint('❌ [DirectMessage] No internet connection');
        Get.snackbar(
          'No Internet',
          'Please check your internet connection',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        return;
      }

      // Get audio duration and file size
      final fileSize = await audioFile.length();
      final formattedSize = FileManagementService.instance.getFileSizeString(
        fileSize,
      );
      final duration = audioRecorderService.recordingDuration.value;
      final formattedDuration = audioRecorderService.formatDuration(duration);

      // 1. Optimistic UI Update
      final tempId = "temp_${DateTime.now().millisecondsSinceEpoch}";
      uploadProgress[tempId] = 0.0;

      final tempMessage = MessageModel(
        id: tempId,
        sender: currentUserId,
        senderType: 'Patient',
        receiver: doctorId,
        receiverType: 'Doctor',
        message: '$formattedDuration|$formattedSize', // duration|size format
        attachments: [audioFile.path],
        attachmentType: 'voice',
        timestamp: DateTime.now(),
        read: false,
        delivered: false,
        isUploading: true,
      );

      messages.add(tempMessage);
      messages.refresh();

      // 2. Upload to Firebase/Backend
      final user = FirebaseAuth.instance.currentUser;
      final uploadResponse = await appService.uploadChatFile(
        XFile(audioFile.path),
        doctorId,
        user,
        onProgress: (progress) {
          uploadProgress[tempId] = progress;
          debugPrint(
            '📤 [DirectMessage] Voice upload progress: ${(progress * 100).toStringAsFixed(1)}%',
          );
        },
      );

      uploadProgress[tempId] = 1.0;
      final String fileUrl = uploadResponse['url'];

      // NOTE: Do NOT call socketService.sendMessage() here.
      // The upload endpoint already creates the message on the server
      // and broadcasts via socket (newMessage event). Calling sendMessage
      // again would create a duplicate message.

      // 3. Update local message with server URL
      _replaceTempWithRealMessage(tempId, fileUrl: fileUrl);
      uploadProgress.remove(tempId);

      debugPrint('✅ [DirectMessage] Voice note sent successfully');
    } catch (e) {
      debugPrint('❌ [DirectMessage] Voice note upload error: $e');
      messages.removeWhere((m) => m.id.startsWith("temp_"));

      // Clean up progress tracker
      final failedIds = uploadProgress.keys
          .where((id) => id.startsWith("temp_"))
          .toList();
      for (final id in failedIds) {
        uploadProgress.remove(id);
      }

      Get.snackbar(
        'Upload Error',
        'Could not send voice note. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    typingTimer?.cancel();
    connectivityCheckTimer?.cancel();
    // TODO: Uncomment when backend supports delete/edit events
    // socketService.removeMessageDeletedListener(_onMessageDeleted);
    // socketService.removeMessageEditedListener(_onMessageEdited);
    super.onClose();
  }

  // ─── Reply / Delete / Edit ────────────────────────────────────────

  /// Set the message we're replying to (shows reply bar in UI)
  void setReplyTo(MessageModel message) {
    replyingTo.value = message;
  }

  /// Clear reply state
  void clearReply() {
    replyingTo.value = null;
  }

  /// Start editing a message (sets text in input + edit state)
  void startEditing(MessageModel message) {
    if (!message.canEdit || message.sender != currentUserId) return;
    editingMessage.value = message;
    messageController.text = message.message;
  }

  /// Cancel editing
  void cancelEditing() {
    editingMessage.value = null;
    messageController.clear();
  }

  /// Confirm edit – sends update via socket and updates local list
  void confirmEdit() {
    final msg = editingMessage.value;
    if (msg == null) return;

    final newText = messageController.text.trim();
    if (newText.isEmpty || newText == msg.message) {
      cancelEditing();
      return;
    }

    // TODO: Uncomment when backend supports editMessage
    // socketService.editMessage(msg.id, newText, currentUserId, doctorId);

    // Optimistic local update
    _applyEditLocally(msg.id, newText);

    editingMessage.value = null;
    messageController.clear();
  }

  /// Delete a message for everyone
  void deleteMessageForEveryone(String messageId) {
    // TODO: Uncomment when backend supports deleteMessage
    // socketService.deleteMessage(messageId, currentUserId, doctorId);

    // Optimistic local update
    _applyDeleteLocally(messageId);
  }

  // ─── Socket event handlers ───────────────────────────────────────

  // TODO: Uncomment when backend supports delete/edit events
  // void _onMessageDeleted(String messageId) {
  //   debugPrint('🗑️ [DirectMessage] Message deleted: $messageId');
  //   _applyDeleteLocally(messageId);
  // }

  // void _onMessageEdited(String messageId, String newText) {
  //   debugPrint('✏️ [DirectMessage] Message edited: $messageId');
  //   _applyEditLocally(messageId, newText);
  // }

  void _applyDeleteLocally(String messageId) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final old = messages[index];
      messages[index] = MessageModel(
        id: old.id,
        sender: old.sender,
        senderType: old.senderType,
        receiver: old.receiver,
        receiverType: old.receiverType,
        message: old.message,
        attachments: old.attachments,
        attachmentType: old.attachmentType,
        attachmentPreview: old.attachmentPreview,
        timestamp: old.timestamp,
        read: old.read,
        delivered: old.delivered,
        isDeleted: true,
      );
      messages.refresh();
    }
  }

  void _applyEditLocally(String messageId, String newText) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final old = messages[index];
      messages[index] = MessageModel(
        id: old.id,
        sender: old.sender,
        senderType: old.senderType,
        receiver: old.receiver,
        receiverType: old.receiverType,
        message: newText,
        attachments: old.attachments,
        attachmentType: old.attachmentType,
        attachmentPreview: old.attachmentPreview,
        timestamp: old.timestamp,
        read: old.read,
        delivered: old.delivered,
        isEdited: true,
      );
      messages.refresh();
    }
  }

  Future<void> pickAndSendFile() async {
    // Show bottom sheet to select file type
    final context = Get.context;
    if (context == null) return;

    // Import the bottom sheet widget
    _showFileSelectionBottomSheet(context);
  }

  /// Show bottom sheet for file type selection
  void _showFileSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
              margin: const EdgeInsets.only(bottom: 20),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Select File Type',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins-SemiBold',
                  color: Colors.black,
                ),
              ),
            ),

            // Image option
            GestureDetector(
              onTap: () {
                Get.back();
                _pickImage();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.image, color: Colors.blue, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Image',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins-Medium',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'JPG, PNG, GIF, WebP',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins-Light',
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Document option
            GestureDetector(
              onTap: () {
                Get.back();
                _pickDocument();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.description,
                        color: Colors.orange,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Document',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins-Medium',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'PDF, DOC, DOCX, XLS, XLSX',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins-Light',
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Cancel button
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins-Medium',
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile == null) return;

      await _sendFile(XFile(pickedFile.path));
    } catch (e) {
      debugPrint('❌ [DirectMessage] Image picker error: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Pick document (PDF, DOC, DOCX, XLS, XLSX)
  Future<void> _pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
        withData: false,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      final xFile = XFile(file.path!);
      await _sendFile(xFile);
    } catch (e) {
      debugPrint('❌ [DirectMessage] Document picker error: $e');
      Get.snackbar(
        'Error',
        'Failed to pick document: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Send file (image or document)
  Future<void> _sendFile(XFile file) async {
    try {
      // Calculate file type and size once
      final fileType = _getFileType(file.name);
      final fileSize = File(file.path).lengthSync();
      final formattedSize = FileManagementService.instance.getFileSizeString(
        fileSize,
      );

      // 1. Optimistic UI Update
      final tempId = "temp_${DateTime.now().millisecondsSinceEpoch}";

      // Initialize upload progress
      uploadProgress[tempId] = 0.0;

      final tempMessage = MessageModel(
        id: tempId,
        sender: currentUserId,
        senderType: 'Patient',
        receiver: doctorId,
        receiverType: 'Doctor',
        message: fileType == 'image' ? '' : '${file.name}|$formattedSize',
        attachments: [file.path],
        attachmentType: fileType,
        timestamp: DateTime.now(),
        read: false,
        delivered: false,
        isUploading: true,
      );

      messages.add(tempMessage);
      messages.refresh();

      // 2. API Upload with progress tracking
      final user = FirebaseAuth.instance.currentUser;
      final uploadResponse = await appService.uploadChatFile(
        file,
        doctorId,
        user,
        onProgress: (progress) {
          uploadProgress[tempId] = progress;
          debugPrint(
            '📤 [DirectMessage] Upload progress: ${(progress * 100).toStringAsFixed(1)}%',
          );
        },
      );

      // Mark upload as complete
      uploadProgress[tempId] = 1.0;

      final String fileUrl = uploadResponse['url'];

      // NOTE: Do NOT call socketService.sendMessage() here.
      // The upload endpoint already creates the message on the server
      // and broadcasts via socket (newMessage event). Calling sendMessage
      // again would create a duplicate message.

      // 3. Update local message with server URL
      _replaceTempWithRealMessage(tempId, fileUrl: fileUrl);

      // Clean up progress tracker
      uploadProgress.remove(tempId);

      debugPrint('✅ [DirectMessage] $fileType sent and synced');
    } catch (e) {
      debugPrint('❌ [DirectMessage] File upload error: $e');
      messages.removeWhere((m) => m.id.startsWith("temp_"));

      // Clean up progress tracker on error
      final failedIds = uploadProgress.keys
          .where((id) => id.startsWith("temp_"))
          .toList();
      for (final id in failedIds) {
        uploadProgress.remove(id);
      }

      Get.snackbar(
        'Upload Error',
        'Could not send file. Please check your connection.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Add this helper to determine the file type for the socket/API
  String _getFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
      return 'image';
    } else if (['pdf', 'doc', 'docx', 'xls', 'xlsx'].contains(extension)) {
      return 'document';
    }
    return 'file';
  }

  /// Update local message with real URL and optionally server ID
  void _replaceTempWithRealMessage(
    String tempId, {
    required String fileUrl,
    String? serverId,
  }) {
    final index = messages.indexWhere((m) => m.id == tempId);
    if (index != -1) {
      final oldMessage = messages[index];
      final finalId = serverId ?? tempId; // Use server ID if provided

      final updatedMessage = MessageModel(
        id: finalId,
        sender: oldMessage.sender,
        senderType: oldMessage.senderType,
        receiver: oldMessage.receiver,
        receiverType: oldMessage.receiverType,
        message: oldMessage.message,
        attachments: [fileUrl],
        attachmentType: oldMessage.attachmentType,
        timestamp: oldMessage.timestamp,
        read: oldMessage.read,
        delivered: true,
        isUploading: false,
      );
      messages[index] = updatedMessage;

      // Store mapping if server ID is different
      if (serverId != null && serverId != tempId) {
        _tempToRealIdMap[tempId] = finalId;
      }

      messages.refresh();
      debugPrint('✅ [DirectMessage] Temp message updated with server URL');
    }
  }
}
