import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';

import '../../utilities/constants/colors.dart';
import '../../utilities/constants/icons.dart';

class MessageListTile extends StatelessWidget {
  const MessageListTile({
    super.key,
    required this.onPressed,
    required this.contactName,
    required this.lastMessage,
    required this.unreadMessagesNumber,
    this.backgroundColor = Colors.white,
  });

  final Function() onPressed;
  final String contactName;
  final String lastMessage;
  final int unreadMessagesNumber;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: ListTile(
        onTap: onPressed,
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(radius: 20,backgroundColor: Colors.white,child: SvgIcon(AppIcons.profile),),
        title: Text(
          contactName,
          style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 14),
        ),
        subtitle: Text(
          lastMessage,
          style: TextStyle(
            fontFamily: "Poppins-ExtraLight",
            color: AppColors.greyColor,
            fontSize: 12,
          ),
        ),
        trailing: Transform.translate(
          offset: Offset(0, 5),
          child: Column(
            children: [
              Text(
                "12:30 PM",
                style: TextStyle(
                  fontFamily: "Poppins-Light",
                  color: AppColors.greyColor,
                ),
              ),
              SizedBox(height: 8),
              CircleAvatar(
                backgroundColor: AppColors.deepSecondaryColor,
                radius: 11,
                child: Text(
                  "$unreadMessagesNumber",
                  style: TextStyle(
                    fontFamily: "Poppins-Regular",
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
