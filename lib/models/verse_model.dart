class VerseModel {
  final int id;
  final String surah;
  final int? surahNumber;
  final int? verseNumber;
  final String verseText;
  final String reflection;
  final String dua;
  final List<String> categories;
  final String? audioUrl;
  final DateTime? scheduledDate;

  VerseModel({
    required this.id,
    required this.surah,
    this.surahNumber,
    this.verseNumber,
    required this.verseText,
    required this.reflection,
    required this.dua,
    required this.categories,
    this.audioUrl,
    this.scheduledDate,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      id: json['id'] as int,
      surah: json['surah'] as String,
      surahNumber: json['surahNumber'] as int?,
      verseNumber: json['verseNumber'] as int?,
      verseText: json['verseText'] as String,
      reflection: json['reflection'] as String,
      dua: json['dua'] as String,
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : [json['category'] ?? 'عام'],
      audioUrl: json['audioUrl'] as String?,
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surah': surah,
      'surahNumber': surahNumber,
      'verseNumber': verseNumber,
      'verseText': verseText,
      'reflection': reflection,
      'dua': dua,
      'categories': categories,
      'audioUrl': audioUrl,
      'scheduledDate': scheduledDate?.toIso8601String(),
    };
  }

  VerseModel copyWith({
    int? id,
    String? surah,
    int? surahNumber,
    int? verseNumber,
    String? verseText,
    String? reflection,
    String? dua,
    List<String>? categories,
    String? audioUrl,
    DateTime? scheduledDate,
  }) {
    return VerseModel(
      id: id ?? this.id,
      surah: surah ?? this.surah,
      surahNumber: surahNumber ?? this.surahNumber,
      verseNumber: verseNumber ?? this.verseNumber,
      verseText: verseText ?? this.verseText,
      reflection: reflection ?? this.reflection,
      dua: dua ?? this.dua,
      categories: categories ?? this.categories,
      audioUrl: audioUrl ?? this.audioUrl,
      scheduledDate: scheduledDate ?? this.scheduledDate,
    );
  }

  String get mainCategory => categories.isNotEmpty ? categories.first : 'عام';

  String getFormattedText() {
    return '$verseText\n\n💭 التدبر:\n$reflection\n\n🤲 الدعاء:\n$dua\n\n📖 $surah';
  }
}
