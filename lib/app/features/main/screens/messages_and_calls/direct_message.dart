import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nurahelp/app/common/appbar/appbar.dart';
import 'package:nurahelp/app/common/widgets/message_status_tick.dart';
import 'package:nurahelp/app/common/widgets/no_internet_screen.dart';
import 'package:nurahelp/app/common/widgets/unstable_internet_screen.dart';
import 'package:nurahelp/app/data/models/doctor_model.dart';
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
    final controller = Get.put(DirectMessageController(doctor: doctor));

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

                    // Check if we need to show date header
                    bool showDateHeader = false;
                    if (index == controller.messages.length - 1) {
                      // Always show date for first message (oldest)
                      showDateHeader = true;
                    } else {
                      // Check if date changed from previous message
                      // In a reversed list, the "previous" message has a smaller index
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? AppColors.secondaryColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(15),
                                    topRight: const Radius.circular(15),
                                    bottomLeft: Radius.circular(isMe ? 15 : 0),
                                    bottomRight: Radius.circular(isMe ? 0 : 15),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.message,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins-Regular',
                                        color: isMe
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${message.timestamp.toLocal().hour}:${message.timestamp.toLocal().minute.toString().padLeft(2, '0')}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'Poppins-Light',
                                            color: isMe
                                                ? Colors.white70
                                                : Colors.grey[600],
                                          ),
                                        ),
                                        if (isMe) ...[
                                          const SizedBox(width: 4),
                                          MessageStatusTick(
                                            delivered: message.delivered,
                                            read: message.read,
                                            color: Colors.white70,
                                            size: 14,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
              child: CustomTextField(
                controller: controller.messageController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.onTyping();
                  }
                },
                onSendButtonPressed: controller.sendMessage,
                onMicButtonPressed: () {},
                onAttachButtonPressed: () {},
              ),
            ),
          ],
        ),
      );
    });
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
