import 'package:flutter/material.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import 'package:nurahelp/app/utilities/device/device_utility.dart';

import '../../utilities/constants/colors.dart';
import '../../utilities/constants/icons.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key, required this.hintText,
  });
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final bool isSmallPhone = AppDeviceUtils.getScreenWidth(context) <= 360.0;
    return TextField(
      style: TextStyle(color: AppColors.greyColor),
      cursorColor: AppColors.greyColor,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left:10),
        hint: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              SizedBox(width: isSmallPhone?5:10),
              Text(hintText,style: TextStyle(fontFamily: "Poppins-Light",fontWeight: FontWeight.w600,color: AppColors.black),)
            ],
          ),
        ),
        hintStyle: TextStyle(color: AppColors.greyColor.withOpacity(0.6),fontFamily: "Poppins-Light"),
        fillColor: AppColors.neutral300,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: AppColors.black,width: 0.3)
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: AppColors.black,width: 0.3)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: AppColors.black,width: 0.3)
        ),
      ),
    );
  }
}
