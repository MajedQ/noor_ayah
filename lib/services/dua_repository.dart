import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/dua_model.dart';

/// مستودع الأدعية - يدير تحميل وتخزين الأدعية
class DuaRepository {
  static List<DuaModel> _duas = [];
  static bool _isLoaded = false;

  /// تحميل جميع الأدعية من ملف JSON
  static Future<List<DuaModel>> loadAllDuas() async {
    if (_isLoaded && _duas.isNotEmpty) {
      return _duas;
    }

    try {
      final data = await rootBundle.loadString('assets/data/duas.json');
      final list = json.decode(data) as List<dynamic>;
      _duas = list
          .map((e) => DuaModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _isLoaded = true;
      debugPrint('✅ تم تحميل ${_duas.length} دعاء');
      return _duas;
    } catch (e) {
      debugPrint('❌ خطأ في تحميل الأدعية: $e');
      return [];
    }
  }

  /// الحصول على جميع الأدعية (مع تحميلها إن لم تكن محملة)
  static Future<List<DuaModel>> getAllDuas() async {
    if (!_isLoaded || _duas.isEmpty) {
      await loadAllDuas();
    }
    return _duas;
  }

  /// الحصول على دعاء اليوم بناءً على التاريخ والمناسبات
  static DuaModel? getTodayDua() {
    if (_duas.isEmpty) return null;

    // 1. التحقق من المناسبات الخاصة (أعلى أولوية)
    final specialOccasionDuas = _duas.where((dua) {
      return dua.occasion != DuaOccasion.general &&
          dua.occasion.isCurrentOccasion;
    }).toList();

    if (specialOccasionDuas.isNotEmpty) {
      // ترتيب حسب الأولوية
      specialOccasionDuas
          .sort((a, b) => b.occasion.priority.compareTo(a.occasion.priority));

      // اختيار عشوائي من الأدعية ذات الأولوية الأعلى
      final topPriority = specialOccasionDuas.first.occasion.priority;
      final topDuas = specialOccasionDuas
          .where((d) => d.occasion.priority == topPriority)
          .toList();

      final now = DateTime.now();
      final index = now.day % topDuas.length;
      return topDuas[index];
    }

    // 2. التحقق من الوقت (صباح أو مساء)
    final now = DateTime.now();
    final hour = now.hour;

    List<DuaModel> timeDuas;
    if (hour >= 5 && hour < 12) {
      // صباح (5 ص - 12 ظ)
      timeDuas = _duas.where((d) => d.category == DuaCategory.morning).toList();
    } else if (hour >= 15 && hour < 20) {
      // مساء (3 م - 8 م)
      timeDuas = _duas.where((d) => d.category == DuaCategory.evening).toList();
    } else {
      // أوقات أخرى - أدعية عامة
      timeDuas = _duas.where((d) => d.category == DuaCategory.general).toList();
    }

    if (timeDuas.isNotEmpty) {
      final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
      final index = dayOfYear % timeDuas.length;
      return timeDuas[index];
    }

    // 3. إذا لم يوجد شيء، نختار من جميع الأدعية
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = dayOfYear % _duas.length;
    return _duas[index];
  }

  /// الحصول على دعاء بـ ID محدد
  static DuaModel? getDuaById(int id) {
    try {
      return _duas.firstWhere((dua) => dua.id == id);
    } catch (e) {
      return null;
    }
  }

  /// البحث في الأدعية
  static List<DuaModel> searchDuas(String query) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase().trim();

    return _duas.where((dua) {
      return dua.title.toLowerCase().contains(lowerQuery) ||
          dua.duaText.toLowerCase().contains(lowerQuery) ||
          dua.source.toLowerCase().contains(lowerQuery) ||
          (dua.benefits?.toLowerCase().contains(lowerQuery) ?? false) ||
          dua.category.displayName.toLowerCase().contains(lowerQuery) ||
          dua.occasion.displayName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// الحصول على أدعية حسب الفئة
  static List<DuaModel> getDuasByCategory(DuaCategory category) {
    return _duas.where((dua) => dua.category == category).toList();
  }

  /// الحصول على أدعية حسب المناسبة
  static List<DuaModel> getDuasByOccasion(DuaOccasion occasion) {
    return _duas.where((dua) => dua.occasion == occasion).toList();
  }

  /// الحصول على جميع الفئات المتاحة
  static List<DuaCategory> getAllCategories() {
    final categories = <DuaCategory>{};
    for (var dua in _duas) {
      categories.add(dua.category);
    }
    return categories.toList();
  }

  /// الحصول على جميع المناسبات المتاحة
  static List<DuaOccasion> getAllOccasions() {
    final occasions = <DuaOccasion>{};
    for (var dua in _duas) {
      occasions.add(dua.occasion);
    }
    return occasions.toList();
  }

  /// الحصول على عدد الأدعية في فئة معينة
  static int getCategoryCount(DuaCategory category) {
    return getDuasByCategory(category).length;
  }

  /// الحصول على عدد الأدعية في مناسبة معينة
  static int getOccasionCount(DuaOccasion occasion) {
    return getDuasByOccasion(occasion).length;
  }

  /// الحصول على أدعية عشوائية
  static List<DuaModel> getRandomDuas(int count) {
    if (_duas.length <= count) return _duas;

    final shuffled = List<DuaModel>.from(_duas)..shuffle();
    return shuffled.take(count).toList();
  }

  /// الحصول على الدعاء التالي
  static DuaModel? getNextDua(int currentId) {
    final currentIndex = _duas.indexWhere((d) => d.id == currentId);
    if (currentIndex == -1 || currentIndex >= _duas.length - 1) {
      return null;
    }
    return _duas[currentIndex + 1];
  }

  /// الحصول على الدعاء السابق
  static DuaModel? getPreviousDua(int currentId) {
    final currentIndex = _duas.indexWhere((d) => d.id == currentId);
    if (currentIndex <= 0) {
      return null;
    }
    return _duas[currentIndex - 1];
  }

  /// عدد الأدعية الكلي
  static int get totalCount => _duas.length;

  /// التحقق من تحميل الأدعية
  static bool get isLoaded => _isLoaded;

  /// إعادة تحميل الأدعية
  static Future<void> reload() async {
    _isLoaded = false;
    _duas.clear();
    await loadAllDuas();
  }

  /// مسح الكاش
  static void clearCache() {
    _duas.clear();
    _isLoaded = false;
  }
}
