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
      case AppThemeColor.sage:
        return const Color(0xFF4A7C59); // أخضر مريح (Sage)
      case AppThemeColor.golden:
        return const Color(0xFFB8860B); // ذهبي داكن (Goldenrod)
      case AppThemeColor.beige:
        return const Color(0xFF8C7B5B); // بيج/سيبيا دافئ
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
      case AppThemeColor.sage:
        return const Color(0xFFC2A878); // ذهبي هادئ
      case AppThemeColor.golden:
        return const Color(0xFF6D4C1E); // بني دافئ
      case AppThemeColor.beige:
        return const Color(0xFFB89B72); // كاراميل/جمل
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
      case AppThemeColor.sage:
        return const Color(0xFFA8D5BA); // أخضر فاتح هادئ
      case AppThemeColor.golden:
        return const Color(0xFFF0D98C); // ذهبي فاتح
      case AppThemeColor.beige:
        return const Color(0xFFD8C9A8); // رملي فاتح
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
      case AppThemeColor.sage:
        return const Color(0xFF5E9B6E); // أخضر متوسط هادئ
      case AppThemeColor.golden:
        return const Color(0xFFC9A227); // ذهبي متوسط
      case AppThemeColor.beige:
        return const Color(0xFFA38E68); // بيج متوسط
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
      case AppThemeColor.sage:
        return const Color(0xFFEAF4ED); // أخضر فاتح جداً هادئ
      case AppThemeColor.golden:
        return const Color(0xFFFBF3D9); // ذهبي فاتح جداً
      case AppThemeColor.beige:
        return const Color(0xFFF5EFE2); // رملي فاتح جداً مريح للعين
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
