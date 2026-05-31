import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// شاشة إعدادات الإشعارات
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  static const String _notificationEnabledKey = 'notificationsEnabled';

  bool _notificationsEnabled = false;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool(_notificationEnabledKey) ?? false;
      final savedHour = prefs.getInt('notificationHour') ?? 9;
      final savedMinute = prefs.getInt('notificationMinute') ?? 0;
      _selectedTime = TimeOfDay(hour: savedHour, minute: savedMinute);
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationEnabledKey, _notificationsEnabled);
    await prefs.setInt('notificationHour', _selectedTime.hour);
    await prefs.setInt('notificationMinute', _selectedTime.minute);
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value) {
      // طلب الأذونات
      final hasPermission = await NotificationService.requestPermissions();
      if (!hasPermission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('يرجى تفعيل أذونات الإشعارات من إعدادات الجهاز'),
            ),
          );
        }
        return;
      }

      // جدولة الإشعار
      await NotificationService.scheduleDailyNotification(time: _selectedTime);
    } else {
      // إلغاء الإشعارات
      await NotificationService.cancelAllNotifications();
    }

    setState(() {
      _notificationsEnabled = value;
    });
    await _saveSettings();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
      await _saveSettings();

      // إعادة جدولة الإشعار إذا كان مفعلاً
      if (_notificationsEnabled) {
        await NotificationService.scheduleDailyNotification(
            time: _selectedTime);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم تحديث وقت الإشعار إلى ${_formatTime(_selectedTime)}',
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _testNotification() async {
    // طلب الأذونات أولاً
    final hasPermission = await NotificationService.requestPermissions();
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى تفعيل أذونات الإشعارات من إعدادات الجهاز'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    await NotificationService.showImmediateNotification(
      title: '🌟 نور آية - اختبار',
      body: 'هذا إشعار تجريبي للتأكد من عمل الإشعارات',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال إشعار تجريبي'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'مساءً' : 'صباحاً';
    return '${hour}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات الإشعارات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // بطاقة معلوماتية
          Card(
            color: AppColors.info.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.info,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'استقبل آية يومية مع التدبر والدعاء في الوقت الذي تختاره',
                      style: AppTextStyles.bodyText(isDark: isDark),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // تفعيل/تعطيل الإشعارات
          Card(
            child: SwitchListTile(
              secondary: Icon(
                _notificationsEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                color: _notificationsEnabled
                    ? AppColors.brandPrimary
                    : Colors.grey,
                size: 32,
              ),
              title: Text(
                'تفعيل الإشعارات اليومية',
                style: AppTextStyles.bodyText(isDark: isDark).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                _notificationsEnabled
                    ? 'ستتلقى إشعاراً يومياً بآية جديدة'
                    : 'قم بالتفعيل لتلقي آية يومياً',
                style: AppTextStyles.caption(isDark: isDark),
              ),
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
            ),
          ),

          const SizedBox(height: 16),

          // اختيار الوقت
          if (_notificationsEnabled) ...[
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.access_time,
                  color: AppColors.brandPrimary,
                  size: 32,
                ),
                title: Text(
                  'وقت الإشعار',
                  style: AppTextStyles.bodyText(isDark: isDark).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _formatTime(_selectedTime),
                  style: AppTextStyles.caption(isDark: isDark).copyWith(
                    color: AppColors.brandPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: _selectTime,
              ),
            ),

            const SizedBox(height: 16),

            // زر الاختبار
            ElevatedButton.icon(
              onPressed: _testNotification,
              icon: const Icon(Icons.notifications),
              label: const Text('اختبر الإشعار الآن'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 16),

            // ملاحظة
            Card(
              color: AppColors.warning.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.warning,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'نصيحة: اختر وقتاً مناسباً للتدبر والتأمل اليومي، '
                        'مثل بعد صلاة الفجر أو قبل النوم',
                        style: AppTextStyles.caption(isDark: isDark),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
