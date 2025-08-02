import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CustomDropdownMenuTheme{
  CustomDropdownMenuTheme._();
  static final lightDropdownMenuTheme = DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor: WidgetStateProperty.all(Colors.white),
      elevation: WidgetStateProperty.all(4), // Drop shadow depth
      padding: WidgetStateProperty.all(EdgeInsets.all(8)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.black, width: 0.3),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.neutral,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.black, width: 0.3),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.black,width: 0.3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.black, width: 0.3),
      ),
    ),
    textStyle: TextStyle(fontSize: 16, color: Colors.black,fontFamily: 'Poppins-Light'),
  );
}