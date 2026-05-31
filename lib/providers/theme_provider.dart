import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider لإدارة السمة (الوضع الفاتح/الليلي) وحجم الخط
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  static const String _themeModeKey = 'themeMode';
  static const String _fontSizeKey = 'fontSize';
  static const String _colorThemeKey = 'colorTheme';

  ThemeMode _themeMode = ThemeMode.light;
  FontSize _fontSize = FontSize.medium;
  AppThemeColor _colorTheme = AppThemeColor.classic;

  ThemeMode get themeMode => _themeMode;

  /// متوافق مع الكود القديم: داكن فقط عند اختيار الوضع الليلي صراحةً
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  FontSize get fontSize => _fontSize;
  AppThemeColor get colorTheme => _colorTheme;

  ThemeProvider() {
    _loadPreferences();
  }

  /// تحميل التفضيلات المحفوظة
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    // وضع السمة: تفضيل المفتاح الجديد، مع توافق رجعي مع isDarkMode
    final modeIndex = prefs.getInt(_themeModeKey);
    if (modeIndex != null && modeIndex >= 0 && modeIndex < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[modeIndex];
    } else {
      _themeMode =
          (prefs.getBool(_themeKey) ?? false) ? ThemeMode.dark : ThemeMode.light;
    }
    final fontSizeIndex = prefs.getInt(_fontSizeKey) ?? 1;
    final colorThemeIndex = prefs.getInt(_colorThemeKey) ?? 0;
    _fontSize = FontSize.values[fontSizeIndex];
    _colorTheme = AppThemeColor.values[colorThemeIndex];
    notifyListeners();
  }

  /// التبديل بين الوضع الفاتح والليلي (يتجاهل وضع النظام)
  Future<void> toggleTheme() async {
    await setThemeMode(
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  /// تعيين وضع السمة (فاتح/داكن/تلقائي حسب النظام)
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
    await prefs.setBool(_themeKey, mode == ThemeMode.dark); // توافق رجعي
    notifyListeners();
  }

  /// تغيير حجم الخط
  Future<void> setFontSize(FontSize size) async {
    _fontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_fontSizeKey, size.index);
    notifyListeners();
  }

  /// تغيير ثيم الألوان
  Future<void> setColorTheme(AppThemeColor theme) async {
    _colorTheme = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorThemeKey, theme.index);
    notifyListeners();
  }

  /// الحصول على مضاعف حجم الخط
  double get fontSizeMultiplier {
    switch (_fontSize) {
      case FontSize.small:
        return 0.85;
      case FontSize.medium:
        return 1.0;
      case FontSize.large:
        return 1.15;
    }
  }
}

/// تعداد لأحجام الخط
enum FontSize {
  small,
  medium,
  large,
}

extension FontSizeExtension on FontSize {
  String get displayName {
    switch (this) {
      case FontSize.small:
        return 'صغير';
      case FontSize.medium:
        return 'متوسط';
      case FontSize.large:
        return 'كبير';
    }
  }
}

/// تعداد لثيمات الألوان
///
/// ملاحظة: ترتيب القيم مهم لأنه يُحفظ كـ index في SharedPreferences،
/// لذا تُضاف الثيمات الجديدة في النهاية للحفاظ على توافق التفضيلات المحفوظة.
enum AppThemeColor {
  classic, // الكلاسيكي - أخضر وذهبي
  night, // ليلي - أزرق داكن وفضي
  rose, // وردي - وردي وبنفسجي
  sage, // أخضر مريح - أخضر هادئ للعين
  golden, // ذهبي - ذهبي دافئ مع بني
  beige, // بيج - رملي/سيبيا مريح للعين
}

extension AppThemeColorExtension on AppThemeColor {
  String get displayName {
    switch (this) {
      case AppThemeColor.classic:
        return 'الكلاسيكي';
      case AppThemeColor.night:
        return 'الليلي';
      case AppThemeColor.rose:
        return 'الوردي';
      case AppThemeColor.sage:
        return 'الأخضر المريح';
      case AppThemeColor.golden:
        return 'الذهبي';
      case AppThemeColor.beige:
        return 'البيج';
    }
  }

  String get description {
    switch (this) {
      case AppThemeColor.classic:
        return 'أخضر وذهبي';
      case AppThemeColor.night:
        return 'أزرق وفضي';
      case AppThemeColor.rose:
        return 'وردي وبنفسجي';
      case AppThemeColor.sage:
        return 'أخضر هادئ مريح للعين';
      case AppThemeColor.golden:
        return 'ذهبي دافئ';
      case AppThemeColor.beige:
        return 'رملي مريح للعين';
    }
  }
}


/// امتداد لعرض أوضاع السمة بالعربية مع أيقوناتها
extension ThemeModeArabicX on ThemeMode {
  String get arabicName {
    switch (this) {
      case ThemeMode.light:
        return 'نهاري';
      case ThemeMode.dark:
        return 'ليلي';
      case ThemeMode.system:
        return 'تلقائي (حسب النظام)';
    }
  }

  IconData get icon {
    switch (this) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
