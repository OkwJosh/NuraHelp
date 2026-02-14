import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nurahelp/app/data/models/message_models/conversation_model.dart';
import 'package:nurahelp/app/data/models/message_models/message_model.dart';
import 'package:nurahelp/app/data/services/app_service.dart';
import 'package:nurahelp/app/data/services/cache_service.dart';
import 'package:nurahelp/app/data/services/network_manager.dart';
import 'package:nurahelp/app/data/services/socket_service.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/features/main/screens/messages_and_calls/direct_message.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';

class MessagesController extends GetxController {
  static MessagesController get instance => Get.find();

  final RxList<ConversationModel> conversations = <ConversationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasNetworkTimeout = false.obs;
  final RxBool hasNoInternet = false.obs; // New: Track no internet
  late SocketService socketService;
  late AppNetworkManager networkManager;
  final appService = AppService.instance;

  static const int networkTimeoutSeconds = 90; // 1.5 minutes

  @override
  void onInit() {
    super.onInit();
    try {
      networkManager = Get.find<AppNetworkManager>();
    } catch (e) {
      networkManager = AppNetworkManager();
    }
    _initializeSocket();
    // Start fetching conversations asynchronously
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Small delay to ensure socket is initialized
    await Future.delayed(const Duration(milliseconds: 100));
    await fetchConversations();
  }

  void _initializeSocket() {
    try {
      socketService = Get.find<SocketService>();
    } catch (e) {
      // Initialize socket service if not found
      socketService = Get.put(SocketService());
      final patientController = Get.find<PatientController>();
      final userId = patientController.patient.value.id ?? '';

      // Use backend URL from environment
      final baseUrl =
          dotenv.env['NEXT_PUBLIC_API_URL'] ?? 'http://localhost:3000';
      debugPrint(
        '🔌 [MessagesController] Initializing socket with URL: $baseUrl',
      );
      socketService.init(baseUrl, userId);
    }

    // Add this controller as a listener for new messages
    socketService.addNewMessageListener(_handleNewMessage);
    debugPrint('✅ [MessagesController] Added new message listener');

    // Listen for messages read events to update conversation read status
    socketService.onMessagesRead = (readerId) {
      _handleMessagesRead(readerId);
    };
  }

  /// Refresh conversations (force API call and clear cache)
  Future<void> refreshConversations() async {
    debugPrint('🔄 [MessagesController] Force refreshing conversations...');
    isLoading.value = true; // Show shimmer while retrying
    hasNetworkTimeout.value = false;
    hasNoInternet.value = false;
    await CacheService.instance.clearConversationsCache();
    await fetchConversations();
  }

  void _handleMessagesRead(String readerId) {
    debugPrint('👁️ [MessagesController] Messages read by: $readerId');

    final index = conversations.indexWhere((conv) => conv.userId == readerId);
    if (index != -1) {
      final conversation = conversations[index];
      final updatedConversation = ConversationModel(
        userId: conversation.userId,
        userName: conversation.userName,
        userProfilePic: conversation.userProfilePic,
        userType: conversation.userType,
        userEmail: conversation.userEmail,
        lastMessage: conversation.lastMessage,
        lastTimestamp: conversation.lastTimestamp,
        lastSender: conversation.lastSender,
        unreadCount: 0, // Mark all as read
        lastMessageDelivered: conversation.lastMessageDelivered,
        lastMessageRead: true, // Mark as read
      );

      // Create new list with updated conversation
      final updatedList = conversations.toList();
      updatedList[index] = updatedConversation;
      conversations.value = updatedList;

      debugPrint('✅ [MessagesController] Updated conversation read status');
    }
  }

