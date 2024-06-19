import 'package:flutter/material.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

class AppTextStyles {
  static const TextStyle titleH1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: 'Open Sans',
    color: AppColors.black,
  );

  static const TextStyle titleH1White = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: 'Open Sans',
    color: AppColors.white,
  );

  static const TextStyle titleH2 = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontFamily: 'Open Sans',
      color: AppColors.black,
  );

  static const TextStyle titleH2White = TextStyle(
      color: AppColors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontFamily: 'Open Sans',
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'Open Sans, sans-serif',
    color: AppColors.grey,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Open Sans, sans-serif',
    color: AppColors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyWhite = TextStyle(
    color: AppColors.white,
    fontFamily: 'Open Sans, sans-serif',
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
}