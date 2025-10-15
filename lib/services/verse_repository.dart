import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/verse_model.dart';
import '../utils/constants.dart';

/// مستودع الآيات - يدير تحميل وتخزين الآيات
class VerseRepository {
  static List<VerseModel> _verses = [];
  static bool _isLoaded = false;

  /// تحميل جميع الآيات من ملف JSON
  static Future<List<VerseModel>> loadAllVerses() async {
    if (_isLoaded && _verses.isNotEmpty) {
      return _verses;
    }

    try {
      final data = await rootBundle.loadString(AppConstants.versesJsonPath);
      final list = json.decode(data) as List<dynamic>;
      _verses = list
          .map((e) => VerseModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _isLoaded = true;
      debugPrint('✅ تم تحميل ${_verses.length} آية');
      return _verses;
    } catch (e) {
      debugPrint('❌ خطأ في تحميل الآيات: $e');
      return [];
    }
  }

  /// الحصول على جميع الآيات (مع تحميلها إن لم تكن محملة)
  static Future<List<VerseModel>> getAllVerses() async {
    if (!_isLoaded || _verses.isEmpty) {
      await loadAllVerses();
    }
    return _verses;
  }

  /// الحصول على آية اليوم بناءً على التاريخ
  static VerseModel? getTodayVerse() {
    if (_verses.isEmpty) return null;

    // استخدام اليوم في السنة لتحديد الآية
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = dayOfYear % _verses.length;

    return _verses[index];
  }

  /// الحصول على آية بـ ID محدد
  static VerseModel? getVerseById(int id) {
    try {
      return _verses.firstWhere((verse) => verse.id == id);
    } catch (e) {
      return null;
    }
  }

  /// البحث في الآيات
  static List<VerseModel> searchVerses(String query) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase().trim();

    return _verses.where((verse) {
      return verse.verseText.toLowerCase().contains(lowerQuery) ||
          verse.reflection.toLowerCase().contains(lowerQuery) ||
          verse.dua.toLowerCase().contains(lowerQuery) ||
          verse.surah.toLowerCase().contains(lowerQuery) ||
          verse.categories.any((cat) => cat.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// الحصول على آيات حسب الفئة
  static List<VerseModel> getVersesByCategory(String category) {
    return _verses
        .where((verse) => verse.categories.contains(category))
        .toList();
  }

  /// الحصول على جميع الفئات المتاحة
  static List<String> getAllCategories() {
    final categories = <String>{};
    for (var verse in _verses) {
      categories.addAll(verse.categories);
    }
    return categories.toList()..sort();
  }

  /// الحصول على عدد الآيات في فئة معينة
  static int getCategoryCount(String category) {
    return getVersesByCategory(category).length;
  }

  /// الحصول على آيات عشوائية
  static List<VerseModel> getRandomVerses(int count) {
    if (_verses.length <= count) return _verses;

    final shuffled = List<VerseModel>.from(_verses)..shuffle();
    return shuffled.take(count).toList();
  }

  /// الحصول على الآية التالية
  static VerseModel? getNextVerse(int currentId) {
    final currentIndex = _verses.indexWhere((v) => v.id == currentId);
    if (currentIndex == -1 || currentIndex >= _verses.length - 1) {
      return null;
    }
    return _verses[currentIndex + 1];
  }

  /// الحصول على الآية السابقة
  static VerseModel? getPreviousVerse(int currentId) {
    final currentIndex = _verses.indexWhere((v) => v.id == currentId);
    if (currentIndex <= 0) {
      return null;
    }
    return _verses[currentIndex - 1];
  }

  /// عدد الآيات الكلي
  static int get totalCount => _verses.length;

  /// التحقق من تحميل الآيات
  static bool get isLoaded => _isLoaded;

  /// إعادة تحميل الآيات
  static Future<void> reload() async {
    _isLoaded = false;
    _verses.clear();
    await loadAllVerses();
  }

  /// مسح الكاش
  static void clearCache() {
    _verses.clear();
    _isLoaded = false;
  }
}
