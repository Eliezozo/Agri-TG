import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    surface: AppColors.bgCard,
  ),
  scaffoldBackgroundColor: AppColors.bgDark,
  cardColor: AppColors.bgCard,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.bgDark,
    elevation: 0,
    centerTitle: true,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.bgCard,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textMuted,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.textPrimary),
    bodyMedium: TextStyle(color: AppColors.textSecondary),
  ),
);
