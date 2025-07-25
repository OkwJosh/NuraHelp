import 'package:flutter/material.dart';

class CustomTextTheme{
  CustomTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
        fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
    headlineMedium: const TextStyle().copyWith(
        fontSize: 24, fontFamily: "Poppins-Medium", color: Colors.black),
    headlineSmall: const TextStyle().copyWith(
        fontSize: 18, fontFamily: "Poppins-Medium", color: Colors.black),
    titleLarge: const TextStyle().copyWith(
        fontSize: 16, fontFamily: "Poppins-Medium", color: Colors.black),
    titleMedium: const TextStyle().copyWith(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
    titleSmall: const TextStyle().copyWith(
        fontSize: 16, fontFamily: "Poppins-Medium", color: Colors.black),
    bodyLarge: const TextStyle().copyWith(
        fontSize: 14, fontFamily: "Poppins-Medium", color: Colors.black),
    bodyMedium: const TextStyle().copyWith(
        fontSize: 14, fontFamily: "Poppins-Medium", color: Colors.black),
    bodySmall: const TextStyle().copyWith(
        fontSize: 14,
        fontFamily: "Poppins-Medium",
        color: Colors.black.withOpacity(0.5)),
    labelLarge: const TextStyle().copyWith(
        fontSize: 12.0, fontFamily: "Poppins-Medium", color: Colors.black),
    labelMedium: const TextStyle().copyWith(
        fontSize: 12.0,
        fontFamily: "Poppins-Medium",
        color: Colors.black.withOpacity(0.5)),
    labelSmall: const TextStyle().copyWith(
        fontSize: 10.0,
        fontFamily: "Poppins-Medium",
        color: Colors.black.withOpacity(0.5)),
  );
  
}