import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

/// AppTheme builds Material 3 light and dark theme data for Spendly.
abstract class AppTheme {
  /// Light theme configuration (Vanilla Mist & Nordic Indigo)
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.glacier,
      tertiary: AppColors.glacierMint,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppStyles.borderRadiusLg,
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppStyles.md,
          vertical: AppStyles.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppStyles.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppStyles.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppStyles.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppStyles.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppStyles.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.lightTextSecondary),
        hintStyle: const TextStyle(color: AppColors.lightTextSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.borderRadiusMd,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 54),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.borderRadiusMd,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: AppStyles.borderRadiusLg,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
      ),
    );
  }

  /// Dark theme configuration (Midnight Obsidian & Glacier Mint)
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      onPrimary: Colors.white,
      secondary: AppColors.glacier,
      tertiary: AppColors.glacierMint,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppStyles.borderRadiusLg,
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppStyles.md,
          vertical: AppStyles.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppStyles.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppStyles.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppStyles.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.glacier, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppStyles.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppStyles.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.darkTextSecondary),
        hintStyle: const TextStyle(color: AppColors.darkTextSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.borderRadiusMd,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.glacierLight,
          minimumSize: const Size(double.infinity, 54),
          side: const BorderSide(color: AppColors.glacier, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.borderRadiusMd,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.glacier,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: AppStyles.borderRadiusLg,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.glacier,
        unselectedItemColor: AppColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
      ),
    );
  }
}
