/// نوع عنصر الورد
enum WirdItemType {
  verse, // آية
  dua, // دعاء
}

/// عنصر في الورد اليومي
class WirdItem {
  final String id;
  final WirdItemType type;
  final int contentId; // ID الآية أو الدعاء
  final String title;
  final String content;
  bool isCompleted;
  DateTime? completedAt;

  WirdItem({
    required this.id,
    required this.type,
    required this.contentId,
    required this.title,
    required this.content,
    this.isCompleted = false,
    this.completedAt,
  });

  factory WirdItem.fromJson(Map<String, dynamic> json) {
    return WirdItem(
      id: json['id'] as String,
      type: WirdItemType.values[json['type'] as int],
      contentId: json['contentId'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'contentId': contentId,
      'title': title,
      'content': content,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  WirdItem copyWith({
    String? id,
    WirdItemType? type,
    int? contentId,
    String? title,
    String? content,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return WirdItem(
      id: id ?? this.id,
      type: type ?? this.type,
      contentId: contentId ?? this.contentId,
      title: title ?? this.title,
      content: content ?? this.content,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

/// نموذج الورد اليومي
class WirdModel {
  final String id;
  final String title;
  final List<WirdItem> items;
  final WirdSchedule schedule;
  final DateTime createdAt;
  DateTime? lastCompletedAt;
  int consecutiveDays;
  bool isActive;

  WirdModel({
    required this.id,
    required this.title,
    required this.items,
    required this.schedule,
    required this.createdAt,
    this.lastCompletedAt,
    this.consecutiveDays = 0,
    this.isActive = true,
  });

  factory WirdModel.fromJson(Map<String, dynamic> json) {
    return WirdModel(
      id: json['id'] as String,
      title: json['title'] as String,
      items: (json['items'] as List)
          .map((item) => WirdItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      schedule: WirdSchedule.values[json['schedule'] as int],
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastCompletedAt: json['lastCompletedAt'] != null
          ? DateTime.parse(json['lastCompletedAt'] as String)
          : null,
      consecutiveDays: json['consecutiveDays'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'items': items.map((item) => item.toJson()).toList(),
      'schedule': schedule.index,
      'createdAt': createdAt.toIso8601String(),
      'lastCompletedAt': lastCompletedAt?.toIso8601String(),
      'consecutiveDays': consecutiveDays,
      'isActive': isActive,
    };
  }

  /// عدد العناصر المكتملة
  int get completedCount => items.where((item) => item.isCompleted).length;

  /// نسبة الإنجاز (0.0 - 1.0)
  double get completionPercentage {
    if (items.isEmpty) return 0.0;
    return completedCount / items.length;
  }

  /// هل تم إكمال الورد اليوم
  bool get isCompletedToday {
    if (lastCompletedAt == null) return false;
    final now = DateTime.now();
    final lastCompleted = lastCompletedAt!;
    return now.year == lastCompleted.year &&
        now.month == lastCompleted.month &&
        now.day == lastCompleted.day;
  }

  /// هل يجب عرض الورد الآن حسب الجدول
  bool get shouldShowNow {
    final now = DateTime.now();
    final hour = now.hour;

    switch (schedule) {
      case WirdSchedule.morning:
        return hour >= 5 && hour < 12;
      case WirdSchedule.afternoon:
        return hour >= 12 && hour < 17;
      case WirdSchedule.evening:
        return hour >= 17 && hour < 21;
      case WirdSchedule.night:
        return hour >= 21 || hour < 5;
      case WirdSchedule.anytime:
        return true;
    }
  }

  WirdModel copyWith({
    String? id,
    String? title,
    List<WirdItem>? items,
    WirdSchedule? schedule,
    DateTime? createdAt,
    DateTime? lastCompletedAt,
    int? consecutiveDays,
    bool? isActive,
  }) {
    return WirdModel(
      id: id ?? this.id,
      title: title ?? this.title,
      items: items ?? this.items,
      schedule: schedule ?? this.schedule,
      createdAt: createdAt ?? this.createdAt,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// جدول الورد
enum WirdSchedule {
  morning, // صباح (5ص - 12ظ)
  afternoon, // ظهر (12ظ - 5م)
  evening, // مساء (5م - 9م)
  night, // ليل (9م - 5ص)
  anytime, // أي وقت
}

extension WirdScheduleExtension on WirdSchedule {
  String get displayName {
    switch (this) {
      case WirdSchedule.morning:
        return 'الصباح';
      case WirdSchedule.afternoon:
        return 'الظهر';
      case WirdSchedule.evening:
        return 'المساء';
      case WirdSchedule.night:
        return 'الليل';
      case WirdSchedule.anytime:
        return 'أي وقت';
    }
  }

  String get icon {
    switch (this) {
      case WirdSchedule.morning:
        return '🌅';
      case WirdSchedule.afternoon:
        return '☀️';
      case WirdSchedule.evening:
        return '🌆';
      case WirdSchedule.night:
        return '🌙';
      case WirdSchedule.anytime:
        return '⏰';
    }
  }

  String get timeRange {
    switch (this) {
      case WirdSchedule.morning:
        return '5:00 ص - 12:00 ظ';
      case WirdSchedule.afternoon:
        return '12:00 ظ - 5:00 م';
      case WirdSchedule.evening:
        return '5:00 م - 9:00 م';
      case WirdSchedule.night:
        return '9:00 م - 5:00 ص';
      case WirdSchedule.anytime:
        return 'طوال اليوم';
    }
  }
}
