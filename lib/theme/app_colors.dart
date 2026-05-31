import 'package:flutter/material.dart';

/// تعريف جميع الألوان المستخدمة في التطبيق
class AppColors {
  // الألوان الأساسية
  static const Color primaryGreen = Color(0xFF2D5F3F);
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color primaryBeige = Color(0xFFF5F5DC);

  // درجات الأخضر
  static const Color darkGreen = Color(0xFF1B3D2B);
  static const Color mediumGreen = Color(0xFF3A7D5C);
  static const Color lightGreen = Color(0xFF6FAF8D);
  static const Color veryLightGreen = Color(0xFFE8F5E9);

  // درجات الذهبي
  static const Color darkGold = Color(0xFFB8922E);
  static const Color lightGold = Color(0xFFF0E68C);

  // درجات البيج
  static const Color darkBeige = Color(0xFFD4C5A9);
  static const Color lightBeige = Color(0xFFFFFAF0);

  // ألوان النصوص
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textDarkMode = Color(0xFFE0E0E0);

  // ألوان الخلفيات
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);

  // ألوان الفئات
  static const Map<String, Color> categoryColors = {
    'صبر': Color(0xFF4CAF50),
    'توكل': Color(0xFF2196F3),
    'يقين': Color(0xFF9C27B0),
    'شكر': Color(0xFFFF9800),
    'هداية': Color(0xFFFFD700),
    'ثبات': Color(0xFF795548),
    'رحمة': Color(0xFFE91E63),
    'خوف': Color(0xFF607D8B),
    'رجاء': Color(0xFF00BCD4),
    'دعاء': Color(0xFF8BC34A),
    'تدبر': Color(0xFF673AB7),
    'عام': Color(0xFF757575),
  };

  // ألوان التدرج للخلفيات
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      primaryGreen,
      mediumGreen,
      lightGold,
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFAF0),
      Color(0xFFF5F5DC),
    ],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2D2D2D),
      Color(0xFF1E1E1E),
    ],
  );

  // ألوان الحالات
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);

  // ألوان الأيقونات
  static const Color iconLight = Color(0xFF666666);
  static const Color iconDark = Color(0xFFE0E0E0);
  static const Color iconActive = primaryGold;
  static const Color favoriteIcon = Color(0xFFE91E63);

  // الظلال
  static final BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  static final BoxShadow darkCardShadow = BoxShadow(
    color: Colors.black.withOpacity(0.3),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  /// الحصول على لون الفئة
  static Color getCategoryColor(String category) {
    return categoryColors[category] ?? categoryColors['عام']!;
  }

  /// الحصول على لون فاتح للفئة
  static Color getCategoryLightColor(String category) {
    final color = getCategoryColor(category);
    return color.withOpacity(0.2);
  }

  // =============== ثيمات الألوان الإضافية ===============

  /// ثيم الليل - Night Theme
  static const Color nightPrimary = Color(0xFF1A237E); // أزرق داكن
  static const Color nightSecondary = Color(0xFF90A4AE); // فضي/رمادي مزرق
  static const Color nightAccent = Color(0xFF64B5F6); // أزرق فاتح
  static const Color nightLight = Color(0xFFE3F2FD);

  /// ثيم الورد - Rose Theme
  static const Color rosePrimary = Color(0xFF880E4F); // وردي داكن
  static const Color roseSecondary = Color(0xFFBA68C8); // بنفسجي
  static const Color roseAccent = Color(0xFFF8BBD0); // وردي فاتح
  static const Color roseLight = Color(0xFFFCE4EC);

  /// ثيم الأخضر المريح - Sage Theme
  static const Color sagePrimary = Color(0xFF4A7C59);
  static const Color sageSecondary = Color(0xFFC2A878);

  /// ثيم الذهبي - Golden Theme
  static const Color goldenPrimary = Color(0xFFB8860B);
  static const Color goldenSecondary = Color(0xFF6D4C1E);

  /// ثيم البيج - Beige Theme
  static const Color beigePrimary = Color(0xFF8C7B5B);
  static const Color beigeSecondary = Color(0xFFB89B72);

  /// الحصول على اللون الأساسي حسب الثيم (مفتاح نصي)
  static Color getPrimaryColor(String theme) {
    switch (theme) {
      case 'classic':
        return primaryGreen;
      case 'night':
        return nightPrimary;
      case 'rose':
        return rosePrimary;
      case 'sage':
        return sagePrimary;
      case 'golden':
        return goldenPrimary;
      case 'beige':
        return beigePrimary;
      default:
        return primaryGreen;
    }
  }

  /// الحصول على اللون الثانوي حسب الثيم (مفتاح نصي)
  static Color getSecondaryColor(String theme) {
    switch (theme) {
      case 'classic':
        return primaryGold;
      case 'night':
        return nightSecondary;
      case 'rose':
        return roseSecondary;
      case 'sage':
        return sageSecondary;
      case 'golden':
        return goldenSecondary;
      case 'beige':
        return beigeSecondary;
      default:
        return primaryGold;
    }
  }
}
