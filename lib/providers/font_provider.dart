import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider لإدارة اختيار خط الآيات القرآنية وخطوط اللغات المختلفة
class FontProvider extends ChangeNotifier {
  static const String _fontKey = 'selectedQuranicFont';
  static const String _uiFontKey = 'selectedUIFont';

  QuranicFont _selectedFont = QuranicFont.amiri;
  UIFont _selectedUIFont = UIFont.ibmPlexArabic;
  String _currentLocale = 'ar';

  QuranicFont get selectedFont => _selectedFont;
  UIFont get selectedUIFont => _selectedUIFont;

  FontProvider() {
    _loadSavedFont();
  }

  /// تحميل الخط المحفوظ
  Future<void> _loadSavedFont() async {
    final prefs = await SharedPreferences.getInstance();
    final fontIndex = prefs.getInt(_fontKey) ?? 3; // Amiri افتراضياً
    final uiFontIndex =
        prefs.getInt(_uiFontKey) ?? 0; // IBM Plex Arabic افتراضياً

    if (fontIndex < QuranicFont.values.length) {
      _selectedFont = QuranicFont.values[fontIndex];
    }
    if (uiFontIndex < UIFont.values.length) {
      _selectedUIFont = UIFont.values[uiFontIndex];
    }

    notifyListeners();
  }

  /// تغيير خط الآيات القرآنية
  Future<void> setFont(QuranicFont font) async {
    _selectedFont = font;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_fontKey, font.index);
    notifyListeners();
  }

  /// تغيير خط الواجهة
  Future<void> setUIFont(UIFont font) async {
    _selectedUIFont = font;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_uiFontKey, font.index);
    notifyListeners();
  }

  /// تحديث اللغة الحالية
  void setLocale(String locale) {
    _currentLocale = locale;
    notifyListeners();
  }

  /// الحصول على اسم عائلة خط الآيات
  String get fontFamily {
    return _selectedFont.fontFamily;
  }

  /// الحصول على اسم عائلة خط الواجهة حسب اللغة
  String get uiFontFamily {
    return getLocalizedUIFont(_currentLocale);
  }

  /// الحصول على الخط المناسب للغة المحددة
  String getLocalizedUIFont(String locale) {
    switch (locale) {
      case 'ar':
        // العربية - استخدام Cairo أو الخط المختار
        return _selectedUIFont.fontFamily;
      case 'ur':
        // الأردية - استخدام Noto Nastaliq Urdu
        return 'NotoNastaliqUrdu';
      case 'en':
      case 'fr':
      case 'id':
        // اللغات اللاتينية - استخدام Roboto
        return 'Roboto';
      default:
        return _selectedUIFont.fontFamily;
    }
  }

  /// الحصول على خط مناسب للنصوص العربية (التدبر والأدعية)
  String getArabicTextFont(String locale) {
    // للنصوص العربية والأردية، نستخدم الخطوط العربية
    if (locale == 'ar' || locale == 'ur') {
      return _selectedUIFont.fontFamily;
    }
    return getLocalizedUIFont(locale);
  }
}

/// تعداد للخطوط القرآنية المدعومة
enum QuranicFont {
  uthmanic, // الرسم العثماني
  scheherazade, // شهرزاد
  lateef, // لطيف
  amiri, // أميري (افتراضي)
}

extension QuranicFontExtension on QuranicFont {
  String get displayName {
    switch (this) {
      case QuranicFont.uthmanic:
        return 'الرسم العثماني';
      case QuranicFont.scheherazade:
        return 'شهرزاد';
      case QuranicFont.lateef:
        return 'لطيف';
      case QuranicFont.amiri:
        return 'أميري';
    }
  }

  String get displayNameEnglish {
    switch (this) {
      case QuranicFont.uthmanic:
        return 'Uthmanic Script';
      case QuranicFont.scheherazade:
        return 'Scheherazade';
      case QuranicFont.lateef:
        return 'Lateef';
      case QuranicFont.amiri:
        return 'Amiri';
    }
  }

  String get fontFamily {
    switch (this) {
      case QuranicFont.uthmanic:
        return 'UthmanicHafs';
      case QuranicFont.scheherazade:
        return 'ScheherazadeNew';
      case QuranicFont.lateef:
        return 'Lateef';
      case QuranicFont.amiri:
        return 'Amiri';
    }
  }

  String get description {
    switch (this) {
      case QuranicFont.uthmanic:
        return 'الخط الرسمي من مجمع الملك فهد - مع التشكيل الكامل';
      case QuranicFont.scheherazade:
        return 'خط عربي جميل ومفتوح المصدر مع دعم كامل للتشكيل';
      case QuranicFont.lateef:
        return 'خط نسخي أنيق من SIL مع تشكيل واضح';
      case QuranicFont.amiri:
        return 'خط عربي كلاسيكي وواضح';
    }
  }

  /// آية نموذجية للمعاينة
  static const String sampleVerse = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
}

/// تعداد لخطوط الواجهة المدعومة
enum UIFont {
  ibmPlexArabic, // IBM Plex Arabic (عربي)
  amiri, // أميري (عربي)
  notoNastaliq, // Noto Nastaliq (أردي)
  roboto, // Roboto (لاتيني)
  notoSans, // Noto Sans (متعدد اللغات)
}

extension UIFontExtension on UIFont {
  String get displayName {
    switch (this) {
      case UIFont.ibmPlexArabic:
        return 'IBM Plex Arabic';
      case UIFont.amiri:
        return 'أميري';
      case UIFont.notoNastaliq:
        return 'Noto Nastaliq';
      case UIFont.roboto:
        return 'Roboto';
      case UIFont.notoSans:
        return 'Noto Sans';
    }
  }

  String get displayNameEnglish {
    switch (this) {
      case UIFont.ibmPlexArabic:
        return 'IBM Plex Arabic';
      case UIFont.amiri:
        return 'Amiri';
      case UIFont.notoNastaliq:
        return 'Noto Nastaliq';
      case UIFont.roboto:
        return 'Roboto';
      case UIFont.notoSans:
        return 'Noto Sans';
    }
  }

  String get fontFamily {
    switch (this) {
      case UIFont.ibmPlexArabic:
        return 'IBMPlexArabic';
      case UIFont.amiri:
        return 'Amiri';
      case UIFont.notoNastaliq:
        return 'NotoNastaliqUrdu';
      case UIFont.roboto:
        return 'Roboto';
      case UIFont.notoSans:
        return 'NotoSans';
    }
  }

  String get description {
    switch (this) {
      case UIFont.ibmPlexArabic:
        return 'خط عربي عصري وأنيق من IBM - مناسب للواجهة';
      case UIFont.amiri:
        return 'خط عربي كلاسيكي وأنيق';
      case UIFont.notoNastaliq:
        return 'خط نستعليق جميل للأردية';
      case UIFont.roboto:
        return 'خط حديث للغات اللاتينية';
      case UIFont.notoSans:
        return 'خط متعدد اللغات واضح';
    }
  }

  /// اللغات المدعومة بشكل أمثل
  List<String> get supportedLocales {
    switch (this) {
      case UIFont.ibmPlexArabic:
      case UIFont.amiri:
        return ['ar'];
      case UIFont.notoNastaliq:
        return ['ur'];
      case UIFont.roboto:
      case UIFont.notoSans:
        return ['en', 'fr', 'id'];
    }
  }
}
