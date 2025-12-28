import 'package:flutter/material.dart';
import 'package:m_app/src/utils/app_colors.dart';

class AppTheme {
  /// Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      appBarTheme: const AppBarTheme(
        color: AppColors.secondaryColor, 
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle:
            TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
      )),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: AppColors.secondaryColor.withOpacity(0.5),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212), // Standard dark background
      appBarTheme: const AppBarTheme(
        color: Color(0xFF1F1F1F), // Darker app bar
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle:
            TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: const Color(0xFF1F1F1F), // Dark card color
        surfaceTintColor: const Color(0xFF1F1F1F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
      )),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: AppColors.secondaryColor.withOpacity(0.8),
        backgroundColor: const Color(0xFF1F1F1F),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
