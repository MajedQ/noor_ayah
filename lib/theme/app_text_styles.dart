import 'package:flutter/material.dart';
import 'app_colors.dart';

/// أنماط النصوص المخصصة للتطبيق
class AppTextStyles {
  // خط Amiri للآيات القرآنية
  static const String amiriFont = 'Amiri';

  // خط IBMPlexArabic للنصوص العادية
  static const String cairoFont = 'IBMPlexArabic';

  /// نص الآية القرآنية - كبير وواضح
  static TextStyle verseText({
    bool isDark = false,
    double sizeMultiplier = 1.0,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? amiriFont,
      fontSize: 28.0 * sizeMultiplier,
      fontWeight: FontWeight.w700,
      color: isDark ? AppColors.textDarkMode : AppColors.textPrimary,
      height: 2.0,
      letterSpacing: 0.5,
    );
  }

  /// نص التدبر
  static TextStyle reflectionText({
    bool isDark = false,
    double sizeMultiplier = 1.0,
  }) {
    return TextStyle(
      fontFamily: cairoFont,
      fontSize: 18.0 * sizeMultiplier,
      fontWeight: FontWeight.w400,
      color: isDark ? AppColors.textDarkMode : AppColors.textSecondary,
      height: 1.8,
      letterSpacing: 0.3,
    );
  }

  /// نص الدعاء
  static TextStyle duaText({
    bool isDark = false,
    double sizeMultiplier = 1.0,
  }) {
    return TextStyle(
      fontFamily: amiriFont,
      fontSize: 20.0 * sizeMultiplier,
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.primaryGold : AppColors.primaryGreen,
      height: 1.8,
      letterSpacing: 0.3,
    );
  }

  /// اسم السورة
  static TextStyle surahName({
    bool isDark = false,
    double sizeMultiplier = 1.0,
  }) {
    return TextStyle(
      fontFamily: amiriFont,
      fontSize: 16.0 * sizeMultiplier,
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.primaryGold : AppColors.primaryGreen,
      letterSpacing: 0.5,
    );
  }

  /// عنوان كبير
  static TextStyle heading1({
    bool isDark = false,
    double sizeMultiplier = 1.0,
  }) {
    return TextStyle(
      fontFamily: cairoFont,
      fontSize: 32.0 * sizeMultiplier,
      fontWeight: FontWeight.w700,
      color: isDark ? AppColors.textDarkMode : AppColors.textPrimary,
      letterSpacing: 0.5,
    );
  }

  /// عنوان متوسط
  static TextStyle heading2({
    bool isDark = false,
    double sizeMultiplier = 1.0,
  }) {
    return TextStyle(
      fontFamily: cairoFont,
      fontSize: 24.0 * sizeMultiplier,
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.textDarkMode : AppColors.textPrimary,
      letterSpacing: 0.3,
    );
  }

  /// عنوان صغير
  static TextStyle heading3({
    bool isDark = false,
    double sizeMultiplier = 1.0,
  }) {
    return TextStyle(
      fontFamily: cairoFont,
      fontSize: 20.0 * sizeMultiplier,
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.textDarkMode : AppColors.textPrimary,
      letterSpacing: 0.3,
    );
  }

  /// نص عادي
  static TextStyle bodyText({
    bool isDark = false,
    double sizeMultiplier = 1.0,
  }) {
    return TextStyle(
      fontFamily: cairoFont,
      fontSize: 16.0 * sizeMultiplier,
      fontWeight: FontWeight.w400,
      color: isDark ? AppColors.textDarkMode : AppColors.textSecondary,
      height: 1.5,
    );
  }

  /// نص صغير
  static TextStyle caption({
    bool isDark = false,
    double sizeMultiplier = 1.0,
  }) {
    return TextStyle(
      fontFamily: cairoFont,
      fontSize: 14.0 * sizeMultiplier,
      fontWeight: FontWeight.w400,
      color: isDark
          ? AppColors.textDarkMode.withOpacity(0.7)
          : AppColors.textSecondary,
    );
  }

  /// نص الأزرار
  static TextStyle buttonText({
    bool isDark = false,
    double sizeMultiplier = 1.0,
  }) {
    return TextStyle(
      fontFamily: cairoFont,
      fontSize: 16.0 * sizeMultiplier,
      fontWeight: FontWeight.w600,
      color: AppColors.textLight,
      letterSpacing: 0.5,
    );
  }

  /// نص التسميات (Labels)
  static TextStyle labelText({
    bool isDark = false,
    double sizeMultiplier = 1.0,
  }) {
    return TextStyle(
      fontFamily: cairoFont,
      fontSize: 14.0 * sizeMultiplier,
      fontWeight: FontWeight.w500,
      color: isDark ? AppColors.textDarkMode : AppColors.textPrimary,
      letterSpacing: 0.3,
    );
  }

  /// نص الفئات
  static TextStyle categoryText({
    bool isDark = false,
    double sizeMultiplier = 1.0,
  }) {
    return TextStyle(
      fontFamily: cairoFont,
      fontSize: 15.0 * sizeMultiplier,
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.textLight : AppColors.textPrimary,
      letterSpacing: 0.3,
    );
  }

  /// نص حالة فارغة
  static TextStyle emptyStateText({
    bool isDark = false,
    double sizeMultiplier = 1.0,
  }) {
    return TextStyle(
      fontFamily: cairoFont,
      fontSize: 18.0 * sizeMultiplier,
      fontWeight: FontWeight.w500,
      color: isDark
          ? AppColors.textDarkMode.withOpacity(0.7)
          : AppColors.textSecondary,
      height: 1.5,
    );
  }
}
