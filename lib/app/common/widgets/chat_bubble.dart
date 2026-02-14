import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/common/widgets/message_status_tick.dart';
import 'package:nurahelp/app/data/models/message_models/message_model.dart';
import 'package:nurahelp/app/data/services/file_management_service.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const ChatBubble({super.key, required this.message, required this.isMe});

  /// Determines if this message is text-only (no attachments)
  bool get _isTextMessage =>
      !message.isImage &&
      !message.hasAttachment &&
      (message.attachmentType == null || message.attachmentType == 'text');

  @override
  Widget build(BuildContext context) {
    final bubble = _buildBubble(context);

    // For text messages, use IntrinsicWidth to hug the content
    if (_isTextMessage) {
      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: IntrinsicWidth(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            child: bubble,
          ),
        ),
      );
    }

    // For images/documents, use regular Align
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        child: bubble,
      ),
    );
  }

  Widget _buildBubble(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isMe ? AppColors.secondaryColor : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(15),
          topRight: const Radius.circular(15),
          bottomLeft: Radius.circular(isMe ? 15 : 0),
          bottomRight: Radius.circular(isMe ? 0 : 15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContent(context),
            Padding(
              padding: const EdgeInsets.only(right: 6, bottom: 4, top: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  Text(
                    '${message.timestamp.toLocal().hour}:${message.timestamp.toLocal().minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Poppins-Light',
                      color: isMe ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    MessageStatusTick(
                      delivered: message.delivered,
                      read: message.read,
                      isUploading:
                          message.isUploading, // Pass the uploading state
                      color: isMe ? Colors.white70 : Colors.grey[600],
                      size: 14,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    // 1. IMAGE BUBBLE
    if (message.isImage && message.hasAttachment) {
      final attachmentPath = message.attachments!.first;

      // Determine image type:
      // Local: starts with / (Unix) or C:/ (Windows) or file://
      // HTTP: starts with http:// or https://
      // Firebase: everything else (e.g., uploads/...)
      final isLocal =
          attachmentPath.startsWith('/') ||
          attachmentPath.startsWith(RegExp(r'^[a-zA-Z]:')) ||
          attachmentPath.startsWith('file://');
      final isHttp =
          attachmentPath.startsWith('http://') ||
          attachmentPath.startsWith('https://');
      final isFirebase = !isLocal && !isHttp;

      return Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isLocal
                ? _buildImageWidget(attachmentPath, imageType: 'local')
                : isHttp
                ? _buildImageWidget(attachmentPath, imageType: 'http')
                : _buildImageWidget(attachmentPath, imageType: 'firebase'),
          ),
          if (message.isUploading)
            Container(
              width: 200,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      );
    }

    // 2. DOCUMENT BUBBLE
    if (message.attachmentType != 'text' && message.attachmentType != null) {
      final parts = message.message.split('|');
      final fileName = parts.isNotEmpty ? parts[0] : "Document";
      final fileSize = parts.length > 1 ? parts[1] : "";
      final extension = fileName.split('.').last.toUpperCase();
      final fileUrl = message.attachments?.isNotEmpty == true
          ? message.attachments!.first
          : '';

      // For incoming messages (not sent by me), show download/open buttons
      if (!isMe && fileUrl.isNotEmpty) {
        return _buildDocumentBubbleWithActions(
          fileName: fileName,
          fileSize: fileSize,
          extension: extension,
          fileUrl: fileUrl,
          messageId: message.id,
        );
      }

      // For sent messages, show simple document bubble
      return _buildSimpleDocumentBubble(
        fileName: fileName,
        fileSize: fileSize,
        extension: extension,
      );
    }

    // 3. TEXT BUBBLE
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: Text(
        message.message,
        softWrap: true,
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Poppins-Regular',
          color: isMe ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Color _getFileColor(String ext) {
    switch (ext) {
      case 'PDF':
        return Colors.redAccent;
      case 'DOC':
      case 'DOCX':
        return Colors.blueAccent;
      case 'XLS':
      case 'XLSX':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  /// Build simple document bubble for sent messages
  Widget _buildSimpleDocumentBubble({
    required String fileName,
    required String fileSize,
    required String extension,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: _getFileColor(extension),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              extension.length > 4 ? "DOC" : extension,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins-Medium',
                    fontSize: 14,
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  fileSize,
                  style: TextStyle(
                    fontFamily: 'Poppins-Regular',
                    fontSize: 11,
                    color: isMe ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build document bubble with download/open buttons for received messages
  Widget _buildDocumentBubbleWithActions({
    required String fileName,
    required String fileSize,
    required String extension,
    required String fileUrl,
    required String messageId,
  }) {
    return Obx(() {
      final fileService = FileManagementService.instance;
      final isDownloading =
          fileService.downloadProgress[messageId] != null &&
          fileService.downloadProgress[messageId]! < 1.0;
      final isDownloaded = fileService.downloadedFiles.contains(messageId);
      final progress = fileService.downloadProgress[messageId] ?? 0.0;

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // File info
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: _getFileColor(extension),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    extension.length > 4 ? "DOC" : extension,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins-Medium',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        fileSize,
                        style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Download progress or action buttons
            if (isDownloading)
              SizedBox(
                height: 50,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blueAccent,
                              ),
                            ),
                            Text(
                              '${(progress * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 10,
                                fontFamily: 'Poppins-Medium',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Download button
                  if (!isDownloaded)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _downloadFile(
                          fileName: fileName,
                          fileUrl: fileUrl,
                          messageId: messageId,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/nura_icons/nura_download.svg',
                                width: 16,
                                height: 16,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Download',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins-Medium',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  if (!isDownloaded) const SizedBox(width: 8),

                  // Open button (shown when downloaded)
                  if (isDownloaded)
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            _openFile(fileName: fileName, messageId: messageId),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.open_in_new,
                                size: 16,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Open',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins-Medium',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      );
    });
  }

  /// Download file from URL
  Future<void> _downloadFile({
    required String fileName,
    required String fileUrl,
    required String messageId,
  }) async {
    try {
      final fileService = FileManagementService.instance;
      await fileService.downloadFile(
        fileUrl: fileUrl,
        fileName: fileName,
        messageId: messageId,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to download file: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Open downloaded file
  Future<void> _openFile({
    required String fileName,
    required String messageId,
  }) async {
    try {
      final fileService = FileManagementService.instance;
      final filePath = await fileService.getLocalFilePath(fileName);
      if (filePath != null) {
        await fileService.openFile(filePath);
      } else {
        Get.snackbar(
          'Error',
          'File not found in local storage',
          backgroundColor: Colors.orange,
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

  /// Build image widget that handles local files, Firebase paths, and HTTP URLs
  /// imageType can be: 'local', 'http', or 'firebase'
  Widget _buildImageWidget(String imagePath, {required String imageType}) {
    if (imageType == 'local') {
      // Local file from device storage
      return Image.file(File(imagePath), fit: BoxFit.cover);
    }

    if (imageType == 'http') {
      // It's already an HTTP URL, use it directly with proper caching
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.cover,
        cacheKey: imagePath,
        placeholder: (context, url) => Container(
          height: 150,
          width: 200,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 200),
      );
    }

    // imageType == 'firebase'
    // It's a Firebase Storage path (e.g., "uploads/...")
    // Resolve it to a download URL
    return FutureBuilder<String>(
      future: _resolveFirebaseImageUrl(imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 150,
            width: 200,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          debugPrint('❌ Failed to resolve image: ${snapshot.error}');
          return Container(
            height: 150,
            width: 200,
            color: Colors.grey[300],
            child: const Icon(Icons.error),
          );
        }

        // Use the resolved URL with proper caching
        final resolvedUrl = snapshot.data!;
        return CachedNetworkImage(
          imageUrl: resolvedUrl,
          fit: BoxFit.cover,
          cacheKey: imagePath,
          placeholder: (context, url) => Container(
            height: 150,
            width: 200,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(color: AppColors.secondaryColor),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fadeInDuration: const Duration(milliseconds: 200),
          fadeOutDuration: const Duration(milliseconds: 200),
        );
      },
    );
  }

  /// Resolve Firebase Storage path to download URL
  Future<String> _resolveFirebaseImageUrl(String firebasePath) async {
    try {
      debugPrint('🔄 Resolving Firebase image: $firebasePath');
      final downloadUrl = await FirebaseStorage.instance
          .ref(firebasePath)
          .getDownloadURL();
      debugPrint('✅ Resolved Firebase URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('❌ Error resolving Firebase URL: $e');
      rethrow;
    }
  }
}
