import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class FilePickerService {
  static final _instance = FilePickerService._();

  FilePickerService._();

  factory FilePickerService() {
    return _instance;
  }

  /// Get file extension from mime type
  String getFileExtension(String mimeType) {
    final parts = mimeType.split('/');
    if (parts.length > 1) {
      return parts[1].split(';').first.replaceAll('-', '.');
    }
    return 'unknown';
  }

  /// Format file size to human readable format
  String formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    final i = (bytes.toString().length / 3).floor();
    final newSize = bytes / (1000 * (1 << (i * 10)));
    return "${newSize.toStringAsFixed(2)} ${suffixes[i]}";
  }

  /// Pick file from device storage
  Future<FilePickerResult?> pickFile({
    List<String>? allowedExtensions,
    FileType type = FileType.any,
    bool allowMultiple = false,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
        allowMultiple: allowMultiple,
        withData: false,
      );
      return result;
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick file: $e');
      return null;
    }
  }

  /// Upload file to Firebase Storage with progress tracking
  Future<String?> uploadFileToFirebase({
    required File file,
    required String destination, // e.g., "chat_attachments/user_id/filename"
    required Function(double) onProgress,
  }) async {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      final uploadTask = ref.putFile(file);

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });

      // Wait for upload to complete
      final taskSnapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      Get.snackbar('Upload Error', 'Failed to upload file: $e');
      return null;
    }
  }

  /// Delete file from Firebase Storage
  Future<bool> deleteFileFromFirebase(String fileUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(fileUrl);
      await ref.delete();
      return true;
    } catch (e) {
      Get.snackbar('Delete Error', 'Failed to delete file: $e');
      return false;
    }
  }

  /// Get file MIME type
  String getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    const mimeTypes = {
      // Images
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'webp': 'image/webp',
      'svg': 'image/svg+xml',
      // Documents
      'pdf': 'application/pdf',
      'doc': 'application/msword',
      'docx':
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'xls': 'application/vnd.ms-excel',
      'xlsx':
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'ppt': 'application/vnd.ms-powerpoint',
      'pptx':
          'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'txt': 'text/plain',
      'csv': 'text/csv',
      'json': 'application/json',
      // Audio
      'mp3': 'audio/mpeg',
      'wav': 'audio/wav',
      'aac': 'audio/aac',
      'm4a': 'audio/mp4',
      // Video
      'mp4': 'video/mp4',
      'avi': 'video/x-msvideo',
      'mov': 'video/quicktime',
      'mkv': 'video/x-matroska',
      'webm': 'video/webm',
      // Archives
      'zip': 'application/zip',
      'rar': 'application/x-rar-compressed',
      '7z': 'application/x-7z-compressed',
    };

    return mimeTypes[extension] ?? 'application/octet-stream';
  }

  /// Get file icon based on type
  String getFileIcon(String mimeType) {
    if (mimeType.startsWith('image/')) return '🖼️';
    if (mimeType.startsWith('audio/')) return '🔊';
    if (mimeType.startsWith('video/')) return '🎬';
    if (mimeType == 'application/pdf') return '📄';
    if (mimeType.contains('word') || mimeType.contains('document')) return '📑';
    if (mimeType.contains('sheet') || mimeType.contains('excel')) return '📊';
    if (mimeType.contains('presentation')) return '📈';
    if (mimeType.contains('zip') || mimeType.contains('compressed')) {
      return '📦';
    }
    return '📎';
  }

  /// Check if file is an image
  bool isImageFile(String mimeType) => mimeType.startsWith('image/');

  /// Check if file is a document
  bool isDocumentFile(String mimeType) =>
      mimeType.startsWith('application/') &&
      mimeType != 'application/octet-stream';
}
