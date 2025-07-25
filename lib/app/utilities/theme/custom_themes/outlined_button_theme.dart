

import 'package:flutter/material.dart%20';

import '../../constants/colors.dart';

class CustomOutlinedButton{
  CustomOutlinedButton._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Color(0xFF575757).withOpacity(0.2)),
      ),
    )
  );

}