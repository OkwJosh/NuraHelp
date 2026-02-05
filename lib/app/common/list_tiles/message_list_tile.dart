import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurahelp/app/common/widgets/message_status_tick.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import 'package:intl/intl.dart';

import '../../utilities/constants/colors.dart';
import '../../utilities/constants/icons.dart';

class MessageListTile extends StatelessWidget {
  const MessageListTile({
    super.key,
    required this.onPressed,
    required this.contactName,
    required this.lastMessage,
    required this.unreadMessagesNumber,
    this.profilePicture,
    this.timestamp,
    this.backgroundColor = Colors.white,
    this.lastSender,
    this.currentUserId,
    this.delivered = true,
    this.read = false,
  });

  final Function() onPressed;
  final String contactName;
  final String lastMessage;
  final int unreadMessagesNumber;
  final String? profilePicture;
  final DateTime? timestamp;
  final Color backgroundColor;
  final String? lastSender;
  final String? currentUserId;
  final bool delivered;
  final bool read;

  String _formatTimestamp(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat('h:mm a').format(dateTime.toLocal());
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(dateTime.toLocal());
    } else {
      return DateFormat('MMM d').format(dateTime.toLocal());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: ListTile(
        onTap: onPressed,
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: profilePicture != null && profilePicture!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: profilePicture!,
                  imageBuilder: (context, imageProvider) =>
                      CircleAvatar(radius: 20, backgroundImage: imageProvider),
                  placeholder: (context, url) => SvgIcon(AppIcons.profile),
                  errorWidget: (context, url, error) =>
                      SvgIcon(AppIcons.profile),
                )
              : SvgIcon(AppIcons.profile),
        ),
        title: Text(
          contactName,
          style: TextStyle(fontFamily: 'Poppins-Medium', fontSize: 14),
        ),
        subtitle: Row(
          children: [
            if (lastSender != null &&
                currentUserId != null &&
                lastSender == currentUserId) ...[
              MessageStatusTick(delivered: delivered, read: read, size: 14),
              const SizedBox(width: 4),
            ],
            Expanded(
              child: Text(
                lastMessage,
                style: TextStyle(
                  fontFamily: 'Poppins-Light',
                  color: AppColors.greyColor,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: Transform.translate(
          offset: Offset(0, 5),
          child: Column(
            children: [
              Text(
                _formatTimestamp(timestamp),
                style: TextStyle(
                  fontFamily: 'Poppins-Light',
                  color: AppColors.greyColor,
                  fontSize: 12,
                ),
              ),
              if (unreadMessagesNumber > 0) ...[
                SizedBox(height: 8),
                CircleAvatar(
                  backgroundColor: AppColors.deepSecondaryColor,
                  radius: 11,
                  child: Text(
                    '$unreadMessagesNumber',
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
