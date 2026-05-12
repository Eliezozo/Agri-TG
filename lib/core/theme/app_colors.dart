import 'package:flutter/material.dart';

abstract class AppColors {
  // Primaires
  static const Color primary      = Color(0xFF1D9E75);
  static const Color primaryDark  = Color(0xFF0F6E56);
  static const Color primaryLight = Color(0xFF5DCAA5);

  // Fonds (thème sombre prioritaire)
  static const Color bgDark       = Color(0xFF0D1F18);
  static const Color bgCard       = Color(0xFF0D2A1F);
  static const Color bgAccent     = Color(0xFF0D3D2B);

  // Texte
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9FE1CB);
  static const Color textMuted     = Color(0xFF666666);

  // Sémantique
  static const Color success = Color(0xFF1D9E75);
  static const Color danger  = Color(0xFFF0997B);
  static const Color warning = Color(0xFFFAC775);
  static const Color info    = Color(0xFF5DCAA5);

  // Rôles
  static const Color roleMembre    = Color(0xFF5DCAA5);
  static const Color roleTresorier = Color(0xFFFAC775);
  static const Color rolePresident  = Color(0xFF1D9E75);
}
