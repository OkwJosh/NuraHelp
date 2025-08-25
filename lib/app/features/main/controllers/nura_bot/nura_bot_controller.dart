import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/models/patient_model.dart';
import 'package:nurahelp/app/data/services/nurabot_service.dart';

import '../../../../data/models/message_models/bot_message_model.dart';

class NuraBotController extends GetxController{
  static NuraBotController get instance => Get.find();


  final nuraBotService = NuraBotService();
  final TextEditingController messageController = TextEditingController();
  var conversations = <BotMessageModel>[].obs;
  Rx<bool> notReceivedAMessage = true.obs;
  int? lastIndex;
  Rx<bool> showMessageStatus = false.obs;
  Rx<bool> isReplying = false.obs;




  void sendBotMessage({File? documentFile, required PatientModel patient}) async {
    FocusScope.of(Get.context!).unfocus();


    try {
      final query = messageController.text.trim();
      final message = BotMessageModel(
        userId: patient.id!,
        message: query,
        documentFile: documentFile,
        sender: SenderType.user,
        threadId: await FirebaseAuth.instance.currentUser?.getIdToken(),
      );

      conversations.insert(0, message);
      messageController.clear();

      final placeholderMessage = BotMessageModel(
        sender: SenderType.bot,
        isLoading: true,
      );
      conversations.insert(0, placeholderMessage);

      // Get reply
      final reply = await nuraBotService.sendChatMessage(
        threadId: message.userId!,
        query: query,
      );
      final index = conversations.indexOf(placeholderMessage);
      if (index != -1) {
        conversations[index] = BotMessageModel(
          sender: SenderType.bot,
          message: reply.message,
          threadId: reply.threadId,
          isLoading: false,
        );
      }
    } catch (e) {
      throw Exception('Failed to send query');
    }
  }



  bool checkForLastMessage(List items){
    if(items.indexOf(items) == items.lastIndexOf(items)){
      return true;
    }
    return false;
  }




  @override
  void dispose() {
    super.dispose();
    messageController.dispose();

  }


}