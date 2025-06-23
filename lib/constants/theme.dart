import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryOrange = Color.fromARGB(255, 248, 146, 57);
  static const Color primaryBlue = Color(0xFF0D47A1);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static var scaffoldBackground;
}

class AppGradients {
  static const blueGradient = LinearGradient(
    colors: [Color(0xFF295CA3), Color(0xFF6EA8E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.primaryOrange,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.primaryOrange,
      secondary: AppColors.primaryBlue,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: AppColors.black,
        fontFamily: 'PlusJakartaSans',
      ),
    ),
    fontFamily: 'PlusJakartaSans',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryOrange,
        foregroundColor: AppColors.white,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'PlusJakartaSans',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryOrange,
        backgroundColor: AppColors.white,
        side: const BorderSide(color: AppColors.primaryOrange),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryOrange),
      ),
      labelStyle: const TextStyle(
        color: AppColors.primaryOrange,
        fontFamily: 'PlusJakartaSans',
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    ),
  );
}
