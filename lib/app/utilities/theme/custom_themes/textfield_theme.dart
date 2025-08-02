
import 'package:flutter/material.dart%20';

import '../../constants/colors.dart';

class CustomTextFieldTheme{
  CustomTextFieldTheme._();


  static final lightInputDecorationTheme = InputDecorationTheme(
    filled: true,

    fillColor: AppColors.primaryColor.withOpacity(0.7),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: AppColors.black300,
        width: 0.3,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: AppColors.black300,
        width: 0.3,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: AppColors.black300,
        width: 0.3,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.red,
        width: 0.3,
      ),
    ),
    contentPadding: EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 15),
    hintStyle: TextStyle(fontSize: 14,fontFamily: 'Poppins-ExtraLight',color: AppColors.black,letterSpacing: 0),
    suffixIconColor: AppColors.black,


  );

}