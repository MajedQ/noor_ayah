import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'theme_colors.dart';
import '../providers/theme_provider.dart';

/// السمات الرئيسية للتطبيق
class AppTheme {
  /// السمة الفاتحة مع ثيم ألوان مخصص
  static ThemeData getLightTheme(AppThemeColor colorTheme) {
    AppColors.activeTheme = colorTheme;
    final themeColors = ThemeColors(colorTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // الألوان الأساسية
      primaryColor: themeColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      cardColor: AppColors.cardLight,

      colorScheme: ColorScheme.light(
        primary: themeColors.primary,
        secondary: themeColors.secondary,
        surface: AppColors.cardLight,
        error: AppColors.error,
        onPrimary: AppColors.textLight,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textLight,
      ),

      // شريط التطبيق
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: themeColors.primary,
        foregroundColor: AppColors.textLight,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTextStyles.heading2(isDark: false).copyWith(
          color: AppColors.textLight,
        ),
      ),

      // البطاقات
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.cardLight,
        shadowColor: Colors.black.withOpacity(0.1),
      ),

      // الأزرار
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColors.primary,
          foregroundColor: AppColors.textLight,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.buttonText(),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: themeColors.primary,
          textStyle: AppTextStyles.buttonText(),
        ),
      ),

      // أيقونات
      iconTheme: const IconThemeData(
        color: AppColors.iconLight,
        size: 24,
      ),

      // حقول الإدخال
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppColors.primaryGreen.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: AppTextStyles.bodyText(isDark: false).copyWith(
          color: AppColors.textSecondary.withOpacity(0.6),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardLight,
        selectedItemColor: themeColors.primary,
        unselectedItemColor: AppColors.iconLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontFamily: AppTextStyles.cairoFont,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: AppTextStyles.cairoFont,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: themeColors.secondary,
        foregroundColor: AppColors.textPrimary,
        elevation: 4,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.iconLight,
        thickness: 1,
        space: 1,
      ),

      // الخطوط
      fontFamily: AppTextStyles.cairoFont,

      textTheme: TextTheme(
        displayLarge: AppTextStyles.heading1(isDark: false),
        displayMedium: AppTextStyles.heading2(isDark: false),
        displaySmall: AppTextStyles.heading3(isDark: false),
        bodyLarge: AppTextStyles.bodyText(isDark: false),
        bodyMedium: AppTextStyles.bodyText(isDark: false),
        labelLarge: AppTextStyles.buttonText(isDark: false),
        bodySmall: AppTextStyles.caption(isDark: false),
      ),
    );
  }

  /// السمة الداكنة مع ثيم ألوان مخصص
  static ThemeData getDarkTheme(AppThemeColor colorTheme) {
    AppColors.activeTheme = colorTheme;
    final themeColors = ThemeColors(colorTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // الألوان الأساسية
      primaryColor: themeColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardColor: AppColors.cardDark,

      colorScheme: ColorScheme.dark(
        primary: themeColors.primary,
        secondary: themeColors.secondary,
        surface: AppColors.cardDark,
        error: AppColors.error,
        onPrimary: AppColors.textLight,
        onSecondary: AppColors.textDarkMode,
        onSurface: AppColors.textDarkMode,
        onError: AppColors.textLight,
      ),

      // شريط التطبيق
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.cardDark,
        foregroundColor: AppColors.textDarkMode,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTextStyles.heading2(isDark: true).copyWith(
          color: AppColors.textDarkMode,
        ),
      ),

      // البطاقات
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.cardDark,
        shadowColor: Colors.black.withOpacity(0.3),
      ),

      // الأزرار
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColors.primary,
          foregroundColor: AppColors.textLight,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.buttonText(isDark: true),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: themeColors.secondary,
          textStyle: AppTextStyles.buttonText(isDark: true),
        ),
      ),

      // أيقونات
      iconTheme: const IconThemeData(
        color: AppColors.iconDark,
        size: 24,
      ),

      // حقول الإدخال
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGold),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryGold.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGold, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: AppTextStyles.bodyText(isDark: true).copyWith(
          color: AppColors.textDarkMode.withOpacity(0.6),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardDark,
        selectedItemColor: AppColors.primaryGold,
        unselectedItemColor: AppColors.iconDark,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontFamily: AppTextStyles.cairoFont,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppTextStyles.cairoFont,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryGold,
        foregroundColor: AppColors.textPrimary,
        elevation: 4,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.iconDark.withOpacity(0.3),
        thickness: 1,
        space: 1,
      ),

      // الخطوط
      fontFamily: AppTextStyles.cairoFont,

      textTheme: TextTheme(
        displayLarge: AppTextStyles.heading1(isDark: true),
        displayMedium: AppTextStyles.heading2(isDark: true),
        displaySmall: AppTextStyles.heading3(isDark: true),
        bodyLarge: AppTextStyles.bodyText(isDark: true),
        bodyMedium: AppTextStyles.bodyText(isDark: true),
        labelLarge: AppTextStyles.buttonText(isDark: true),
        bodySmall: AppTextStyles.caption(isDark: true),
      ),
    );
  }
}
