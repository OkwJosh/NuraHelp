import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class FileManagementService extends GetxService {
  static FileManagementService get instance => Get.find();

  final RxMap<String, double> downloadProgress = <String, double>{}.obs;
  final RxSet<String> downloadedFiles = <String>{}.obs;

  /// Download file from URL and save to local storage
  Future<String?> downloadFile({
    required String fileUrl,
    required String fileName,
    required String messageId,
  }) async {
    try {
      downloadProgress[messageId] = 0.0;

      // 1. RESOLVE URL: Check if it's a raw path (e.g., "uploads/...")
      String resolvedUrl = fileUrl;
      if (!fileUrl.startsWith('http')) {
        debugPrint('🔄 Resolving Firebase Storage path: $fileUrl');
        try {
          resolvedUrl = await FirebaseStorage.instance
              .ref(fileUrl)
              .getDownloadURL();
        } catch (e) {
          debugPrint('❌ Could not find file in storage: $e');
          downloadProgress.remove(messageId);
          return null;
        }
      }

      // 2. DOWNLOAD: Now use the http/https URL
      final response = await http.get(Uri.parse(resolvedUrl));

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();

        // Sanitize filename to prevent path traversal issues
        final cleanName = fileName.replaceAll(RegExp(r'[^\w\s\.]'), '_');
        final filePath = '${directory.path}/$cleanName';

        final file = File(filePath);

        await file.writeAsBytes(response.bodyBytes);

        // Update state
        downloadProgress[messageId] = 1.0;
        downloadedFiles.add(messageId);

        debugPrint('✅ File downloaded to: $filePath');
        return filePath;
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Download error: $e');
      downloadProgress.remove(messageId);
      return null;
    }
  }

  /// Open file with available app
  Future<void> openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        Get.snackbar(
          'Error',
          'No app found to open this file',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to open file: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Check if file is already downloaded locally
  Future<String?> getLocalFilePath(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        debugPrint('✅ File found locally: $filePath');
        return filePath;
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error checking local file: $e');
      return null;
    }
  }

  /// Delete downloaded file
  Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('✅ File deleted: $filePath');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error deleting file: $e');
      return false;
    }
  }

  /// Get file size in human-readable format
  String getFileSizeString(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    final i = (bytes.toString().length / 3).floor();
    final newSize = bytes / (1000 * (1 << (i * 10)));
    return "${newSize.toStringAsFixed(2)} ${suffixes[i]}";
  }
}
