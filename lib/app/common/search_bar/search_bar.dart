import 'package:flutter/material.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import 'package:nurahelp/app/utilities/device/device_utility.dart';

import '../../utilities/constants/colors.dart';
import '../../utilities/constants/icons.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key, required this.hintText, this.textEditingController,
  });
  final String hintText;
  final TextEditingController? textEditingController;


  @override
  Widget build(BuildContext context) {
    final bool isSmallPhone = AppDeviceUtils.getScreenWidth(context) <= 360.0;
    return TextFormField(
      controller: textEditingController,
      style: TextStyle(color: AppColors.greyColor),
      cursorColor: AppColors.greyColor,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left:10),
        hint: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              SvgIcon(AppIcons.search,size: 20,color: AppColors.text10),
              SizedBox(width: isSmallPhone?5:10),
              Text(hintText,style: TextStyle(fontFamily: 'Poppins-Regular',fontSize:12,fontWeight: FontWeight.w600,color: AppColors.text10),)
            ],
          ),
        ),
        hintStyle: TextStyle(color: AppColors.black200,fontFamily: 'Poppins-Regular'),
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
