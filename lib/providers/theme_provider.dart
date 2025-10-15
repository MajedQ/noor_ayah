import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider لإدارة السمة (الوضع الفاتح/الليلي) وحجم الخط
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  static const String _fontSizeKey = 'fontSize';
  static const String _colorThemeKey = 'colorTheme';

  bool _isDarkMode = false;
  FontSize _fontSize = FontSize.medium;
  AppThemeColor _colorTheme = AppThemeColor.classic;

  bool get isDarkMode => _isDarkMode;
  FontSize get fontSize => _fontSize;
  AppThemeColor get colorTheme => _colorTheme;

  ThemeProvider() {
    _loadPreferences();
  }

  /// تحميل التفضيلات المحفوظة
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    final fontSizeIndex = prefs.getInt(_fontSizeKey) ?? 1;
    final colorThemeIndex = prefs.getInt(_colorThemeKey) ?? 0;
    _fontSize = FontSize.values[fontSizeIndex];
    _colorTheme = AppThemeColor.values[colorThemeIndex];
    notifyListeners();
  }

  /// التبديل بين الوضع الفاتح والليلي
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
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
enum AppThemeColor {
  classic, // الكلاسيكي - أخضر وذهبي
  night, // ليلي - أزرق داكن وفضي
  rose, // وردي - وردي وبنفسجي
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
    }
  }
}
