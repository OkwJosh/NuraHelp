import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CustomTextTheme{
  CustomTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
        fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.black),
    headlineMedium: const TextStyle().copyWith(
        fontSize: 24, fontFamily: 'Poppins-Medium', color: AppColors.black),
    headlineSmall: const TextStyle().copyWith(
        fontSize: 18, fontFamily: 'Poppins-Medium', color: AppColors.black),
    titleLarge: const TextStyle().copyWith(
        fontSize: 16, fontFamily: 'Poppins-Medium', color: AppColors.black),
    titleMedium: const TextStyle().copyWith(
        fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.black),
    titleSmall: const TextStyle().copyWith(
        fontSize: 16, fontFamily: 'Poppins-Medium', color: AppColors.black),
    bodyLarge: const TextStyle().copyWith(
        fontSize: 14, fontFamily: 'Poppins-Medium', color: AppColors.black),
    bodyMedium: const TextStyle().copyWith(
        fontSize: 14, fontFamily: 'Poppins-Medium', color: AppColors.black),
    bodySmall: const TextStyle().copyWith(
        fontSize: 14,
        fontFamily: 'Poppins-Medium',
        color: AppColors.black.withOpacity(0.5)),
    labelLarge: const TextStyle().copyWith(
        fontSize: 12.0, fontFamily: 'Poppins-Medium', color: AppColors.black),
    labelMedium: const TextStyle().copyWith(
        fontSize: 12.0,
        fontFamily: 'Poppins-Medium',
        color: AppColors.black.withOpacity(0.5)),
    labelSmall: const TextStyle().copyWith(
        fontSize: 10.0,
        fontFamily: 'Poppins-Medium',
        color: AppColors.black.withOpacity(0.5)),
  );
  
}