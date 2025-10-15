import 'package:flutter/material.dart';
import '../models/wird_model.dart';
import '../services/wird_service.dart';

/// Provider لإدارة الورد اليومي
class WirdProvider extends ChangeNotifier {
  List<WirdModel> _wirds = [];
  WirdModel? _activeWird;
  bool _isLoading = false;
  Map<String, int> _stats = {};

  List<WirdModel> get wirds => _wirds;
  WirdModel? get activeWird => _activeWird;
  bool get isLoading => _isLoading;
  Map<String, int> get stats => _stats;

  /// تهيئة Provider
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      await WirdService.init();
      await loadWirds();
      await loadStats();
    } catch (e) {
      debugPrint('خطأ في تهيئة WirdProvider: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// تحميل جميع الأوراد
  Future<void> loadWirds() async {
    _wirds = WirdService.getAllWirds();
    final activeWirds = _wirds.where((w) => w.isActive).toList();
    _activeWird = activeWirds.isNotEmpty ? activeWirds.first : null;
    notifyListeners();
  }

  /// تحميل الإحصائيات
  Future<void> loadStats() async {
    _stats = await WirdService.getWirdStats();
    notifyListeners();
  }

  /// إنشاء ورد جديد
  Future<void> createWird(WirdModel wird) async {
    await WirdService.saveWird(wird);
    await loadWirds();
  }

  /// تحديث ورد
  Future<void> updateWird(WirdModel wird) async {
    await WirdService.saveWird(wird);
    await loadWirds();
  }

  /// حذف ورد
  Future<void> deleteWird(String id) async {
    await WirdService.deleteWird(id);
    await loadWirds();
  }

  /// تعيين الورد النشط
  Future<void> setActiveWird(String wirdId) async {
    // إلغاء تفعيل جميع الأوراد الأخرى
    for (var wird in _wirds) {
      if (wird.id == wirdId) {
        wird.isActive = true;
        _activeWird = wird;
      } else {
        wird.isActive = false;
      }
      await WirdService.saveWird(wird);
    }
    await loadWirds();
  }

  /// تحديث حالة عنصر في الورد
  Future<void> toggleWirdItem(String wirdId, String itemId) async {
    final wird = WirdService.getWird(wirdId);
    if (wird == null) return;

    final item = wird.items.firstWhere((item) => item.id == itemId);
    await WirdService.updateWirdItem(wirdId, itemId, !item.isCompleted);

    await loadWirds();
    await loadStats();
  }

  /// إعادة تعيين الورد
  Future<void> resetWird(String wirdId) async {
    await WirdService.resetWird(wirdId);
    await loadWirds();
  }

  /// إنشاء ورد افتراضي
  Future<WirdModel> createDefaultWird() async {
    final wird = WirdService.createDefaultWird();
    await createWird(wird);
    return wird;
  }

  /// الحصول على الورد النشط لليوم
  WirdModel? getTodayWird() {
    if (_activeWird == null) return null;
    if (!_activeWird!.shouldShowNow) return null;
    return _activeWird;
  }

  /// إضافة عنصر للورد
  Future<void> addItemToWird(String wirdId, WirdItem item) async {
    final wird = WirdService.getWird(wirdId);
    if (wird == null) return;

    wird.items.add(item);
    await WirdService.saveWird(wird);
    await loadWirds();
  }

  /// إزالة عنصر من الورد
  Future<void> removeItemFromWird(String wirdId, String itemId) async {
    final wird = WirdService.getWird(wirdId);
    if (wird == null) return;

    wird.items.removeWhere((item) => item.id == itemId);
    await WirdService.saveWird(wird);
    await loadWirds();
  }

  /// مسح جميع الأوراد
  Future<void> clearAllWirds() async {
    await WirdService.clearAllWirds();
    await loadWirds();
  }
}
