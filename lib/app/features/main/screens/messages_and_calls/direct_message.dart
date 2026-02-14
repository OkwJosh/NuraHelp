import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nurahelp/app/common/appbar/appbar.dart';
import 'package:nurahelp/app/common/widgets/chat_bubble.dart';
import 'package:nurahelp/app/common/widgets/no_internet_screen.dart';
import 'package:nurahelp/app/common/widgets/unstable_internet_screen.dart';
import 'package:nurahelp/app/common/widgets/voice_recording_widget.dart';
import 'package:nurahelp/app/data/models/doctor_model.dart';
import 'package:nurahelp/app/data/models/message_models/message_model.dart';
import 'package:nurahelp/app/features/main/controllers/patient/direct_message_controller.dart';
import 'package:nurahelp/app/modules/patient/views/direct_message/direct_message_shimmer.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import '../../../../common/message_field/message_field.dart';

class DirectMessagePage extends StatelessWidget {
  const DirectMessagePage({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    // Use a tag so each doctor gets its own controller, and reuse it if it
    // already exists so cached messages are preserved across navigations.
    final tag = doctor.id ?? doctor.name;
    final controller = Get.put(
      DirectMessageController(doctor: doctor),
      permanent: true,
      tag: tag,
    );

    // If the controller was reused (already has messages), trigger
    // an incremental fetch to pick up anything missed while away.
    if (controller.messages.isNotEmpty) {
      controller.onPageResumed();
    }

    return Obx(() {
      // Show no internet screen if internet is off
      if (controller.hasNoInternet.value) {
        return NoInternetScreen(
          onRetry: () {
            controller.fetchMessages();
          },
        );
      }

      // Show unstable internet screen if timeout happened
      if (controller.hasNetworkTimeout.value) {
        return UnstableInternetScreen(
          onRetry: () {
            controller.hasNetworkTimeout.value = false;
            controller.fetchMessages();
          },
        );
      }

      // Show shimmer while loading and no messages yet
      if (controller.isLoading.value && controller.messages.isEmpty) {
        return const DirectMessageShimmer();
      }

      return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: CustomAppBar(
                backgroundColor: Colors.white,
                leadingIcon: Icons.arrow_back_ios_sharp,
                leadingOnPressed: () => Get.back(),
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.secondaryColor.withOpacity(
                        0.2,
                      ),
                      backgroundImage: doctor.profilePicture.isNotEmpty
                          ? NetworkImage(doctor.profilePicture)
                          : null,
                      child: doctor.profilePicture.isEmpty
                          ? SvgIcon(AppIcons.profile)
                          : null,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. ${doctor.name}',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                        Obx(
                          () => Text(
                            controller.isTyping.value
                                ? 'typing...'
                                : doctor.specialty,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins-Light',
                              color: controller.isTyping.value
                                  ? AppColors.secondaryColor.withOpacity(0.6)
                                  : AppColors.greyColor.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // actions: [
                //   Row(
                //     children: [
                //       // IconButton(
                //       //   onPressed: () {},
                //       //   icon: SvgIcon(AppIcons.ellipsis),
                //       // ),
                //     ],
                //   ),
                // ],
              ),
            ),
            // Messages list
            Positioned.fill(
              top: 100,
              bottom: 90,
              child: Obx(() {
                if (controller.messages.isEmpty &&
                    !controller.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins-Medium',
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Start the conversation',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins-Regular',
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 32,
                  ),
                  reverse: true,
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller
                        .messages[controller.messages.length - 1 - index];
                    final isMe = message.senderType == 'Patient';

                    // [Date Header Logic - Keep existing logic here]
                    bool showDateHeader = false;
                    if (index == controller.messages.length - 1) {
                      showDateHeader = true;
                    } else {
                      final actualIndex =
                          controller.messages.length - 1 - index;
                      if (actualIndex > 0) {
                        final previousMessage =
                            controller.messages[actualIndex - 1];
                        final currentDate = DateTime(
                          message.timestamp.year,
                          message.timestamp.month,
                          message.timestamp.day,
                        );
                        final previousDate = DateTime(
                          previousMessage.timestamp.year,
                          previousMessage.timestamp.month,
                          previousMessage.timestamp.day,
                        );
                        showDateHeader = !currentDate.isAtSameMomentAs(
                          previousDate,
                        );
                      }
                    }

                    return Column(
                      children: [
                        if (showDateHeader) _buildDateHeader(message.timestamp),
                        _buildSwipeableMessage(
                          controller: controller,
                          message: message,
                          isMe: isMe,
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
            Positioned(
              bottom: 20,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Reply / Edit bar
                    Obx(() {
                      final replyMsg = controller.replyingTo.value;
                      // TODO: Uncomment when backend supports edit
                      // final editMsg = controller.editingMessage.value;
                      if (replyMsg != null) {
                        return _buildReplyBar(controller, replyMsg);
                      }
                      // if (editMsg != null) {
                      //   return _buildEditBar(controller, editMsg);
                      // }
                      return const SizedBox.shrink();
                    }),
                    Obx(() {
                      // Show voice recording widget when recording
                      if (controller.isRecordingVoice.value) {
                        return VoiceRecordingWidget(
                          onCancel: controller.cancelVoiceRecording,
                          onSend: controller.stopAndSendVoiceRecording,
                        );
                      }

                      // Show normal text field
                      return CustomTextField(
                        controller: controller.messageController,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            controller.onTyping();
                          }
                        },
                        onSendButtonPressed: controller.sendMessage,
                        onMicButtonPressed: controller.startVoiceRecording,
                        onAttachButtonPressed: () =>
                            controller.pickAndSendFile(),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Wraps a ChatBubble in a Dismissible so the user can swipe right to reply,
  /// and adds a long-press handler for delete / edit actions.
  Widget _buildSwipeableMessage({
    required DirectMessageController controller,
    required MessageModel message,
    required bool isMe,
  }) {
    // Don't allow interactions on deleted messages
    if (message.isDeleted) {
      return ChatBubble(message: message, isMe: isMe);
    }

    return Dismissible(
      key: Key('swipe_${message.id}'),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (_) async {
        controller.setReplyTo(message);
        return false; // don't actually remove the widget
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: Icon(Icons.reply, color: Colors.grey[600], size: 28),
      ),
      child: GestureDetector(
        onLongPress: () => _showMessageActions(
          controller: controller,
          message: message,
          isMe: isMe,
        ),
        child: ChatBubble(message: message, isMe: isMe),
      ),
    );
  }

  /// Reply preview bar shown above the input field.
  Widget _buildReplyBar(
    DirectMessageController controller,
    MessageModel replyMsg,
  ) {
    final isMyMessage = replyMsg.sender == controller.currentUserId;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: AppColors.secondaryColor, width: 3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isMyMessage ? 'You' : 'Dr. ${doctor.name}',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins-SemiBold',
                    color: AppColors.secondaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  replyMsg.displayText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins-Regular',
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: controller.clearReply,
            child: const Icon(Icons.close, size: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Edit bar shown above the input field when editing a message.
  /// TODO: Uncomment when backend supports edit
  // ignore: unused_element
  Widget _buildEditBar(
    DirectMessageController controller,
    MessageModel editMsg,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: Colors.orange, width: 3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.edit, size: 16, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Editing message',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins-SemiBold',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  editMsg.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins-Regular',
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: controller.cancelEditing,
            child: const Icon(Icons.close, size: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Long-press action sheet: Reply, Edit (own + ≤5 min), Delete for everyone (own)
  void _showMessageActions({
    required DirectMessageController controller,
    required MessageModel message,
    required bool isMe,
  }) {
    final context = Get.context;
    if (context == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Reply
              ListTile(
                leading: const Icon(Icons.reply),
                title: const Text('Reply'),
                onTap: () {
                  Get.back();
                  controller.setReplyTo(message);
                },
              ),

              // TODO: Uncomment when backend supports edit
              // Edit (own messages within 5 min, text only)
              // if (isMe && message.canEdit && !message.hasAttachment)
              //   ListTile(
              //     leading: const Icon(Icons.edit, color: Colors.orange),
              //     title: const Text('Edit'),
              //     onTap: () {
              //       Get.back();
              //       controller.startEditing(message);
              //     },
              //   ),

              // TODO: Uncomment when backend supports delete
              // Delete for everyone (own messages only)
              // if (isMe)
              //   ListTile(
              //     leading: const Icon(Icons.delete_forever, color: Colors.red),
              //     title: const Text(
              //       'Delete for everyone',
              //       style: TextStyle(color: Colors.red),
              //     ),
              //     onTap: () {
              //       Get.back();
              //       _confirmDelete(controller, message);
              //     },
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  /// Confirmation dialog before deleting.
  /// TODO: Uncomment when backend supports delete
  // ignore: unused_element
  void _confirmDelete(
    DirectMessageController controller,
    MessageModel message,
  ) {
    final context = Get.context;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete message?'),
        content: const Text(
          'This message will be deleted for everyone in this chat.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteMessageForEveryone(message.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    String dateText;
    if (messageDate.isAtSameMomentAs(today)) {
      dateText = 'Today';
    } else if (messageDate.isAtSameMomentAs(yesterday)) {
      dateText = 'Yesterday';
    } else if (now.difference(messageDate).inDays < 7) {
      dateText = DateFormat('EEEE').format(date); // Day name (e.g., Monday)
    } else {
      dateText = DateFormat('MMM d, yyyy').format(date); // e.g., Jan 18, 2026
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            dateText,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins-Medium',
              color: Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }
}
