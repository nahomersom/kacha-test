import 'package:flutter/material.dart';

import 'colors.dart';

class AppTypography {
  static const String fontFamily = 'Imprima';

  static TextTheme lightTextTheme = const TextTheme(
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.white),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.white),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.black),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.white),
  );

  static TextTheme darkTextTheme = const TextTheme(
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.white),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.white),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.white),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.white),
  );
}


