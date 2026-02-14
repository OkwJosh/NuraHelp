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

  static const int networkTimeoutSeconds = 90; // 1.5 minutes

  @override
  void onInit() {
    super.onInit();
    debugPrint(
      '🟢 [DirectMessage] Controller initialized for doctor: ${doctor.name}',
    );
    _initializeSocket();
    _initializeNetworkManager();
    // Only fetch messages if not already loaded (like WhatsApp)
    if (messages.isEmpty) {
      fetchMessages();
    }
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
    connectivityCheckTimer = Timer.periodic(const Duration(seconds: 1), (
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

      debugPrint(
        '📥 [DirectMessage] Fetching chat history for doctor: $doctorId',
      );

      // Fetch chat history from API with timeout
      final response = await appService
          .getChatHistory(doctorId, user)
          .timeout(
            const Duration(seconds: networkTimeoutSeconds),
            onTimeout: () {
              hasNetworkTimeout.value = true;
              throw Exception('Network timeout - unstable internet connection');
            },
          );

      if (response['messages'] != null) {
        final List<dynamic> messagesList = response['messages'];
        messages.value = messagesList
            .map((json) => MessageModel.fromJson(json))
            .toList();
        debugPrint('✅ [DirectMessage] Loaded ${messages.length} messages');
      } else {
        debugPrint('⚠️ [DirectMessage] No messages in response');
      }

      // Mark all messages as read
      await _markAsRead();
    } catch (e) {
      debugPrint('❌ [DirectMessage] Error fetching messages: $e');
      // Retry once after a delay only if not a timeout
      if (!hasNetworkTimeout.value) {
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
    );

    messages.add(message);
    debugPrint(
      '✅ [DirectMessage] Message added to local list. Total messages: ${messages.length}',
    );

    messageController.clear();
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

  @override
  void onClose() {
    messageController.dispose();
    typingTimer?.cancel();
    connectivityCheckTimer?.cancel();
    super.onClose();
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
      // 1. Optimistic UI Update
      final tempId = "temp_${DateTime.now().millisecondsSinceEpoch}";
      final fileType = _getFileType(file.name);
      final fileSize = File(
        file.path,
      ).lengthSync(); // Get actual file size in bytes

      final tempMessage = MessageModel(
        id: tempId,
        sender: currentUserId,
        senderType: 'Patient',
        receiver: doctorId,
        receiverType: 'Doctor',
        message: fileType == 'image'
            ? ''
            : '${file.name}|${_formatFileSize(fileSize)}',
        attachments: [file.path],
        attachmentType: fileType,
        timestamp: DateTime.now(),
        read: false,
        delivered: false,
        isUploading: true,
      );

      messages.add(tempMessage);
      messages.refresh();

      // 2. API Upload
      final user = FirebaseAuth.instance.currentUser;
      final uploadResponse = await appService.uploadChatFile(
        file,
        doctorId,
        user,
      );

      final String fileUrl = uploadResponse['url'];

      // 3. Socket Broadcast
      socketService.sendMessage(
        sender: currentUserId,
        senderType: 'Patient',
        receiver: doctorId,
        message: fileType == 'image'
            ? ''
            : '${file.name}|${_formatFileSize(fileSize)}',
        attachments: [fileUrl],
        attachmentType: fileType,
      );

      // 4. Update local message with server URL (don't refetch to avoid duplicates)
      _replaceTempWithRealMessage(tempId, fileUrl: fileUrl);

      debugPrint('✅ [DirectMessage] ${fileType} sent and synced');
    } catch (e) {
      debugPrint('❌ [DirectMessage] File upload error: $e');
      messages.removeWhere((m) => m.id.startsWith("temp_"));
      Get.snackbar(
        'Upload Error',
        'Could not send file. Please check your connection.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Format file size to human-readable format
  String _formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    final i = (bytes.toString().length / 3).floor();
    final newSize = bytes / (1000 * (1 << (i * 10)));
    return "${newSize.toStringAsFixed(2)} ${suffixes[i]}";
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

  /// Update local message with real URL from server
  void _replaceTempWithRealMessage(String tempId, {required String fileUrl}) {
    final index = messages.indexWhere((m) => m.id == tempId);
    if (index != -1) {
      final oldMessage = messages[index];
      final updatedMessage = MessageModel(
        id: oldMessage.id,
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
      messages.refresh();
      debugPrint('✅ [DirectMessage] Temp message updated with server URL');
    }
  }
}
