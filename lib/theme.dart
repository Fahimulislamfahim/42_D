import 'package:flutter/material.dart';

class AppTheme {
  static const Color neonCyan = Color(0xFF00FFFF);
  static const Color backgroundDeepBlack = Color(0xFF0D0D0D);
  static const Color surfaceGrey = Color(0xFF1A1A1A);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDeepBlack,
      primaryColor: neonCyan,
      colorScheme: const ColorScheme.dark(
        primary: neonCyan,
        surface: surfaceGrey,
        background: backgroundDeepBlack,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDeepBlack,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: neonCyan,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: neonCyan),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        titleLarge: TextStyle(color: neonCyan, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: neonCyan,
          side: const BorderSide(color: neonCyan, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceGrey,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: neonCyan, width: 1.5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      cardTheme: CardTheme(
        color: surfaceGrey,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: neonCyan, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4,
      ),
    );
  }

  static BoxDecoration get containerDecoration {
    return BoxDecoration(
      color: surfaceGrey,
      border: Border.all(color: neonCyan, width: 1.0),
      borderRadius: BorderRadius.circular(12.0),
    );
  }
}
