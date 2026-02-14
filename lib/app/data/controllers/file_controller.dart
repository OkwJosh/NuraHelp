import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/services/file_picker_service.dart';

// file_controller.dart

class FileController extends GetxController {
  static FileController get instance => Get.find();
  final _filePickerService = FilePickerService();

  // State observables
  final isProcessing = false.obs;
  final uploadProgress = 0.0.obs;
  final selectedFile = Rx<File?>(null);

  /// Handles picking, previewing, and sending a file in one flow
  Future<void> pickAndSendAttachment({
    required String receiverId,
    required String chatPath, // e.g., "chats/patientId_doctorId/"
  }) async {
    try {
      // 1. PHASE: PICKING
      isProcessing.value = true;
      final result = await _filePickerService.pickFile(type: FileType.any);

      if (result == null || result.files.isEmpty) return;

      final pickedFile = result.files.first;
      final file = File(pickedFile.path!);

      // 2. PHASE: PREVIEW (Update UI state so user sees what is being sent)
      selectedFile.value = file;
      final fileName = pickedFile.name;
      final mimeType = _filePickerService.getMimeType(pickedFile.path!);

      // 3. PHASE: SENDING (Upload to Storage & Send to API)
      final destination =
          "$chatPath${DateTime.now().millisecondsSinceEpoch}_$fileName";

      final downloadUrl = await _filePickerService.uploadFileToFirebase(
        file: file,
        destination: destination,
        onProgress: (progress) => uploadProgress.value = progress,
      );

      if (downloadUrl != null) {
        // Here you call your AppService to send the actual message
        // Example: await AppService.instance.sendMessage(receiverId, downloadUrl, type: 'file');

        Get.snackbar('Success', 'File sent successfully');
        clearAttachment(); // Reset UI state
      }
    } catch (e) {
      Get.snackbar('Error', 'File flow failed: $e');
    } finally {
      isProcessing.value = false;
      uploadProgress.value = 0.0;
    }
  }

  void clearAttachment() {
    selectedFile.value = null;
    uploadProgress.value = 0.0;
  }
}
