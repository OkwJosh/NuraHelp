import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/models/patient_model.dart';
import 'package:nurahelp/app/data/services/nurabot_service.dart';
import 'package:nurahelp/app/data/services/file_picker_service.dart';
import 'package:nurahelp/app/data/controllers/file_controller.dart';

import '../../../../data/models/message_models/bot_message_model.dart';

class NuraBotController extends GetxController {
  static NuraBotController get instance => Get.find();

  final _nuraBotService = NuraBotService();
  final _filePickerService = FilePickerService();
  final _fileController = FileController.instance;
  final messageController = TextEditingController();

  final conversations = <BotMessageModel>[].obs;
  final isReplying = false.obs;

  /// Send bot message with optional attachment
  Future<void> sendBotMessage({
    File? documentFile,
    required PatientModel patient,
  }) async {
    final context = Get.context;
    if (context != null) {
      FocusScope.of(context).unfocus();
    }

    final query = messageController.text.trim();
    // final fileToAttach = documentFile ?? _fileController.file;

    // Allow sending message with attachment even if text is empty
    if (query.isEmpty ) {
      return;
    }

    isReplying.value = true;
    BotMessageModel? placeholderMessage;

    try {
      // Create message with attachment
      final message = BotMessageModel(
        userId: patient.id!,
        message: query,
        // documentFile: fileToAttach,
        sender: SenderType.user,
        threadId: patient.id,
        // attachmentName: _fileController.fileName,
        // attachmentType: _fileController.fileMimeType,
        // attachmentSize: _fileController.fileSize,
        // isUploading: fileToAttach != null,
        uploadProgress: 0.0,
      );

      conversations.insert(0, message);
      messageController.clear();

      // If there's an attachment, upload it to Firebase
      // if (fileToAttach != null) {
      //   await _uploadAttachment(message, patient.id!);
      // }

      // Clear attachment
      _fileController.clearAttachment();

      // Only send to bot if there's text
      if (query.isNotEmpty) {
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

  /// Upload attachment to Firebase Storage
  Future<void> _uploadAttachment(BotMessageModel message, String userId) async {
    try {
      if (message.documentFile == null) return;

      final fileName =
          message.attachmentName ?? message.documentFile!.path.split('/').last;
      final destination = 'chat_attachments/$userId/$fileName';

      final downloadUrl = await _filePickerService.uploadFileToFirebase(
        file: message.documentFile!,
        destination: destination,
        onProgress: (progress) {
          // Update message with progress
          final messageIndex = conversations.indexOf(message);
          if (messageIndex != -1) {
            final updatedMessage = BotMessageModel(
              userId: message.userId,
              threadId: message.threadId,
              message: message.message,
              documentFile: message.documentFile,
              sender: message.sender,
              isLoading: message.isLoading,
              attachmentPath: message.attachmentPath,
              attachmentName: message.attachmentName,
              attachmentType: message.attachmentType,
              uploadProgress: progress,
              isUploading: progress < 1.0,
              attachmentSize: message.attachmentSize,
            );
            conversations[messageIndex] = updatedMessage;
          }
        },
      );

      if (downloadUrl != null) {
        // Update message with final URL
        final messageIndex = conversations.indexOf(message);
        if (messageIndex != -1) {
          final updatedMessage = BotMessageModel(
            userId: message.userId,
            threadId: message.threadId,
            message: message.message,
            documentFile: message.documentFile,
            sender: message.sender,
            isLoading: message.isLoading,
            attachmentPath: downloadUrl,
            attachmentName: message.attachmentName,
            attachmentType: message.attachmentType,
            uploadProgress: 1.0,
            isUploading: false,
            attachmentSize: message.attachmentSize,
          );
          conversations[messageIndex] = updatedMessage;
        }
      }
    } catch (e) {
      Get.snackbar('Upload Error', 'Failed to upload attachment: $e');
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
