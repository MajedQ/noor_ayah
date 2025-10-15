import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';

/// Helper class للحصول على الألوان بناءً على الثيم النشط
class ThemeColors {
  final AppThemeColor theme;

  ThemeColors(this.theme);

  /// اللون الأساسي
  Color get primary {
    switch (theme) {
      case AppThemeColor.classic:
        return const Color(0xFF2D5F3F); // أخضر
      case AppThemeColor.night:
        return const Color(0xFF1A237E); // أزرق داكن
      case AppThemeColor.rose:
        return const Color(0xFF880E4F); // وردي داكن
    }
  }

  /// اللون الثانوي
  Color get secondary {
    switch (theme) {
      case AppThemeColor.classic:
        return const Color(0xFFD4AF37); // ذهبي
      case AppThemeColor.night:
        return const Color(0xFF90A4AE); // فضي
      case AppThemeColor.rose:
        return const Color(0xFFBA68C8); // بنفسجي
    }
  }

  /// اللون الفاتح
  Color get light {
    switch (theme) {
      case AppThemeColor.classic:
        return const Color(0xFFF0E68C); // ذهبي فاتح
      case AppThemeColor.night:
        return const Color(0xFF64B5F6); // أزرق فاتح
      case AppThemeColor.rose:
        return const Color(0xFFF8BBD0); // وردي فاتح
    }
  }

  /// الدرجة المتوسطة
  Color get medium {
    switch (theme) {
      case AppThemeColor.classic:
        return const Color(0xFF3A7D5C); // أخضر متوسط
      case AppThemeColor.night:
        return const Color(0xFF303F9F); // أزرق متوسط
      case AppThemeColor.rose:
        return const Color(0xFFC2185B); // وردي متوسط
    }
  }

  /// الخلفية الفاتحة جداً
  Color get veryLight {
    switch (theme) {
      case AppThemeColor.classic:
        return const Color(0xFFE8F5E9); // أخضر فاتح جداً
      case AppThemeColor.night:
        return const Color(0xFFE3F2FD); // أزرق فاتح جداً
      case AppThemeColor.rose:
        return const Color(0xFFFCE4EC); // وردي فاتح جداً
    }
  }

  /// التدرج الأساسي
  LinearGradient get primaryGradient {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        primary,
        medium,
        light,
      ],
    );
  }

  /// الحصول على ThemeColors من BuildContext
  static ThemeColors of(BuildContext context, ThemeProvider themeProvider) {
    return ThemeColors(themeProvider.colorTheme);
  }
}
