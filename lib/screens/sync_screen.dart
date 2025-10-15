import 'package:flutter/material.dart';
import '../models/content_update_model.dart';
import '../services/content_sync_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// شاشة المزامنة وتحديث المحتوى
class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  SyncStatus _syncStatus = SyncStatus.idle;
  ContentUpdate? _availableUpdate;
  DateTime? _lastSyncDate;
  bool _autoSync = false;
  SyncFrequency _syncFrequency =
      SyncFrequency.daily; // القيمة الافتراضية daily بدلاً من manual
  String _currentVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _loadSyncSettings();
  }

  Future<void> _loadSyncSettings() async {
    final lastSync = await ContentSyncService.getLastSyncDate();
    final autoSync = await ContentSyncService.isAutoSyncEnabled();
    final frequency = await ContentSyncService.getSyncFrequency();
    final version = await ContentSyncService.getCurrentVersion();

    setState(() {
      _lastSyncDate = lastSync;
      _autoSync = autoSync;
      _syncFrequency = frequency;
      _currentVersion = version;
    });
  }

  Future<void> _checkForUpdates() async {
    setState(() {
      _syncStatus = SyncStatus.checking;
    });

    try {
      final update = await ContentSyncService.checkForUpdates();

      setState(() {
        _availableUpdate = update;
        _syncStatus = update != null ? SyncStatus.idle : SyncStatus.completed;
      });

      if (update == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('أنت تستخدم أحدث نسخة من المحتوى'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _syncStatus = SyncStatus.error;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء التحقق من التحديثات'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _installUpdate() async {
    if (_availableUpdate == null) return;

    setState(() {
      _syncStatus = SyncStatus.downloading;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _syncStatus = SyncStatus.installing;
    });

    final success =
        await ContentSyncService.downloadAndInstallUpdates(_availableUpdate!);

    if (success) {
      setState(() {
        _syncStatus = SyncStatus.completed;
        _availableUpdate = null;
        _currentVersion = _availableUpdate?.version ?? _currentVersion;
      });

      await _loadSyncSettings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم تحديث المحتوى بنجاح'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      }
    } else {
      setState(() {
        _syncStatus = SyncStatus.error;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء تثبيت التحديث'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _toggleAutoSync(bool value) async {
    await ContentSyncService.setAutoSync(value);
    setState(() {
      _autoSync = value;
    });
  }

  Future<void> _changeSyncFrequency(SyncFrequency? frequency) async {
    if (frequency == null) return;
    await ContentSyncService.setSyncFrequency(frequency);
    setState(() {
      _syncFrequency = frequency;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('مزامنة المحتوى'),
        backgroundColor:
            isDark ? theme.appBarTheme.backgroundColor : AppColors.primaryGreen,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    theme.colorScheme.background,
                    theme.colorScheme.surface,
                  ]
                : [
                    AppColors.lightBeige,
                    Colors.white,
                  ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // معلومات النسخة
              _buildVersionCard(isDark),

              const SizedBox(height: 20),

              // حالة المزامنة
              _buildSyncStatusCard(isDark),

              const SizedBox(height: 20),

              // التحديثات المتاحة
              if (_availableUpdate != null) ...[
                _buildUpdateAvailableCard(isDark),
                const SizedBox(height: 20),
              ],

              // إعدادات المزامنة التلقائية
              _buildAutoSyncSettings(isDark),

              const SizedBox(height: 20),

              // أزرار الإجراءات
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionCard(bool isDark) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              size: 50,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(height: 16),
            Text(
              'النسخة الحالية',
              style: AppTextStyles.heading3(isDark: isDark),
            ),
            const SizedBox(height: 8),
            Text(
              _currentVersion,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGold,
              ),
            ),
            if (_lastSyncDate != null) ...[
              const SizedBox(height: 12),
              Text(
                'آخر تحديث: ${_formatDate(_lastSyncDate!)}',
                style: AppTextStyles.caption(isDark: isDark),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatusCard(bool isDark) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getSyncStatusColor().withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Text(
                _syncStatus.icon,
                style: const TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'حالة المزامنة',
                    style: AppTextStyles.caption(isDark: isDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _syncStatus.displayName,
                    style: AppTextStyles.heading3(isDark: isDark).copyWith(
                      fontSize: 16,
                      color: _getSyncStatusColor(),
                    ),
                  ),
                ],
              ),
            ),
            if (_syncStatus == SyncStatus.checking ||
                _syncStatus == SyncStatus.downloading ||
                _syncStatus == SyncStatus.installing)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateAvailableCard(bool isDark) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppColors.primaryGold.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.system_update,
                  size: 40,
                  color: AppColors.primaryGold,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تحديث جديد متاح!',
                        style: AppTextStyles.heading3(isDark: isDark).copyWith(
                          fontSize: 18,
                          color: AppColors.primaryGold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'الإصدار ${_availableUpdate!.version}',
                        style: AppTextStyles.caption(isDark: isDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ملخص التحديثات
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _availableUpdate!.summary,
                    style: AppTextStyles.bodyText(isDark: false).copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  if (_availableUpdate!.description != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _availableUpdate!.description!,
                      style: AppTextStyles.bodyText(isDark: false).copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                  if (_availableUpdate!.newFeatures.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'المميزات الجديدة:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._availableUpdate!.newFeatures.map((feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primaryGold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // زر التحديث
            ElevatedButton.icon(
              onPressed: _syncStatus == SyncStatus.idle ? _installUpdate : null,
              icon: const Icon(Icons.download),
              label: const Text('تحميل وتثبيت التحديث'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoSyncSettings(bool isDark) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sync,
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'إعدادات المزامنة التلقائية',
                  style: AppTextStyles.heading3(isDark: isDark).copyWith(
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // تفعيل المزامنة التلقائية
            SwitchListTile(
              value: _autoSync,
              onChanged: _toggleAutoSync,
              title: const Text('مزامنة تلقائية'),
              subtitle: const Text('تحديث المحتوى بشكل تلقائي'),
              activeColor: AppColors.primaryGreen,
            ),

            if (_autoSync) ...[
              const SizedBox(height: 12),

              // تكرار المزامنة
              DropdownButtonFormField<SyncFrequency>(
                value: _syncFrequency,
                decoration: InputDecoration(
                  labelText: 'تكرار المزامنة',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(
                    Icons.schedule,
                    color: AppColors.primaryGreen,
                  ),
                ),
                items: SyncFrequency.values
                    .where((f) => f != SyncFrequency.manual)
                    .map((frequency) {
                  return DropdownMenuItem(
                    value: frequency,
                    child: Text(frequency.displayName),
                  );
                }).toList(),
                onChanged: _changeSyncFrequency,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final canCheck = _syncStatus == SyncStatus.idle ||
        _syncStatus == SyncStatus.completed ||
        _syncStatus == SyncStatus.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: canCheck ? _checkForUpdates : null,
          icon: const Icon(Icons.refresh),
          label: const Text('التحقق من التحديثات'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // معلومات إضافية
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryGreen.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ملاحظة',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'المزامنة تتطلب اتصال بالإنترنت. سيتم تحديث المحتوى المحلي بآيات وأدعية جديدة من السيرفر.',
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 8),
              const Text(
                'لن يتم حذف أي محتوى موجود، فقط إضافة محتوى جديد.',
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getSyncStatusColor() {
    switch (_syncStatus) {
      case SyncStatus.idle:
        return Colors.grey;
      case SyncStatus.checking:
      case SyncStatus.downloading:
      case SyncStatus.installing:
        return Colors.blue;
      case SyncStatus.completed:
        return AppColors.primaryGreen;
      case SyncStatus.error:
        return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
