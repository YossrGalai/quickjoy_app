import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF1A1A3E);
  static const Color surface    = Color(0xFF252550);
  static const Color cardColor  = Color(0xFF2A2A5A);

  static const Color accentPurple = Color(0xFF9B7FE8);
  static const Color accentCyan   = Color(0xFF00E5FF);
  static const Color accentYellow = Color(0xFFFFD93D);
  static const Color accentGreen  = Color(0xFF4DD97A);

  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8B8D4);

  // Couleurs par catégorie — inchangées
  static const Color quizColor   = Color(0xFF00E5FF);
  static const Color puzzleColor = Color(0xFFFFD93D);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: accentPurple,
        secondary: accentCyan,
        onSurface: textPrimary,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: textSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}