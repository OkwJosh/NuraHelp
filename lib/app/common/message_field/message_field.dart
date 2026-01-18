import 'package:flutter/material.dart';

import '../../utilities/constants/colors.dart';
import '../../utilities/constants/icons.dart';
import '../../utilities/constants/svg_icons.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.showBorder = true,
    this.hint = 'Send Message',
    this.sendIconColor = AppColors.secondaryColor,
    this.micIconColor = Colors.black,
    this.attachmentIconColor = Colors.black,
    required this.onSendButtonPressed,
    required this.onMicButtonPressed,
    required this.onAttachButtonPressed,
    this.controller,
    this.onChanged,
  });

  final bool showBorder;
  final String? hint;
  final Color? sendIconColor;
  final Color? micIconColor;
  final Color? attachmentIconColor;
  final Function() onSendButtonPressed;
  final Function() onMicButtonPressed;
  final Function() onAttachButtonPressed;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: showBorder
            ? Border.all(color: AppColors.secondaryColor, width: 0.5)
            : Border(),
        color: AppColors.bluishWhiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          TextField(
            controller: controller,
            onChanged: onChanged,
            minLines: 1,
            maxLines: 3,
            style: TextStyle(
              color: AppColors.black200,
              fontFamily: 'Poppins-Light',
              fontSize: 16,
            ),
            cursorColor: AppColors.black,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: 20,
                right: 10,
                top: 10,
                bottom: 10,
              ),
              hint: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hint!,
                      style: TextStyle(
                        fontFamily: 'Poppins-ExtraLight',
                        fontSize: 16,
                        color: AppColors.black300,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              fillColor: Colors.transparent,
              filled: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onAttachButtonPressed,
                icon: SvgIcon(AppIcons.attach, color: AppColors.black),
                color: attachmentIconColor,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onMicButtonPressed,
                    icon: SvgIcon(AppIcons.mic, color: micIconColor),
                  ),
                  IconButton(
                    onPressed: onSendButtonPressed,
                    icon: SvgIcon(AppIcons.send, color: sendIconColor),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
