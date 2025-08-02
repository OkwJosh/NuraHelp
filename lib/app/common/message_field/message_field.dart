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
  });

  final bool showBorder;
  final String? hint;
  final Color? sendIconColor;
  final Color? micIconColor;
  final Color? attachmentIconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: showBorder?Border.all(color: AppColors.secondaryColor,width: 0.5):Border(),
        color: AppColors.bluishWhiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          TextField(
            minLines: 1,
            maxLines: 3,
            style: TextStyle(
              color: AppColors.black,
              fontFamily: 'Poppins-ExtraLight',
              fontSize: 14,
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
                        fontFamily: "Poppins-ExtraLight",
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
              IconButton(onPressed: () {}, icon: SvgIcon(AppIcons.attach,color: AppColors.black),color: attachmentIconColor,),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: SvgIcon(AppIcons.mic,color: micIconColor,),
                  ),
                  IconButton(
                    onPressed: () {},
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
