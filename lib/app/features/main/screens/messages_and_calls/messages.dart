import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/common/list_tiles/message_list_tile.dart';
import 'package:nurahelp/app/features/main/controllers/patient/messages_controller.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/modules/patient/views/messages/messages_shimmer.dart';
import 'package:nurahelp/app/routes/app_routes.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import '../../../../common/search_bar/search_bar.dart';
import '../../../../utilities/constants/colors.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PatientController>();
    final messagesController = Get.put(MessagesController());

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          messagesController.showMessageBottomSheet(context);
        },
        backgroundColor: AppColors.secondaryColor,
        child: SvgPicture.asset(AppIcons.messages, color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins-SemiBold',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: 100,
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Obx(() {
                if (messagesController.isLoading.value) {
                  return const MessagesShimmer();
                }

                if (messagesController.conversations.isEmpty) {
                  return _buildNoMessagesView(context);
                }

                return RefreshIndicator(
                  onRefresh: () => messagesController.refreshConversations(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        AppSearchBar(hintText: 'Search type of Keywords'),
                        SizedBox(height: 20),
                        ...messagesController.conversations.map(
                          (conversation) => MessageListTile(
                            onPressed: () {
                              if (controller.patient.value.doctor != null) {
                                Get.toNamed(
                                  AppRoutes.directMessage,
                                  arguments: controller.patient.value.doctor,
                                );
                              }
                            },
                            contactName: conversation.userName,
                            lastMessage: conversation.lastMessage,
                            unreadMessagesNumber: conversation.unreadCount,
                            profilePicture: conversation.userProfilePic,
                            timestamp: conversation.lastTimestamp,
                            backgroundColor: Colors.transparent,
                            lastSender: conversation.lastSender,
                            currentUserId: controller.patient.value.id,
                            delivered: conversation.lastMessageDelivered,
                            read: conversation.lastMessageRead,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoMessagesView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.messages,
              color: Colors.grey[300],
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              'No Messages Yet',
              style: TextStyle(fontSize: 22, fontFamily: 'Poppins-SemiBold'),
            ),
            const SizedBox(height: 10),
            Text(
              'Start a conversation with your doctor or healthcare provider',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-Regular',
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
