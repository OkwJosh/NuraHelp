

import 'package:flutter/material.dart%20';

import '../../constants/colors.dart';

class CustomElevatedButtonTheme{
  CustomElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: AppColors.secondaryColor,
      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
      textStyle: TextStyle(color: Colors.white,fontSize: 14,fontFamily: 'Poppins-Regular',)
    )
  );


}