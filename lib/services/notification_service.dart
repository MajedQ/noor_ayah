import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import '../models/verse_model.dart';
import 'verse_repository.dart';

/// خدمة الإشعارات المحلية
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// تهيئة خدمة الإشعارات
  static Future<void> init() async {
    if (_initialized) return;

    try {
      // تهيئة timezone
      tz.initializeTimeZones();
      tz.setLocalLocation(
          tz.getLocation('Asia/Riyadh')); // تعيين المنطقة الزمنية

      // إعدادات Android
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // إعدادات iOS
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      // إعدادات التهيئة
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _initialized = true;
      debugPrint('✅ NotificationService initialized');
    } catch (e) {
      debugPrint('❌ Error initializing NotificationService: $e');
    }
  }

  /// معالجة الضغط على الإشعار
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // يمكن إضافة navigation هنا
  }

  /// طلب أذونات الإشعارات
  static Future<bool> requestPermissions() async {
    if (await Permission.notification.isGranted) {
      return true;
    }

    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// التحقق من الأذونات
  static Future<bool> hasPermissions() async {
    return await Permission.notification.isGranted;
  }

  /// جدولة إشعار يومي
  static Future<void> scheduleDailyNotification({
    required TimeOfDay time,
  }) async {
    try {
      // التحقق من الأذونات أولاً
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        debugPrint('❌ لا توجد أذونات للإشعارات');
        return;
      }

      // إلغاء الإشعارات السابقة
      await cancelAllNotifications();

      // الحصول على آية عشوائية
      final verse = await getRandomVerseForNotification();
      if (verse == null) {
        debugPrint('❌ لا توجد آيات للإشعار');
        return;
      }

      // إعداد الوقت
      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      // إذا كان الوقت قد مضى اليوم، جدوله لليوم التالي
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      // تفاصيل الإشعار لـ Android
      const androidDetails = AndroidNotificationDetails(
        'daily_verse_channel',
        'آية اليوم',
        channelDescription: 'إشعار يومي بآية من القرآن الكريم',
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(''),
      );

      // تفاصيل الإشعار لـ iOS
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // جدولة الإشعار اليومي
      await _notifications.zonedSchedule(
        0, // notification ID
        '🌟 نور آية - آية اليوم',
        verse.verseText,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // يتكرر يومياً
        payload: verse.id.toString(),
      );

      debugPrint(
          '✅ تم جدولة الإشعار اليومي للساعة ${time.hour}:${time.minute}');
    } catch (e) {
      debugPrint('❌ خطأ في جدولة الإشعار: $e');
    }
  }

  /// إلغاء جميع الإشعارات
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    debugPrint('✅ تم إلغاء جميع الإشعارات');
  }

  /// إلغاء إشعار محدد
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// عرض إشعار فوري (للاختبار)
  static Future<void> showImmediateNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      'إشعارات الاختبار',
      channelDescription: 'قناة لاختبار الإشعارات',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      999,
      title,
      body,
      details,
    );
  }

  /// الحصول على آية عشوائية للإشعار
  static Future<VerseModel?> getRandomVerseForNotification() async {
    try {
      final verses = await VerseRepository.getAllVerses();
      if (verses.isEmpty) return null;

      verses.shuffle();
      return verses.first;
    } catch (e) {
      debugPrint('Error getting random verse: $e');
      return null;
    }
  }

  /// الحصول على الإشعارات المجدولة
  static Future<List<PendingNotificationRequest>>
      getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// التحقق من وجود إشعارات مجدولة
  static Future<bool> hasScheduledNotifications() async {
    final pending = await getPendingNotifications();
    return pending.isNotEmpty;
  }
}
