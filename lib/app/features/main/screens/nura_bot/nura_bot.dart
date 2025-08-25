import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nurahelp/app/common/appbar/appbar_with_bell.dart';
import 'package:nurahelp/app/common/message_field/message_field.dart';
import 'package:nurahelp/app/features/main/controllers/nura_bot/nura_bot_controller.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/nav_menu.dart';
import '../../../../data/models/message_models/bot_message_model.dart';
import '../../../../utilities/constants/colors.dart';

class NuraBot extends StatelessWidget {
  const NuraBot({super.key, this.messageFromDashboard});

  final String? messageFromDashboard;

  @override
  Widget build(BuildContext context) {
    final _controller = Get.put(NuraBotController());
    final _patientController = Get.find<PatientController>();

    return WillPopScope(
      onWillPop:() async{
        Get.offAll(()=>NavigationMenu());
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Important
        appBar: AppBarWithBell(showSearchBar: false), // Instead of positioned
        body: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (_controller.conversations.isEmpty) {
                  return Center(
                    child: Text(
                      'What\'s on the agenda ?',
                      style: TextStyle(fontSize: 26, letterSpacing: -2),
                    ),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: _controller.conversations.length,
                  itemBuilder: (context, index) {
                    final message = _controller.conversations[index];
                    return Align(
                      alignment: message.sender == SenderType.user
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: message.sender == SenderType.user ? 0 : 10,
                          right: message.sender == SenderType.user ? 10 : 0,
                        ),
                        child: MessageBubble(
                          message: message,
                          botIsReplying: _controller.isReplying.value,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 1, left: 10, bottom: 15),
              child: IntrinsicHeight(
                child: CustomTextField(
                  controller: _controller.messageController,
                  onSendButtonPressed: () => _controller.sendBotMessage(
                    patient: _patientController.patient.value,
                  ),
                  onMicButtonPressed: () {},
                  onAttachButtonPressed: () {},
                  showBorder: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message, required this.botIsReplying});

  final BotMessageModel message;
  final bool botIsReplying;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Column(
        spacing: 3,
        crossAxisAlignment: message.sender == SenderType.user
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.85,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: message.sender == SenderType.user
                    ? AppColors.secondaryColor
                    : AppColors.bluishWhiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: message.isLoading && message.sender == SenderType.bot?
                  Lottie.asset('assets/animations/chat_loading.json',width: 350,height: 100)
                  :Text(
                message.message!,
                style: TextStyle(
                  color: message.sender == SenderType.user
                      ? Colors.white
                      : AppColors.black,
                  fontSize: 14,
                  fontFamily: message.sender == SenderType.user
                      ? 'Poppins-Regular'
                      : 'Poppins-Light',
                ),
              ),
            ),
          ),
          SizedBox.shrink(),
        ],
      ),
    );
  }
}
