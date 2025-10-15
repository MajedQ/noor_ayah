import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider لإدارة اللغة
class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'selectedLocale';
  Locale _locale = const Locale('ar');

  Locale get locale => _locale;

  /// اللغات المدعومة
  static const List<Locale> supportedLocales = [
    Locale('ar'), // العربية
    Locale('en'), // الإنجليزية
    Locale('fr'), // الفرنسية
    Locale('ur'), // الأوردو
    Locale('id'), // الإندونيسية
  ];

  /// أسماء اللغات المعروضة
  static const Map<String, String> languageNames = {
    'ar': 'العربية',
    'en': 'English',
    'fr': 'Français',
    'ur': 'اردو',
    'id': 'Bahasa Indonesia',
  };

  /// أعلام اللغات (emojis)
  static const Map<String, String> languageFlags = {
    'ar': '🇸🇦',
    'en': '🇬🇧',
    'fr': '🇫🇷',
    'ur': '🇵🇰',
    'id': '🇮🇩',
  };

  LocaleProvider() {
    _loadSavedLocale();
  }

  /// تحميل اللغة المحفوظة أو استخدام لغة الجهاز
  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_localeKey);

    if (savedLocale != null) {
      _locale = Locale(savedLocale);
    } else {
      // استخدام لغة الجهاز إذا كانت مدعومة
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      if (supportedLocales
          .any((l) => l.languageCode == deviceLocale.languageCode)) {
        _locale = Locale(deviceLocale.languageCode);
      } else {
        _locale = const Locale('ar'); // افتراضياً العربية
      }
    }
    notifyListeners();
  }

  /// تغيير اللغة
  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) return;

    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  /// الحصول على اسم اللغة
  String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? languageCode;
  }

  /// الحصول على علم اللغة
  String getLanguageFlag(String languageCode) {
    return languageFlags[languageCode] ?? '🌐';
  }

  /// التحقق من اختيار المستخدم للغة
  static Future<bool> hasUserSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_localeKey);
  }

  /// تحديد أن المستخدم اختار اللغة
  static Future<void> markLanguageAsSelected() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_localeKey)) {
      await prefs.setString(_localeKey, 'ar');
    }
  }
}
