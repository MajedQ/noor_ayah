import 'package:shared_preferences/shared_preferences.dart';

/// خدمة التخزين المحلي باستخدام SharedPreferences
class LocalStorageService {
  static SharedPreferences? _prefs;

  /// تهيئة SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============ الوضع الليلي ============

  static bool get isDarkMode {
    return _prefs?.getBool('isDarkMode') ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool('isDarkMode', value);
  }

  // ============ حجم الخط ============

  static int get fontSize {
    return _prefs?.getInt('fontSize') ?? 1; // 0: small, 1: medium, 2: large
  }

  static Future<void> setFontSize(int value) async {
    await _prefs?.setInt('fontSize', value);
  }

  // ============ آخر آية مقروءة ============

  static int? get lastVerseId {
    return _prefs?.getInt('lastVerseId');
  }

  static Future<void> setLastVerseId(int verseId) async {
    await _prefs?.setInt('lastVerseId', verseId);
  }

  // ============ تاريخ آخر قراءة ============

  static String? get lastReadDate {
    return _prefs?.getString('lastReadDate');
  }

  static Future<void> setLastReadDate(String date) async {
    await _prefs?.setString('lastReadDate', date);
  }

  // ============ عداد الآيات المقروءة ============

  static int get readVersesCount {
    return _prefs?.getInt('readVersesCount') ?? 0;
  }

  static Future<void> incrementReadVersesCount() async {
    final current = readVersesCount;
    await _prefs?.setInt('readVersesCount', current + 1);
  }

  // ============ التطبيق تم فتحه لأول مرة ============

  static bool get isFirstTime {
    return _prefs?.getBool('isFirstTime') ?? true;
  }

  static Future<void> setNotFirstTime() async {
    await _prefs?.setBool('isFirstTime', false);
  }

  // ============ مسح جميع البيانات ============

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }

  // ============ حفظ واسترجاع قيم مخصصة ============

  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }
}
