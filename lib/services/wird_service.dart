import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/wird_model.dart';

/// خدمة إدارة الورد اليومي
class WirdService {
  static const String _wirdBoxName = 'wirds';
  static const String _wirdStatsBoxName = 'wirdStats';

  static Box<Map>? _wirdBox;
  static Box<dynamic>? _statsBox;

  /// تهيئة الخدمة
  static Future<void> init() async {
    try {
      _wirdBox = await Hive.openBox<Map>(_wirdBoxName);
      _statsBox = await Hive.openBox(_wirdStatsBoxName);
      debugPrint('✅ تم تهيئة خدمة الورد');
    } catch (e) {
      debugPrint('❌ خطأ في تهيئة خدمة الورد: $e');
    }
  }

  /// حفظ ورد
  static Future<void> saveWird(WirdModel wird) async {
    if (_wirdBox == null) await init();
    await _wirdBox!.put(wird.id, wird.toJson());
    debugPrint('💾 تم حفظ الورد: ${wird.title}');
  }

  /// الحصول على ورد بـ ID
  static WirdModel? getWird(String id) {
    if (_wirdBox == null) return null;
    final data = _wirdBox!.get(id);
    if (data == null) return null;
    return WirdModel.fromJson(Map<String, dynamic>.from(data));
  }

  /// الحصول على جميع الأوراد
  static List<WirdModel> getAllWirds() {
    if (_wirdBox == null) return [];
    final wirds = <WirdModel>[];
    for (var key in _wirdBox!.keys) {
      final data = _wirdBox!.get(key);
      if (data != null) {
        wirds.add(WirdModel.fromJson(Map<String, dynamic>.from(data)));
      }
    }
    return wirds;
  }

  /// الحصول على الأوراد النشطة
  static List<WirdModel> getActiveWirds() {
    return getAllWirds().where((w) => w.isActive).toList();
  }

  /// حذف ورد
  static Future<void> deleteWird(String id) async {
    if (_wirdBox == null) await init();
    await _wirdBox!.delete(id);
    debugPrint('🗑️ تم حذف الورد: $id');
  }

  /// تحديث حالة عنصر في الورد
  static Future<void> updateWirdItem(
    String wirdId,
    String itemId,
    bool isCompleted,
  ) async {
    final wird = getWird(wirdId);
    if (wird == null) return;

    // تحديث العنصر
    final itemIndex = wird.items.indexWhere((item) => item.id == itemId);
    if (itemIndex == -1) return;

    wird.items[itemIndex] = wird.items[itemIndex].copyWith(
      isCompleted: isCompleted,
      completedAt: isCompleted ? DateTime.now() : null,
    );

    // التحقق من إتمام جميع العناصر
    if (wird.items.every((item) => item.isCompleted)) {
      // تم إكمال الورد
      await _completeWird(wird);
    }

    await saveWird(wird);
  }

  /// إتمام الورد
  static Future<void> _completeWird(WirdModel wird) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // تحديث آخر إتمام
    wird.lastCompletedAt = now;

    // تحديث الأيام المتتالية
    if (wird.lastCompletedAt != null) {
      final lastCompleted = DateTime(
        wird.lastCompletedAt!.year,
        wird.lastCompletedAt!.month,
        wird.lastCompletedAt!.day,
      );

      final difference = today.difference(lastCompleted).inDays;

      if (difference == 0) {
        // نفس اليوم - لا تفعل شيء
      } else if (difference == 1) {
        // يوم متتالي
        wird.consecutiveDays++;
      } else {
        // انقطع التسلسل
        wird.consecutiveDays = 1;
      }
    } else {
      wird.consecutiveDays = 1;
    }

    // حفظ الإحصائيات
    await _saveWirdStats(wird);
  }

  /// حفظ إحصائيات الورد
  static Future<void> _saveWirdStats(WirdModel wird) async {
    if (_statsBox == null) await init();

    final totalCompleted =
        _statsBox!.get('totalWirdCompleted', defaultValue: 0) as int;
    final longestStreak =
        _statsBox!.get('longestWirdStreak', defaultValue: 0) as int;

    await _statsBox!.put('totalWirdCompleted', totalCompleted + 1);

    if (wird.consecutiveDays > longestStreak) {
      await _statsBox!.put('longestWirdStreak', wird.consecutiveDays);
    }
  }

  /// إعادة تعيين الورد (للإتمام الجديد)
  static Future<void> resetWird(String wirdId) async {
    final wird = getWird(wirdId);
    if (wird == null) return;

    // إعادة تعيين جميع العناصر
    for (var i = 0; i < wird.items.length; i++) {
      wird.items[i] = wird.items[i].copyWith(
        isCompleted: false,
        completedAt: null,
      );
    }

    await saveWird(wird);
  }

  /// إنشاء ورد افتراضي
  static WirdModel createDefaultWird() {
    return WirdModel(
      id: 'default_${DateTime.now().millisecondsSinceEpoch}',
      title: 'وردي اليومي',
      items: [],
      schedule: WirdSchedule.morning,
      createdAt: DateTime.now(),
    );
  }

  /// الحصول على إحصائيات الورد
  static Future<Map<String, int>> getWirdStats() async {
    if (_statsBox == null) await init();

    return {
      'totalCompleted': _statsBox!.get('totalWirdCompleted', defaultValue: 0),
      'longestStreak': _statsBox!.get('longestWirdStreak', defaultValue: 0),
    };
  }

  /// مسح جميع الأوراد
  static Future<void> clearAllWirds() async {
    if (_wirdBox == null) await init();
    await _wirdBox!.clear();
    debugPrint('🗑️ تم مسح جميع الأوراد');
  }
}
