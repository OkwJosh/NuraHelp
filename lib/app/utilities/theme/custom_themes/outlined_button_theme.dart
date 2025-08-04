

import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CustomOutlinedButton{
  CustomOutlinedButton._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      overlayColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Color(0xFF575757).withOpacity(0.2)),
      ),
    )
  );

}