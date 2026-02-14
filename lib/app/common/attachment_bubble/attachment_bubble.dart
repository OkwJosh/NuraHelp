import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nurahelp/app/data/models/message_models/bot_message_model.dart';
import 'package:nurahelp/app/data/services/file_picker_service.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AttachmentBubble extends StatelessWidget {
  const AttachmentBubble({
    super.key,
    required this.message,
    required this.isUserMessage,
  });

  final BotMessageModel message;
  final bool isUserMessage;

  @override
  Widget build(BuildContext context) {
    if (!message.hasAttachment) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      decoration: BoxDecoration(
        color: isUserMessage
            ? AppColors.secondaryColor
            : AppColors.bluishWhiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attachment preview/thumbnail
          if (message.isImage)
            _buildImagePreview()
          else
            _buildDocumentPreview(),

          // Upload progress indicator
          if (message.isUploading)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildUploadProgress(context),
            ),
        ],
      ),
    );
  }

  /// Build image preview — handles both local files and network URLs
  Widget _buildImagePreview() {
    final path = message.attachmentPath!;
    final isLocal = !path.startsWith('http');

    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: isLocal
              ? Image.file(
                  File(path),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: path,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  ),
                  placeholder: (context, url) => Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
        ),

        // Upload progress overlay
        if (message.isUploading)
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: message.uploadProgress,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Build document preview with file icon and details
  Widget _buildDocumentPreview() {
    final fileIcon = message.attachmentType != null
        ? FilePickerService().getFileIcon(message.attachmentType!)
        : '📎';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // File icon
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isUserMessage
                ? Colors.white.withOpacity(0.2)
                : AppColors.secondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(fileIcon, style: const TextStyle(fontSize: 32)),
          ),
        ),
        const SizedBox(width: 12),

        // File info with progress
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // File name
              Text(
                message.attachmentName ?? 'Document',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins-Medium',
                  color: isUserMessage ? Colors.white : AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),

              // File size and status
              if (message.attachmentSize != null)
                Text(
                  message.attachmentSize!,
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'Poppins-Light',
                    color: isUserMessage
                        ? Colors.white.withOpacity(0.8)
                        : AppColors.greyColor.withOpacity(0.7),
                  ),
                ),

              // Upload progress with percentage
              if (message.isUploading)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Stack(
                      children: [
                        // Background
                        Container(
                          height: 4,
                          color: isUserMessage
                              ? Colors.white.withOpacity(0.3)
                              : AppColors.secondaryColor.withOpacity(0.2),
                        ),
                        // Progress fill
                        Container(
                          height: 4,
                          width: 60 * message.uploadProgress,
                          color: isUserMessage
                              ? Colors.white
                              : AppColors.secondaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build upload progress indicator (circular)
  Widget _buildUploadProgress(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Progress label
        Text(
          '${(message.uploadProgress * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Poppins-Light',
            color: isUserMessage
                ? Colors.white.withOpacity(0.8)
                : AppColors.greyColor.withOpacity(0.7),
          ),
        ),

        // Circular progress
        SizedBox(
          width: 30,
          height: 30,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: message.uploadProgress,
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isUserMessage ? Colors.white : AppColors.secondaryColor,
                ),
                backgroundColor: isUserMessage
                    ? Colors.white.withOpacity(0.3)
                    : AppColors.secondaryColor.withOpacity(0.2),
              ),
              Text(
                '${(message.uploadProgress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 8,
                  fontFamily: 'Poppins-Light',
                  color: isUserMessage
                      ? Colors.white
                      : AppColors.secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
