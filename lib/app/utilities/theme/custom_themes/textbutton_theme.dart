import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CustomTextButtonTheme{
  CustomTextButtonTheme._();


  static TextButtonThemeData lightTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      overlayColor: Colors.black,
      textStyle: TextStyle(color: AppColors.black)
    )
  );



}