/// نموذج التحديثات المتاحة
class ContentUpdate {
  final String version;
  final DateTime updateDate;
  final int newVersesCount;
  final int newDuasCount;
  final int updatedVersesCount;
  final int updatedDuasCount;
  final String? description;
  final List<String> newFeatures;
  final bool isRequired;

  ContentUpdate({
    required this.version,
    required this.updateDate,
    this.newVersesCount = 0,
    this.newDuasCount = 0,
    this.updatedVersesCount = 0,
    this.updatedDuasCount = 0,
    this.description,
    this.newFeatures = const [],
    this.isRequired = false,
  });

  factory ContentUpdate.fromJson(Map<String, dynamic> json) {
    return ContentUpdate(
      version: json['version'] as String,
      updateDate: DateTime.parse(json['updateDate'] as String),
      newVersesCount: json['newVersesCount'] as int? ?? 0,
      newDuasCount: json['newDuasCount'] as int? ?? 0,
      updatedVersesCount: json['updatedVersesCount'] as int? ?? 0,
      updatedDuasCount: json['updatedDuasCount'] as int? ?? 0,
      description: json['description'] as String?,
      newFeatures: json['newFeatures'] != null
          ? List<String>.from(json['newFeatures'])
          : [],
      isRequired: json['isRequired'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'updateDate': updateDate.toIso8601String(),
      'newVersesCount': newVersesCount,
      'newDuasCount': newDuasCount,
      'updatedVersesCount': updatedVersesCount,
      'updatedDuasCount': updatedDuasCount,
      'description': description,
      'newFeatures': newFeatures,
      'isRequired': isRequired,
    };
  }

  /// مجموع التحديثات
  int get totalUpdates =>
      newVersesCount + newDuasCount + updatedVersesCount + updatedDuasCount;

  /// هل هناك تحديثات متاحة
  bool get hasUpdates => totalUpdates > 0;

  /// نص ملخص التحديثات
  String get summary {
    final parts = <String>[];

    if (newVersesCount > 0) {
      parts.add(
          '$newVersesCount ${newVersesCount == 1 ? "آية جديدة" : "آيات جديدة"}');
    }
    if (newDuasCount > 0) {
      parts.add(
          '$newDuasCount ${newDuasCount == 1 ? "دعاء جديد" : "أدعية جديدة"}');
    }
    if (updatedVersesCount > 0) {
      parts.add(
          '$updatedVersesCount ${updatedVersesCount == 1 ? "آية محدثة" : "آيات محدثة"}');
    }
    if (updatedDuasCount > 0) {
      parts.add(
          '$updatedDuasCount ${updatedDuasCount == 1 ? "دعاء محدث" : "أدعية محدثة"}');
    }

    return parts.isEmpty ? 'لا توجد تحديثات' : parts.join('، ');
  }
}

/// إعدادات المزامنة التلقائية
enum SyncFrequency {
  manual, // يدوي
  daily, // يومي
  weekly, // أسبوعي
  monthly, // شهري
}

extension SyncFrequencyExtension on SyncFrequency {
  String get displayName {
    switch (this) {
      case SyncFrequency.manual:
        return 'يدوي';
      case SyncFrequency.daily:
        return 'يومي';
      case SyncFrequency.weekly:
        return 'أسبوعي';
      case SyncFrequency.monthly:
        return 'شهري';
    }
  }

  Duration get duration {
    switch (this) {
      case SyncFrequency.manual:
        return Duration.zero;
      case SyncFrequency.daily:
        return const Duration(days: 1);
      case SyncFrequency.weekly:
        return const Duration(days: 7);
      case SyncFrequency.monthly:
        return const Duration(days: 30);
    }
  }
}

/// حالة المزامنة
enum SyncStatus {
  idle, // خامل
  checking, // يتحقق من التحديثات
  downloading, // يحمل
  installing, // يثبت
  completed, // مكتمل
  error, // خطأ
}

extension SyncStatusExtension on SyncStatus {
  String get displayName {
    switch (this) {
      case SyncStatus.idle:
        return 'جاهز';
      case SyncStatus.checking:
        return 'يتحقق من التحديثات...';
      case SyncStatus.downloading:
        return 'يحمل المحتوى الجديد...';
      case SyncStatus.installing:
        return 'يثبت التحديثات...';
      case SyncStatus.completed:
        return 'تم التحديث بنجاح';
      case SyncStatus.error:
        return 'حدث خطأ';
    }
  }

  String get icon {
    switch (this) {
      case SyncStatus.idle:
        return '⏸️';
      case SyncStatus.checking:
        return '🔍';
      case SyncStatus.downloading:
        return '⬇️';
      case SyncStatus.installing:
        return '⚙️';
      case SyncStatus.completed:
        return '✅';
      case SyncStatus.error:
        return '❌';
    }
  }
}
