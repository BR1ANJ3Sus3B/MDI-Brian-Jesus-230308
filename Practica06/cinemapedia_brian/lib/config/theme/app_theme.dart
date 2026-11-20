import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF080B16);
  static const surface = Color(0xFF12182A);
  static const card = Color(0xFF1B2338);
  static const cyan = Color(0xFF00D9FF);
  static const purple = Color(0xFF8957FF);
  static const amber = Color(0xFFFFB800);
  static const secondaryText = Color(0xFFA6AEC2);
}

class AppTheme {
  ThemeData getTheme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.cyan,
      brightness: Brightness.dark,
      surface: AppColors.surface,
    ).copyWith(
      primary: AppColors.cyan,
      secondary: AppColors.purple,
      tertiary: AppColors.amber,
      surface: AppColors.surface,
      onSurface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      dividerColor: Colors.white.withValues(alpha: 0.08),
      textTheme: ThemeData.dark().textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
            fontFamily: 'Roboto',
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.cyan.withValues(alpha: 0.14),
        labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
              color: states.contains(WidgetState.selected)
                  ? AppColors.cyan
                  : AppColors.secondaryText,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            )),
      ),
      iconTheme: const IconThemeData(color: AppColors.secondaryText),
      cardColor: AppColors.card,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.cyan, width: 1.2),
        ),
      ),
    );
  }
}
