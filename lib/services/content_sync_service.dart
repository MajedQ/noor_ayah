import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/content_update_model.dart';
import 'verse_repository.dart';
import 'dua_repository.dart';

/// خدمة مزامنة المحتوى من السيرفر
class ContentSyncService {
  static const String _lastSyncKey = 'lastSyncDate';
  static const String _autoSyncKey = 'autoSync';
  static const String _syncFrequencyKey = 'syncFrequency';
  static const String _currentVersionKey = 'contentVersion';

  // رابط الAPI (يمكن تغييره للإنتاج)
  // TODO: تحديث هذا الرابط عند توفر Laravel API
  // ignore: unused_field
  static const String _apiBaseUrl =
      'https://raw.githubusercontent.com/YOUR_REPO/main/api';
  // ignore: unused_field
  static const String _updatesEndpoint = '$_apiBaseUrl/updates.json';
  // ignore: unused_field
  static const String _versesEndpoint = '$_apiBaseUrl/verses.json';
  // ignore: unused_field
  static const String _duasEndpoint = '$_apiBaseUrl/duas.json';

  /// التحقق من وجود تحديثات
  static Future<ContentUpdate?> checkForUpdates() async {
    try {
      debugPrint('🔍 يتحقق من التحديثات...');

      // في الوقت الحالي، نُرجع تحديث وهمي للاختبار
      // TODO: استبدل هذا بطلب HTTP حقيقي عند توفر الAPI

      // محاكاة طلب HTTP
      // final response = await http.get(Uri.parse(_updatesEndpoint));
      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body);
      //   return ContentUpdate.fromJson(data);
      // }

      // تحديث تجريبي للاختبار
      final prefs = await SharedPreferences.getInstance();
      final currentVersion = prefs.getString(_currentVersionKey) ?? '1.1.0';

      // إذا كانت النسخة الحالية قديمة، نُرجع تحديث
      if (currentVersion == '1.1.0') {
        return ContentUpdate(
          version: '1.1.0',
          updateDate: DateTime.now(),
          newVersesCount: 10,
          newDuasCount: 20,
          updatedVersesCount: 5,
          description: 'تحديث المحتوى - إضافة آيات وأدعية جديدة',
          newFeatures: [
            'إضافة 10 آيات جديدة من سور مختلفة',
            'إضافة 20 دعاء جديد للمناسبات',
            'تحسين التدبرات والأدعية الموجودة',
          ],
        );
      }

      return null; // لا توجد تحديثات
    } catch (e) {
      debugPrint('❌ خطأ في التحقق من التحديثات: $e');
      return null;
    }
  }

  /// تحميل التحديثات
  static Future<bool> downloadAndInstallUpdates(ContentUpdate update) async {
    try {
      debugPrint('⬇️ يحمل التحديثات...');

      // TODO: تنفيذ التحميل الفعلي من الAPI
      // في الوقت الحالي، نحاكي عملية التحميل والتثبيت

      await Future.delayed(const Duration(seconds: 2));

      // حفظ النسخة الجديدة
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentVersionKey, update.version);
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());

      // إعادة تحميل البيانات
      await VerseRepository.reload();
      await DuaRepository.reload();

      debugPrint('✅ تم تثبيت التحديثات بنجاح');
      return true;
    } catch (e) {
      debugPrint('❌ خطأ في تحميل التحديثات: $e');
      return false;
    }
  }

  /// الحصول على تاريخ آخر مزامنة
  static Future<DateTime?> getLastSyncDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSyncStr = prefs.getString(_lastSyncKey);
      if (lastSyncStr != null) {
        return DateTime.parse(lastSyncStr);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// تعيين تاريخ آخر مزامنة
  static Future<void> setLastSyncDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, date.toIso8601String());
  }

  /// هل المزامنة التلقائية مفعلة
  static Future<bool> isAutoSyncEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoSyncKey) ?? false;
  }

  /// تفعيل/تعطيل المزامنة التلقائية
  static Future<void> setAutoSync(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoSyncKey, enabled);
  }

  /// الحصول على تكرار المزامنة
  static Future<SyncFrequency> getSyncFrequency() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_syncFrequencyKey);

    // إذا لم تكن هناك قيمة محفوظة، نُرجع daily بدلاً من manual
    if (index == null) {
      return SyncFrequency.daily;
    }

    if (index < SyncFrequency.values.length) {
      return SyncFrequency.values[index];
    }
    return SyncFrequency.daily;
  }

  /// تعيين تكرار المزامنة
  static Future<void> setSyncFrequency(SyncFrequency frequency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_syncFrequencyKey, frequency.index);
  }

  /// هل حان وقت المزامنة التلقائية
  static Future<bool> shouldAutoSync() async {
    final isEnabled = await isAutoSyncEnabled();
    if (!isEnabled) return false;

    final lastSync = await getLastSyncDate();
    if (lastSync == null) return true;

    final frequency = await getSyncFrequency();
    final nextSyncDate = lastSync.add(frequency.duration);

    return DateTime.now().isAfter(nextSyncDate);
  }

  /// الحصول على النسخة الحالية
  static Future<String> getCurrentVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentVersionKey) ?? '1.1.0';
  }

  /// تحميل الآيات الجديدة من الAPI
  static Future<List> fetchNewVerses() async {
    try {
      // TODO: استبدل هذا بطلب HTTP حقيقي
      // final response = await http.get(Uri.parse(_versesEndpoint));
      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body) as List;
      //   return data.map((e) => VerseModel.fromJson(e)).toList();
      // }

      return []; // قائمة فارغة للتجربة
    } catch (e) {
      debugPrint('❌ خطأ في تحميل الآيات: $e');
      return [];
    }
  }

  /// تحميل الأدعية الجديدة من الAPI
  static Future<List> fetchNewDuas() async {
    try {
      // TODO: استبدل هذا بطلب HTTP حقيقي
      // final response = await http.get(Uri.parse(_duasEndpoint));
      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body) as List;
      //   return data.map((e) => DuaModel.fromJson(e)).toList();
      // }

      return []; // قائمة فارغة للتجربة
    } catch (e) {
      debugPrint('❌ خطأ في تحميل الأدعية: $e');
      return [];
    }
  }

  /// إعادة تعيين بيانات المزامنة
  static Future<void> resetSyncData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastSyncKey);
    await prefs.remove(_currentVersionKey);
  }
}
