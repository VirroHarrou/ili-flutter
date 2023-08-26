import 'package:flutter/material.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

ThemeData createLightTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.white,
    ),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
    useMaterial3: true,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'montserrat, urban, sans-serif',
        color: AppColors.black,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontFamily: 'montserrat, urban, sans-serif',
        color: AppColors.white,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'montserrat, urban, sans-serif',
        color: AppColors.white,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontFamily: 'montserrat, urban, sans-serif',
        color: AppColors.black,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      )
    ),
    buttonTheme:
      ButtonThemeData(
        padding: EdgeInsets.all(10),
        buttonColor: AppColors.black
      )
);
}
