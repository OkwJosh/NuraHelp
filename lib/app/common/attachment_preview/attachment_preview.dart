import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nurahelp/app/data/services/file_picker_service.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';

class AttachmentPreview extends StatelessWidget {
  const AttachmentPreview({
    super.key,
    required this.file,
    required this.onRemove,
    this.mimeType,
    this.fileName,
    this.fileSize,
  });

  final File file;
  final VoidCallback onRemove;
  final String? mimeType;
  final String? fileName;
  final String? fileSize;

  String? _getThumbnailPath() {
    if (mimeType != null && FilePickerService().isImageFile(mimeType!)) {
      return file.path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final thumbnailPath = _getThumbnailPath();
    final displayFileName = fileName ?? file.path.split('/').last;
    final displaySize =
        fileSize ?? FilePickerService().formatFileSize(file.lengthSync());
    final icon = mimeType != null
        ? FilePickerService().getFileIcon(mimeType!)
        : '📎';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondaryColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(10),
        color: AppColors.bluishWhiteColor,
      ),
      child: Row(
        children: [
          // Thumbnail or Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.secondaryColor.withOpacity(0.1),
            ),
            child: thumbnailPath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(File(thumbnailPath), fit: BoxFit.cover),
                  )
                : Center(
                    child: Text(icon, style: const TextStyle(fontSize: 32)),
                  ),
          ),
          const SizedBox(width: 12),
          // File info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayFileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins-Medium',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displaySize,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins-Light',
                    color: AppColors.greyColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          // Remove button
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close),
            iconSize: 24,
            color: AppColors.secondaryColor,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
