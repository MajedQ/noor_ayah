/// نموذج الإنجاز
class Achievement {
  final String id;
  final String title;
  final String titleEnglish;
  final String description;
  final String descriptionEnglish;
  final String icon;
  final int requiredCount;
  final AchievementType type;
  final int tier; // المستوى: 1 = برونزي, 2 = فضي, 3 = ذهبي
  bool isUnlocked;
  int currentProgress;
  DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.titleEnglish,
    required this.description,
    required this.descriptionEnglish,
    required this.icon,
    required this.requiredCount,
    required this.type,
    this.tier = 1,
    this.isUnlocked = false,
    this.currentProgress = 0,
    this.unlockedAt,
  });

  /// تحويل من JSON
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      titleEnglish: json['titleEnglish'] as String,
      description: json['description'] as String,
      descriptionEnglish: json['descriptionEnglish'] as String,
      icon: json['icon'] as String,
      requiredCount: json['requiredCount'] as int,
      type: AchievementType.values[json['type'] as int],
      tier: json['tier'] as int? ?? 1,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      currentProgress: json['currentProgress'] as int? ?? 0,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'titleEnglish': titleEnglish,
      'description': description,
      'descriptionEnglish': descriptionEnglish,
      'icon': icon,
      'requiredCount': requiredCount,
      'type': type.index,
      'tier': tier,
      'isUnlocked': isUnlocked,
      'currentProgress': currentProgress,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  /// نسبة التقدم (0-100)
  double get progressPercentage {
    if (requiredCount == 0) return 100.0;
    return (currentProgress / requiredCount * 100).clamp(0, 100);
  }

  /// هل تم إكمال الإنجاز
  bool get isCompleted => currentProgress >= requiredCount;

  /// لون الـ Tier
  String get tierColor {
    switch (tier) {
      case 1:
        return '#CD7F32'; // برونزي
      case 2:
        return '#C0C0C0'; // فضي
      case 3:
        return '#FFD700'; // ذهبي
      case 4:
        return '#E5E4E2'; // بلاتيني
      case 5:
        return '#B9F2FF'; // ماسي
      case 6:
        return '#50C878'; // زمردي
      case 7:
        return '#FF6347'; // أسطوري
      default:
        return '#CD7F32';
    }
  }

  /// اسم الـ Tier
  String get tierName {
    switch (tier) {
      case 1:
        return 'برونزي';
      case 2:
        return 'فضي';
      case 3:
        return 'ذهبي';
      case 4:
        return 'بلاتيني';
      case 5:
        return 'ماسي';
      case 6:
        return 'زمردي';
      case 7:
        return 'أسطوري';
      default:
        return 'برونزي';
    }
  }

  /// أيقونة الـ Tier
  String get tierIcon {
    switch (tier) {
      case 1:
        return '🥉'; // برونزي
      case 2:
        return '🥈'; // فضي
      case 3:
        return '🥇'; // ذهبي
      case 4:
        return '💿'; // بلاتيني
      case 5:
        return '💎'; // ماسي
      case 6:
        return '💚'; // زمردي
      case 7:
        return '🏆'; // أسطوري
      default:
        return '🥉';
    }
  }

  /// نقاط الإنجاز
  int get points {
    switch (tier) {
      case 1:
        return 10; // برونزي
      case 2:
        return 25; // فضي
      case 3:
        return 50; // ذهبي
      case 4:
        return 100; // بلاتيني
      case 5:
        return 200; // ماسي
      case 6:
        return 365; // زمردي
      case 7:
        return 500; // أسطوري
      default:
        return 10;
    }
  }

  /// نسخة محدثة من الإنجاز
  Achievement copyWith({
    String? id,
    String? title,
    String? titleEnglish,
    String? description,
    String? descriptionEnglish,
    String? icon,
    int? requiredCount,
    AchievementType? type,
    int? tier,
    bool? isUnlocked,
    int? currentProgress,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      titleEnglish: titleEnglish ?? this.titleEnglish,
      description: description ?? this.description,
      descriptionEnglish: descriptionEnglish ?? this.descriptionEnglish,
      icon: icon ?? this.icon,
      requiredCount: requiredCount ?? this.requiredCount,
      type: type ?? this.type,
      tier: tier ?? this.tier,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      currentProgress: currentProgress ?? this.currentProgress,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

/// أنواع الإنجازات
enum AchievementType {
  dailyReading, // القراءة اليومية
  favorites, // المفضلة
  sharing, // المشاركة
  streak, // الأيام المتتالية
  categories, // استكشاف الفئات
  totalReading, // إجمالي القراءة
  duas, // قراءة الأدعية
  wird, // الورد اليومي
  audio, // الاستماع للتلاوة
}

extension AchievementTypeExtension on AchievementType {
  String get displayName {
    switch (this) {
      case AchievementType.dailyReading:
        return 'قراءة يومية';
      case AchievementType.favorites:
        return 'المفضلة';
      case AchievementType.sharing:
        return 'المشاركة';
      case AchievementType.streak:
        return 'التواصل';
      case AchievementType.categories:
        return 'الاستكشاف';
      case AchievementType.totalReading:
        return 'القراءة الكلية';
      case AchievementType.duas:
        return 'الأدعية';
      case AchievementType.wird:
        return 'الورد اليومي';
      case AchievementType.audio:
        return 'الاستماع';
    }
  }
}
