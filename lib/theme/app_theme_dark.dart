import 'package:flutter/material.dart';

import 'colors.dart';
import 'typography.dart';

ThemeData buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryDark, brightness: Brightness.dark),
    scaffoldBackgroundColor: Colors.black,
    textTheme: AppTypography.darkTextTheme,
    fontFamily: AppTypography.fontFamily,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.black, foregroundColor: AppColors.white, elevation: 0),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark, foregroundColor: AppColors.white),
    ),
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
  );
}