  void _handleNewMessage(MessageModel message) {
    debugPrint('📬 [MessagesController] _handleNewMessage called');
    debugPrint('📬 [MessagesController] Message: ${message.message}');
    debugPrint('📬 [MessagesController] Sender: ${message.sender}');
    debugPrint('📬 [MessagesController] Receiver: ${message.receiver}');

    // Get current user ID
    final patientController = Get.find<PatientController>();
    final currentUserId = patientController.patient.value.id ?? '';
    debugPrint('📬 [MessagesController] Current User ID: $currentUserId');

    // Determine the other user (doctor) in the conversation
    final otherUserId = message.sender == currentUserId
        ? message.receiver
        : message.sender;
    debugPrint('📬 [MessagesController] Other User (Doctor) ID: $otherUserId');

    // Update conversation list with new message
    final index = conversations.indexWhere(
      (conv) => conv.userId == otherUserId,
    );
    debugPrint('📬 [MessagesController] Existing conversation index: $index');

    if (index != -1) {
      // Update existing conversation
      final conversation = conversations[index];
      debugPrint(
        '📬 [MessagesController] Updating existing conversation with ${conversation.userName}',
      );

      // Create updated conversation
      final displayMessage = message.isVoice
          ? '🎤 Voice note'
          : message.isImage
          ? '📷 Photo'
          : MessageModel.friendlyPreview(message.message);
      final updatedConversation = ConversationModel(
        userId: conversation.userId,
        userName: conversation.userName,
        userProfilePic: conversation.userProfilePic,
        userType: conversation.userType,
        userEmail: conversation.userEmail,
        lastMessage: displayMessage,
        lastTimestamp: message.timestamp,
        lastSender: message.sender,
        unreadCount: message.sender == currentUserId
            ? conversation.unreadCount
            : conversation.unreadCount + 1,
        lastMessageDelivered: message.delivered,
        lastMessageRead: message.read,
      );

      // Create new list with updated conversation at top
      final updatedList = <ConversationModel>[updatedConversation];
      for (int i = 0; i < conversations.length; i++) {
        if (i != index) {
          updatedList.add(conversations[i]);
        }
      }
      conversations.value = updatedList;

      debugPrint(
        '✅ [MessagesController] Conversation updated and moved to top. Total: ${conversations.length}',
      );
    } else {
      // Create new conversation with doctor's info from patient data
      final doctor = patientController.patient.value.doctor;
      debugPrint(
        '📬 [MessagesController] Doctor from patient: ${doctor?.name}',
      );
      debugPrint('📬 [MessagesController] Doctor ID: ${doctor?.id}');

      if (doctor != null && doctor.id == otherUserId) {
        final displayMsg = message.isVoice
            ? '🎤 Voice note'
            : message.isImage
            ? '📷 Photo'
            : MessageModel.friendlyPreview(message.message);
        final newConversation = ConversationModel(
          userId: doctor.id!,
          userName: doctor.name,
          userProfilePic: doctor.profilePicture,
          userType: 'Doctor',
          lastMessage: displayMsg,
          lastTimestamp: message.timestamp,
          lastSender: message.sender,
          unreadCount: message.sender == currentUserId ? 0 : 1,
          lastMessageDelivered: message.delivered,
          lastMessageRead: message.read,
        );

        // Create new list with new conversation at top
        conversations.value = [newConversation, ...conversations];

        debugPrint(
          '✅ [MessagesController] Created new conversation with ${doctor.name}. Total: ${conversations.length}',
        );
        debugPrint(
          '✅ [MessagesController] Profile pic: ${doctor.profilePicture}',
        );
      } else {
        debugPrint(
          '⚠️ [MessagesController] Doctor info not available or ID mismatch',
        );
        // Fallback: fetch from API if doctor info not available
        fetchConversations();
      }
    }
  }

  Future<void> fetchConversations() async {
    try {
      isLoading.value = true;
      hasNetworkTimeout.value = false;
      hasNoInternet.value = false;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        debugPrint('⚠️ [MessagesController] No authenticated user found');
        return;
      }

      // Check internet before fetching
      final isConnected = await networkManager.isConnected();
      if (!isConnected) {
        hasNoInternet.value = true;
        isLoading.value = false;
        return;
      }

      final fetchedConversations = await appService
          .getConversations(user)
          .timeout(
            const Duration(seconds: networkTimeoutSeconds),
            onTimeout: () {
              hasNetworkTimeout.value = true;
              throw Exception('Network timeout - unstable internet connection');
            },
          );

      debugPrint(
        '📋 [MessagesController] Fetched ${fetchedConversations.length} conversations',
      );

      // Enrich conversations with doctor info if missing
      final patientController = Get.find<PatientController>();
      final doctor = patientController.patient.value.doctor;

      final enrichedConversations = fetchedConversations.map((conv) {
        // If conversation has empty name and we have a linked doctor with matching ID, use doctor's info
        if ((conv.userName.isEmpty || conv.userName == '') &&
            doctor != null &&
            doctor.id == conv.userId) {
          debugPrint(
            '🔧 [MessagesController] Enriching conversation with doctor info',
          );
          return ConversationModel(
            userId: conv.userId,
            userName: doctor.name,
            userProfilePic: doctor.profilePicture,
            userType: 'Doctor',
            lastMessage: conv.lastMessage,
            lastTimestamp: conv.lastTimestamp,
            lastSender: conv.lastSender,
            unreadCount: conv.unreadCount,
            lastMessageDelivered: conv.lastMessageDelivered,
            lastMessageRead: conv.lastMessageRead,
          );
        }
        return conv;
      }).toList();

      conversations.value = enrichedConversations;

      for (var conv in enrichedConversations) {
        debugPrint(
          '  - ${conv.userName} (${conv.userId}): ${conv.lastMessage}',
        );
      }
    } catch (e) {
      debugPrint('❌ [MessagesController] Error fetching conversations: $e');
      // Retry once after a delay
      await Future.delayed(const Duration(seconds: 1));
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final fetchedConversations = await appService.getConversations(user);
          conversations.value = fetchedConversations;
          debugPrint('✅ [MessagesController] Retry successful');
        }
      } catch (retryError) {
        debugPrint('❌ [MessagesController] Retry failed: $retryError');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void showMessageBottomSheet(BuildContext context) {
    final patientController = Get.find<PatientController>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Start a Conversation',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins-SemiBold',
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Select a doctor to message',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins-Regular',
                  color: AppColors.black300,
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                final doctor = patientController.patient.value.doctor;

                if (doctor == null) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_off_outlined,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'No doctor linked',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins-Regular',
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 0.2,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => DirectMessagePage(doctor: doctor));
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.black300.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColors.secondaryColor
                                .withOpacity(0.2),
                            backgroundImage: doctor.profilePicture.isNotEmpty
                                ? NetworkImage(doctor.profilePicture)
                                : null,
                            child: doctor.profilePicture.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    color: AppColors.secondaryColor,
                                    size: 30,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dr. ${doctor.name}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins-Medium',
                                  ),
                                ),
                                Text(
                                  doctor.specialty,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins-Regular',
                                    color: AppColors.black300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.message_outlined,
                              color: AppColors.primaryColor,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  void onClose() {
    // Remove listener when controller is disposed
    socketService.removeNewMessageListener(_handleNewMessage);
    super.onClose();
  }
}
