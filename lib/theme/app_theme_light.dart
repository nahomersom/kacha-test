import 'package:flutter/material.dart';

import 'colors.dart';
import 'typography.dart';

ThemeData buildLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.light),
    scaffoldBackgroundColor: AppColors.background,

    textTheme: AppTypography.lightTextTheme,
    fontFamily: AppTypography.fontFamily,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.background, foregroundColor: AppColors.black, elevation: 0),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.white),
    ),
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
  );
}


