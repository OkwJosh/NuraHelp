import 'package:flutter/material.dart%20';
import 'package:nurahelp/app/utilities/theme/custom_themes/checkbox_theme.dart';
import 'package:nurahelp/app/utilities/theme/custom_themes/dropdown_theme.dart';
import 'package:nurahelp/app/utilities/theme/custom_themes/elevated_button_theme.dart';
import 'package:nurahelp/app/utilities/theme/custom_themes/outlined_button_theme.dart';
import 'package:nurahelp/app/utilities/theme/custom_themes/text_theme.dart';
import 'package:nurahelp/app/utilities/theme/custom_themes/textfield_theme.dart';

import 'custom_themes/textbutton_theme.dart';
import 'custom_themes/textfield_selection_theme.dart';

class CustomAppTheme {

  CustomAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFf9f9f9),
    elevatedButtonTheme: CustomElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme: CustomTextFieldTheme.lightInputDecorationTheme,
    checkboxTheme: CustomCheckBox.lightCheckBoxTheme,
    dropdownMenuTheme: CustomDropdownMenuTheme.lightDropdownMenuTheme,
    textTheme: CustomTextTheme.lightTextTheme,
    outlinedButtonTheme: CustomOutlinedButton.lightOutlinedButtonTheme,
    textSelectionTheme: CustomTextSelectionTheme.lightTheme,
    textButtonTheme: CustomTextButtonTheme.lightTheme,

  );


}