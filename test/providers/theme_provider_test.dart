import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noor_ayah/providers/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ThemeProvider', () {
    test('القيم الافتراضية: وضع نهاري، خط متوسط، ثيم كلاسيكي', () {
      final provider = ThemeProvider();
      expect(provider.isDarkMode, false);
      expect(provider.fontSize, FontSize.medium);
      expect(provider.colorTheme, AppThemeColor.classic);
    });

    test('toggleTheme يبدّل الوضع الليلي ويحفظه', () async {
      final provider = ThemeProvider();
      await provider.toggleTheme();
      expect(provider.isDarkMode, true);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('isDarkMode'), true);
    });

    test('setColorTheme يغيّر الثيم ويحفظ الفهرس الصحيح', () async {
      final provider = ThemeProvider();
      await provider.setColorTheme(AppThemeColor.golden);
      expect(provider.colorTheme, AppThemeColor.golden);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('colorTheme'), AppThemeColor.golden.index);
    });

    test('setFontSize يغيّر الحجم ويحفظه', () async {
      final provider = ThemeProvider();
      await provider.setFontSize(FontSize.large);
      expect(provider.fontSize, FontSize.large);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('fontSize'), FontSize.large.index);
    });

    test('fontSizeMultiplier يطابق كل حجم خط', () async {
      final provider = ThemeProvider();

      await provider.setFontSize(FontSize.small);
      expect(provider.fontSizeMultiplier, 0.85);

      await provider.setFontSize(FontSize.medium);
      expect(provider.fontSizeMultiplier, 1.0);

      await provider.setFontSize(FontSize.large);
      expect(provider.fontSizeMultiplier, 1.15);
    });

    test('notifyListeners يُستدعى عند تغيير الثيم', () async {
      final provider = ThemeProvider();
      var notified = false;
      provider.addListener(() => notified = true);
      await provider.setColorTheme(AppThemeColor.beige);
      expect(notified, true);
    });

    test('setThemeMode يدعم تلقائي/فاتح/داكن ويحفظه', () async {
      final provider = ThemeProvider();
      await provider.setThemeMode(ThemeMode.system);
      expect(provider.themeMode, ThemeMode.system);
      expect(provider.isDarkMode, false);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('themeMode'), ThemeMode.system.index);

      await provider.setThemeMode(ThemeMode.dark);
      expect(provider.isDarkMode, true);
    });

    test('toggleTheme يتنقل بين الفاتح والداكن', () async {
      final provider = ThemeProvider();
      await provider.setThemeMode(ThemeMode.light);
      await provider.toggleTheme();
      expect(provider.themeMode, ThemeMode.dark);
      await provider.toggleTheme();
      expect(provider.themeMode, ThemeMode.light);
    });
  });
}
