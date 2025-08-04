
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CustomTextSelectionTheme{
  CustomTextSelectionTheme._();

  static TextSelectionThemeData lightTheme = TextSelectionThemeData(
    cursorColor: AppColors.black,
    selectionColor: AppColors.secondaryColor.withOpacity(0.5),
    selectionHandleColor: AppColors.secondaryColor,
  );




}