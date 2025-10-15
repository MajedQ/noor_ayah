import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hijri/hijri_calendar.dart';
import '../services/hijri_date_service.dart';
import '../utils/helpers.dart';

/// Provider لإدارة التقويم (هجري/ميلادي)
class CalendarProvider extends ChangeNotifier {
  static const String _calendarKey = 'showHijriCalendar';
  bool _showHijri = true;

  bool get showHijri => _showHijri;
  bool get showGregorian => !_showHijri;

  CalendarProvider() {
    _loadPreference();
  }

  /// تحميل التفضيل المحفوظ
  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _showHijri = prefs.getBool(_calendarKey) ?? true;
    notifyListeners();
  }

  /// التبديل بين الهجري والميلادي
  Future<void> toggleCalendar() async {
    _showHijri = !_showHijri;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_calendarKey, _showHijri);
    notifyListeners();
  }

  /// الحصول على التاريخ المنسّق
  String getFormattedDate({String locale = 'ar'}) {
    if (_showHijri) {
      final hijri = HijriDateService.getCurrentHijriDate();
      return HijriDateService.formatHijriDate(hijri, locale: locale);
    } else {
      final now = DateTime.now();
      return AppHelpers.formatDateArabic(now);
    }
  }

  /// الحصول على التاريخ الهجري الحالي
  HijriCalendar getCurrentHijri() {
    return HijriDateService.getCurrentHijriDate();
  }

  /// الحصول على التاريخ الميلادي الحالي
  DateTime getCurrentGregorian() {
    return DateTime.now();
  }

  /// التحقق من شهر رمضان
  bool isRamadan() {
    return HijriDateService.isRamadan(null);
  }

  /// التحقق من الأشهر الحرم
  bool isSacredMonth() {
    return HijriDateService.isSacredMonth(null);
  }

  /// الحصول على أيقونة التقويم
  IconData get calendarIcon {
    return _showHijri ? Icons.calendar_month : Icons.calendar_today;
  }

  /// الحصول على نوع التقويم كنص
  String get calendarType {
    return _showHijri ? 'هجري' : 'ميلادي';
  }

  /// الحصول على نوع التقويم بالإنجليزية
  String get calendarTypeEnglish {
    return _showHijri ? 'Hijri' : 'Gregorian';
  }
}
