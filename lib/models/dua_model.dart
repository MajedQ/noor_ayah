/// نموذج الدعاء
class DuaModel {
  final int id;
  final String title;
  final String duaText;
  final String source;
  final DuaCategory category;
  final DuaOccasion occasion;
  final String? benefits;
  final String? transliteration;
  final DateTime? scheduledDate;

  DuaModel({
    required this.id,
    required this.title,
    required this.duaText,
    required this.source,
    required this.category,
    required this.occasion,
    this.benefits,
    this.transliteration,
    this.scheduledDate,
  });

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      id: json['id'] as int,
      title: json['title'] as String,
      duaText: json['duaText'] as String,
      source: json['source'] as String,
      category: DuaCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
        orElse: () => DuaCategory.general,
      ),
      occasion: DuaOccasion.values.firstWhere(
        (e) => e.toString().split('.').last == json['occasion'],
        orElse: () => DuaOccasion.general,
      ),
      benefits: json['benefits'] as String?,
      transliteration: json['transliteration'] as String?,
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duaText': duaText,
      'source': source,
      'category': category.toString().split('.').last,
      'occasion': occasion.toString().split('.').last,
      'benefits': benefits,
      'transliteration': transliteration,
      'scheduledDate': scheduledDate?.toIso8601String(),
    };
  }

  DuaModel copyWith({
    int? id,
    String? title,
    String? duaText,
    String? source,
    DuaCategory? category,
    DuaOccasion? occasion,
    String? benefits,
    String? transliteration,
    DateTime? scheduledDate,
  }) {
    return DuaModel(
      id: id ?? this.id,
      title: title ?? this.title,
      duaText: duaText ?? this.duaText,
      source: source ?? this.source,
      category: category ?? this.category,
      occasion: occasion ?? this.occasion,
      benefits: benefits ?? this.benefits,
      transliteration: transliteration ?? this.transliteration,
      scheduledDate: scheduledDate ?? this.scheduledDate,
    );
  }

  String getFormattedText() {
    final buffer = StringBuffer();
    buffer.write('$title\n\n');
    buffer.write('$duaText\n\n');
    if (transliteration != null && transliteration!.isNotEmpty) {
      buffer.write('النطق: $transliteration\n\n');
    }
    if (benefits != null && benefits!.isNotEmpty) {
      buffer.write('💡 الفائدة:\n$benefits\n\n');
    }
    buffer.write('📖 المصدر: $source');
    return buffer.toString();
  }
}

/// فئات الأدعية
enum DuaCategory {
  morning, // صباح
  evening, // مساء
  general, // عامة
  sleeping, // النوم
  waking, // الاستيقاظ
  eating, // الطعام
  travel, // السفر
  rain, // المطر
  distress, // الكرب
  forgiveness, // الاستغفار
}

/// مناسبات الأدعية
enum DuaOccasion {
  general, // عامة
  ramadan, // رمضان
  friday, // الجمعة
  eidFitr, // عيد الفطر
  eidAdha, // عيد الأضحى
  whiteDays, // الأيام البيض
  dhuAlHijja, // عشر ذي الحجة
  arafah, // عرفة
  laylatAlQadr, // ليلة القدر
}

extension DuaCategoryExtension on DuaCategory {
  String get displayName {
    switch (this) {
      case DuaCategory.morning:
        return 'أذكار الصباح';
      case DuaCategory.evening:
        return 'أذكار المساء';
      case DuaCategory.general:
        return 'أدعية عامة';
      case DuaCategory.sleeping:
        return 'أذكار النوم';
      case DuaCategory.waking:
        return 'أذكار الاستيقاظ';
      case DuaCategory.eating:
        return 'أذكار الطعام';
      case DuaCategory.travel:
        return 'أذكار السفر';
      case DuaCategory.rain:
        return 'أذكار المطر';
      case DuaCategory.distress:
        return 'أدعية الكرب';
      case DuaCategory.forgiveness:
        return 'أدعية الاستغفار';
    }
  }

  String get icon {
    switch (this) {
      case DuaCategory.morning:
        return '🌅';
      case DuaCategory.evening:
        return '🌙';
      case DuaCategory.general:
        return '🤲';
      case DuaCategory.sleeping:
        return '😴';
      case DuaCategory.waking:
        return '☀️';
      case DuaCategory.eating:
        return '🍽️';
      case DuaCategory.travel:
        return '✈️';
      case DuaCategory.rain:
        return '🌧️';
      case DuaCategory.distress:
        return '💔';
      case DuaCategory.forgiveness:
        return '🙏';
    }
  }
}

extension DuaOccasionExtension on DuaOccasion {
  String get displayName {
    switch (this) {
      case DuaOccasion.general:
        return 'عامة';
      case DuaOccasion.ramadan:
        return 'رمضان';
      case DuaOccasion.friday:
        return 'الجمعة';
      case DuaOccasion.eidFitr:
        return 'عيد الفطر';
      case DuaOccasion.eidAdha:
        return 'عيد الأضحى';
      case DuaOccasion.whiteDays:
        return 'الأيام البيض';
      case DuaOccasion.dhuAlHijja:
        return 'عشر ذي الحجة';
      case DuaOccasion.arafah:
        return 'عرفة';
      case DuaOccasion.laylatAlQadr:
        return 'ليلة القدر';
    }
  }

  String get icon {
    switch (this) {
      case DuaOccasion.general:
        return '📿';
      case DuaOccasion.ramadan:
        return '🌙';
      case DuaOccasion.friday:
        return '🕌';
      case DuaOccasion.eidFitr:
        return '🎉';
      case DuaOccasion.eidAdha:
        return '🐑';
      case DuaOccasion.whiteDays:
        return '⭐';
      case DuaOccasion.dhuAlHijja:
        return '🕋';
      case DuaOccasion.arafah:
        return '⛰️';
      case DuaOccasion.laylatAlQadr:
        return '✨';
    }
  }

  /// التحقق من المناسبة الحالية
  bool get isCurrentOccasion {
    final now = DateTime.now();

    switch (this) {
      case DuaOccasion.friday:
        return now.weekday == DateTime.friday;

      case DuaOccasion.whiteDays:
        // الأيام البيض: 13، 14، 15 من كل شهر هجري
        // هنا يمكن استخدام مكتبة hijri للتحقق
        return false; // TODO: التكامل مع التقويم الهجري

      case DuaOccasion.ramadan:
      case DuaOccasion.eidFitr:
      case DuaOccasion.eidAdha:
      case DuaOccasion.dhuAlHijja:
      case DuaOccasion.arafah:
      case DuaOccasion.laylatAlQadr:
        // TODO: التكامل مع التقويم الهجري
        return false;

      case DuaOccasion.general:
        return true;
    }
  }

  /// أولوية المناسبة (أعلى رقم = أعلى أولوية)
  int get priority {
    switch (this) {
      case DuaOccasion.laylatAlQadr:
        return 9;
      case DuaOccasion.arafah:
        return 8;
      case DuaOccasion.ramadan:
        return 7;
      case DuaOccasion.eidFitr:
      case DuaOccasion.eidAdha:
        return 6;
      case DuaOccasion.dhuAlHijja:
        return 5;
      case DuaOccasion.whiteDays:
        return 4;
      case DuaOccasion.friday:
        return 3;
      case DuaOccasion.general:
        return 1;
    }
  }
}
