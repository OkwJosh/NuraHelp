import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/models/doctor_model.dart';
import 'package:nurahelp/app/data/models/message_models/message_model.dart';
import 'package:nurahelp/app/data/services/app_service.dart';
import 'package:nurahelp/app/data/services/socket_service.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';

class DirectMessageController extends GetxController {
  final DoctorModel doctor;

  DirectMessageController({required this.doctor});

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isTyping = false.obs;
  final TextEditingController messageController = TextEditingController();

  late SocketService socketService;
  late String currentUserId;
  late String doctorId;
  Timer? typingTimer;
  final appService = AppService.instance;

  @override
  void onInit() {
    super.onInit();
    debugPrint(
      '🟢 [DirectMessage] Controller initialized for doctor: ${doctor.name}',
    );
    _initializeSocket();
    // Delay message fetching slightly to ensure socket is ready
    Future.delayed(const Duration(milliseconds: 100), () {
      _fetchMessages();
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

  Future<void> _fetchMessages() async {
    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        debugPrint('⚠️ [DirectMessage] No authenticated user found');
        return;
      }

      debugPrint(
        '📥 [DirectMessage] Fetching chat history for doctor: $doctorId',
      );

      // Fetch chat history from API
      final response = await appService.getChatHistory(doctorId, user);

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
      // Retry once after a delay
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
    super.onClose();
  }
}
