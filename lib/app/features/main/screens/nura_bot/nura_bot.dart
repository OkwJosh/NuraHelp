import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nurahelp/app/common/message_field/message_field.dart';
import 'package:nurahelp/app/common/attachment_preview/attachment_preview.dart';
import 'package:nurahelp/app/common/attachment_bubble/attachment_bubble.dart';
import 'package:nurahelp/app/common/widgets/voice_recording_widget.dart';
import 'package:nurahelp/app/features/main/controllers/nura_bot/nura_bot_controller.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/features/main/controllers/dashboard/dashboard_controller.dart';
import '../../../../data/models/message_models/bot_message_model.dart';
import '../../../../utilities/constants/colors.dart';

class NuraBot extends StatefulWidget {
  const NuraBot({super.key, this.messageFromDashboard});

  final String? messageFromDashboard;

  @override
  State<NuraBot> createState() => _NuraBotState();
}

class _NuraBotState extends State<NuraBot> {
  late final NuraBotController _controller;
  late final PatientController _patientController;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(NuraBotController());
    _patientController = Get.find<PatientController>();
  }

  void _handleBack() {
    // Unfocus keyboard and clear text field before going back
    FocusScope.of(context).unfocus();
    _controller.messageController.clear();
    // Silently refresh appointments in the background
    if (Get.isRegistered<DashboardController>()) {
      DashboardController.instance.silentRefreshAppointments();
    }
    // Navigate back (preserves existing controllers & state)
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleBack();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(
              top: 40,
              left: 15,
              right: 15,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _handleBack,
                  icon: const Icon(Icons.arrow_back_ios),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
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
            Obx(() {
              return Column(
                children: [
                  // Attachment preview
                  if (_controller.selectedFile.value != null)
                    AttachmentPreview(
                      file: _controller.selectedFile.value!,
                      fileName: _controller.selectedFileName.value,
                      mimeType: _controller.selectedFileMimeType.value,
                      fileSize: _controller.selectedFileSize.value,
                      onRemove: () => _controller.clearAttachment(),
                    ),

                  // Voice recording widget OR normal text field
                  if (_controller.isRecordingVoice.value)
                    VoiceRecordingWidget(
                      onCancel: _controller.cancelVoiceRecording,
                      onSend: () => _controller.stopAndSendVoiceRecording(
                        patient: _patientController.patient.value,
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 1,
                        left: 10,
                        bottom: 15,
                      ),
                      child: IntrinsicHeight(
                        child: CustomTextField(
                          controller: _controller.messageController,
                          onSendButtonPressed: () => _controller.sendBotMessage(
                            patient: _patientController.patient.value,
                          ),
                          onMicButtonPressed: () =>
                              _controller.startVoiceRecording(),
                          onAttachButtonPressed: () =>
                              _controller.showAttachmentOptions(),
                        ),
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.botIsReplying,
  });

  final BotMessageModel message;
  final bool botIsReplying;

  @override
  Widget build(BuildContext context) {
    final isUserMessage = message.sender == SenderType.user;

    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Column(
        spacing: 3,
        crossAxisAlignment: isUserMessage
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // Display attachment if present
          if (message.hasAttachment)
            AttachmentBubble(message: message, isUserMessage: isUserMessage),

          // Display loading indicator or text message
          if (message.isLoading && message.sender == SenderType.bot)
            Container(
              decoration: BoxDecoration(
                color: AppColors.bluishWhiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Lottie.asset(
                'assets/animations/chat_loading.json',
                width: 60,
                height: 36,
              ),
            )
          else if ((message.message?.isNotEmpty ?? false))
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.85,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: isUserMessage
                      ? AppColors.secondaryColor
                      : AppColors.bluishWhiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  message.message!,
                  style: TextStyle(
                    color: isUserMessage ? Colors.white : AppColors.black,
                    fontSize: 14,
                    fontFamily: isUserMessage
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
