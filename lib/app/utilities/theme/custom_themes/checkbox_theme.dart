import 'package:flutter/material.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';

class CustomCheckBox {
  CustomCheckBox._();

  static final lightCheckBoxTheme = CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.secondaryColor;
      }
    }),
    splashRadius: 10,

  );
}
