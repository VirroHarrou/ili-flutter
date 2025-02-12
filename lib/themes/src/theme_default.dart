import 'package:flutter/material.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

ThemeData createLightTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Open Sans, sans-serif',
        color: AppColors.black,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Open Sans, sans-serif',
        color: AppColors.white,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Open Sans, sans-serif',
        color: AppColors.black,
        fontSize: 30,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Open Sans, sans-serif',
        color: AppColors.black,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Open Sans, sans-serif',
        color: AppColors.white,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Open Sans, sans-serif',
        color: AppColors.black,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Open Sans, sans-serif',
        color: AppColors.grey,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Open Sans, sans-serif',
        color: AppColors.black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Open Sans, sans-serif',
        color: AppColors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Open Sans, sans-serif',
        color: AppColors.red,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Open Sans, sans-serif',
        color: AppColors.grey,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    buttonTheme:
      const ButtonThemeData(
        padding: EdgeInsets.all(10),
        buttonColor: AppColors.black
      ),

  );
}
