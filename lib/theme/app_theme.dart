import 'package:flutter/material.dart';

class AppTheme {
  static const Color darkBackground = Color(0xFF1E2530);
  static const Color yellowAccent = Color(0xFFE8C468);
  static const Color whiteText = Color(0xFFFFFFFF);
  
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: yellowAccent,
      colorScheme: const ColorScheme.dark(
        primary: yellowAccent,
        secondary: yellowAccent,
        surface: darkBackground,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: whiteText,
          height: 1.2,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: whiteText,
        ),
      ),
    );
  }
}
