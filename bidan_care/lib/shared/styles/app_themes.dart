import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Lato",
    dividerColor: AppColors.dividerColor,
    disabledColor: AppColors.disabledColor,
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(AppColors.accentColor),
      ),
    ),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(AppColors.accentColor),
        textStyle: WidgetStatePropertyAll(AppTextStyles.bodyMedium),
      ),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.primaryColor,
      shadowColor: Colors.black54,
      elevation: 4,
      titleSpacing: 0,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: _buildInputBorder(),
      focusedBorder: _buildInputBorder(),
      errorBorder: _buildInputBorder(),
      focusedErrorBorder: _buildInputBorder(),
      errorStyle: AppTextStyles.bodyMedium,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      prefixIconColor: Colors.black26,
      alignLabelWithHint: true,
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.captionColor,
      ),
    ),
    textTheme: const TextTheme(
      bodySmall: AppTextStyles.bodySmall,
      bodyMedium: AppTextStyles.bodyMedium,
      bodyLarge: AppTextStyles.bodyLarge,
      titleMedium: AppTextStyles.titleMedium,
      titleLarge: AppTextStyles.titleLarge,
      headlineSmall: AppTextStyles.headlineSmall,
      headlineMedium: AppTextStyles.headlineMedium,
      headlineLarge: AppTextStyles.headlineLarge,
    ),
  );

  static OutlineInputBorder _buildInputBorder({bool isError = false}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: isError ? Colors.red : AppColors.primaryColor,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
