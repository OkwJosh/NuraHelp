import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/models/patient_model.dart';
import 'package:nurahelp/app/data/services/nurabot_service.dart';

import '../../../../data/models/message_models/bot_message_model.dart';

class NuraBotController extends GetxController {
  static NuraBotController get instance => Get.find();

  final _nuraBotService = NuraBotService();
  final messageController = TextEditingController();

  final conversations = <BotMessageModel>[].obs;
  final isReplying = false.obs;

  Future<void> sendBotMessage({
    File? documentFile,
    required PatientModel patient,
  }) async {
    final context = Get.context;
    if (context != null) {
      FocusScope.of(context).unfocus();
    }

    final query = messageController.text.trim();
    if (query.isEmpty) return;

    isReplying.value = true;
    BotMessageModel? placeholderMessage;

    try {
      final message = BotMessageModel(
        userId: patient.id!,
        message: query,
        documentFile: documentFile,
        sender: SenderType.user,
        threadId: patient.id,
      );

      conversations.insert(0, message);
      messageController.clear();

      placeholderMessage = BotMessageModel(
        sender: SenderType.bot,
        isLoading: true,
      );
      conversations.insert(0, placeholderMessage);

      // Get reply
      final reply = await _nuraBotService.sendChatMessage(
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
      // Remove placeholder on error
      if (placeholderMessage != null) {
        conversations.remove(placeholderMessage);
      }
      // Show error to user
      Get.snackbar('Error', 'Failed to send message: ${e.toString()}');
      rethrow;
    } finally {
      isReplying.value = false;
    }
  }

  bool checkForLastMessage(List items, dynamic item) {
    return items.isNotEmpty && items.last == item;
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
