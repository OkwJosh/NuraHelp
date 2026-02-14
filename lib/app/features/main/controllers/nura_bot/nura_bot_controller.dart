import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurahelp/app/data/models/patient_model.dart';
import 'package:nurahelp/app/data/services/nurabot_service.dart';
import 'package:nurahelp/app/data/services/file_picker_service.dart';
import 'package:nurahelp/app/data/services/network_manager.dart';
import 'package:nurahelp/app/data/services/audio_recorder_service.dart';

import '../../../../data/models/message_models/bot_message_model.dart';

class NuraBotController extends GetxController {
  static NuraBotController get instance => Get.find();

  final _nuraBotService = NuraBotService();
  final _filePickerService = FilePickerService();
  final messageController = TextEditingController();
  final _imagePicker = ImagePicker();

  final conversations = <BotMessageModel>[].obs;
  final isReplying = false.obs;

  // Attachment state
  final selectedFile = Rxn<File>();
  final selectedFileName = ''.obs;
  final selectedFileMimeType = ''.obs;
  final selectedFileSize = ''.obs;

  // Voice recording state
  final isRecordingVoice = false.obs;

  AudioRecorderService get _audioRecorderService {
    if (!Get.isRegistered<AudioRecorderService>()) {
      Get.put(AudioRecorderService());
    }
    return Get.find<AudioRecorderService>();
  }

  // ─── Attachment Picking ───────────────────────────────────────────

  /// Pick an image from gallery or camera
  Future<void> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1920,
      );
      if (picked == null) return;

      final file = File(picked.path);
      selectedFile.value = file;
      selectedFileName.value = picked.name;
      selectedFileMimeType.value = _filePickerService.getMimeType(picked.path);
      selectedFileSize.value = _filePickerService.formatFileSize(
        await file.length(),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  /// Pick a document (PDF, DOC, etc.)
  Future<void> pickDocument() async {
    try {
      final result = await _filePickerService.pickFile(type: FileType.any);
      if (result == null || result.files.isEmpty) return;

      final picked = result.files.first;
      if (picked.path == null) return;

      final file = File(picked.path!);
      selectedFile.value = file;
      selectedFileName.value = picked.name;
      selectedFileMimeType.value = _filePickerService.getMimeType(picked.path!);
      selectedFileSize.value = _filePickerService.formatFileSize(picked.size);
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick document: $e');
    }
  }

  /// Remove the currently selected attachment
  void clearAttachment() {
    selectedFile.value = null;
    selectedFileName.value = '';
    selectedFileMimeType.value = '';
    selectedFileSize.value = '';
  }

  /// Show attachment picker bottom sheet (matches doctor messaging style)
  void showAttachmentOptions() {
    final context = Get.context;
    if (context == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
              margin: const EdgeInsets.only(bottom: 20),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Select File Type',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins-SemiBold',
                  color: Colors.black,
                ),
              ),
            ),

            // Image option
            GestureDetector(
              onTap: () {
                Get.back();
                pickImage(source: ImageSource.gallery);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.image, color: Colors.blue, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Image',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins-Medium',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'JPG, PNG, GIF, WebP',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins-Light',
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Document option
            GestureDetector(
              onTap: () {
                Get.back();
                pickDocument();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.description,
                        color: Colors.orange,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Document',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins-Medium',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'PDF, DOC, DOCX, XLS, XLSX',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins-Light',
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Cancel button
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins-Medium',
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Voice Recording ──────────────────────────────────────────────

  /// Start voice recording
  Future<void> startVoiceRecording() async {
    try {
      await _audioRecorderService.startRecording();
      isRecordingVoice.value = true;
      debugPrint('🎤 [NuraBot] Voice recording started');
    } catch (e) {
      debugPrint('❌ [NuraBot] Error starting voice recording: $e');
      Get.snackbar(
        'Recording Error',
        'Failed to start voice recording',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Stop recording and set as attachment to send
  Future<void> stopAndSendVoiceRecording({
    required PatientModel patient,
  }) async {
    try {
      final audioPath = await _audioRecorderService.stopRecording();
      isRecordingVoice.value = false;

      if (audioPath != null && audioPath.isNotEmpty) {
        final audioFile = File(audioPath);
        if (await audioFile.exists()) {
          final fileSize = await audioFile.length();

          // Set as attachment
          selectedFile.value = audioFile;
          selectedFileName.value = audioPath.split('/').last;
          selectedFileMimeType.value = 'audio/m4a';
          selectedFileSize.value = _filePickerService.formatFileSize(fileSize);

          // Send immediately
          await sendBotMessage(patient: patient);
        } else {
          throw Exception('Audio file not found');
        }
      } else {
        throw Exception('Recording path is empty');
      }
    } catch (e) {
      debugPrint('❌ [NuraBot] Error sending voice note: $e');
      isRecordingVoice.value = false;
      Get.snackbar(
        'Send Error',
        'Failed to send voice note',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Cancel voice recording
  Future<void> cancelVoiceRecording() async {
    try {
      await _audioRecorderService.cancelRecording();
      isRecordingVoice.value = false;
      debugPrint('🗑️ [NuraBot] Voice recording cancelled');
    } catch (e) {
      debugPrint('❌ [NuraBot] Error cancelling voice recording: $e');
      isRecordingVoice.value = false;
    }
  }

  // ─── Sending Messages ─────────────────────────────────────────────

  /// Send bot message with optional attachment
  Future<void> sendBotMessage({required PatientModel patient}) async {
    // Dismiss keyboard
    final context = Get.context;
    if (context != null) FocusScope.of(context).unfocus();

    final query = messageController.text.trim();
    final fileToSend = selectedFile.value;

    // Must have text or attachment
    if (query.isEmpty && fileToSend == null) return;

    // Check connectivity
    final isConnected = await AppNetworkManager.instance.isConnected();
    if (!isConnected) {
      Get.snackbar(
        'No Connection',
        'Please check your internet connection and try again',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isReplying.value = true;
    BotMessageModel? placeholderMessage;

    try {
      // Build user message
      final userMessage = BotMessageModel(
        userId: patient.id!,
        message: query.isNotEmpty ? query : null,
        sender: SenderType.user,
        threadId: patient.id,
        attachmentPath: fileToSend?.path,
        attachmentName: selectedFileName.value.isNotEmpty
            ? selectedFileName.value
            : null,
        attachmentType: selectedFileMimeType.value.isNotEmpty
            ? selectedFileMimeType.value
            : null,
        attachmentSize: selectedFileSize.value.isNotEmpty
            ? selectedFileSize.value
            : null,
      );

      conversations.insert(0, userMessage);
      messageController.clear();
      clearAttachment();

      // Add loading placeholder
      placeholderMessage = BotMessageModel(
        sender: SenderType.bot,
        isLoading: true,
      );
      conversations.insert(0, placeholderMessage);

      // Send to API
      final reply = await _nuraBotService.sendChatMessage(
        threadId: patient.id!,
        query: query.isNotEmpty ? query : 'Analyze this attachment',
        file: fileToSend,
      );

      // Replace placeholder with response
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

      // Add error message as bot reply
      conversations.insert(
        0,
        BotMessageModel(
          sender: SenderType.bot,
          message: 'Sorry, I couldn\'t process your request. Please try again.',
          isLoading: false,
        ),
      );

      debugPrint('❌ NuraBot send error: $e');
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
