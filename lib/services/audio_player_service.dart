import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// أسماء القراء المتاحين
enum Reciter {
  minshawi, // المنشاوي
  husary, // الحصري
  afasy, // العفاسي
  abdulBaset, // عبد الباسط
}

extension ReciterExtension on Reciter {
  String get displayName {
    switch (this) {
      case Reciter.minshawi:
        return 'محمد صديق المنشاوي';
      case Reciter.husary:
        return 'محمود خليل الحصري';
      case Reciter.afasy:
        return 'مشاري راشد العفاسي';
      case Reciter.abdulBaset:
        return 'عبد الباسط عبد الصمد';
    }
  }

  String get displayNameEnglish {
    switch (this) {
      case Reciter.minshawi:
        return 'Mohamed Siddiq Al-Minshawi';
      case Reciter.husary:
        return 'Mahmoud Khalil Al-Husary';
      case Reciter.afasy:
        return 'Mishary Rashid Alafasy';
      case Reciter.abdulBaset:
        return 'Abdul Basit Abdus Samad';
    }
  }

  /// معرف القارئ في الAPI
  String get apiId {
    switch (this) {
      case Reciter.minshawi:
        return 'minshawi';
      case Reciter.husary:
        return 'husary';
      case Reciter.afasy:
        return 'afasy';
      case Reciter.abdulBaset:
        return 'abdulbasit';
    }
  }

  /// رابط الصوت من everyayah.com
  String getAudioUrl(int surahNumber, int verseNumber) {
    final formattedSurah = surahNumber.toString().padLeft(3, '0');
    final formattedVerse = verseNumber.toString().padLeft(3, '0');

    switch (this) {
      case Reciter.minshawi:
        return 'https://everyayah.com/data/Minshawy_Murattal_128kbps/$formattedSurah$formattedVerse.mp3';
      case Reciter.husary:
        return 'https://everyayah.com/data/Husary_128kbps/$formattedSurah$formattedVerse.mp3';
      case Reciter.afasy:
        return 'https://everyayah.com/data/Alafasy_128kbps/$formattedSurah$formattedVerse.mp3';
      case Reciter.abdulBaset:
        return 'https://everyayah.com/data/Abdul_Basit_Murattal_192kbps/$formattedSurah$formattedVerse.mp3';
    }
  }
}

/// خدمة تشغيل الصوت للآيات القرآنية
class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  Reciter _currentReciter = Reciter.minshawi;
  bool _isInitialized = false;

  AudioPlayer get player => _audioPlayer;
  Reciter get currentReciter => _currentReciter;
  bool get isInitialized => _isInitialized;

  /// تهيئة الخدمة
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      debugPrint('🔄 بدء تهيئة خدمة الصوت...');

      // إعدادات المشغل
      await _audioPlayer.setVolume(1.0);

      // اختبار الاتصال بالإنترنت
      debugPrint('🌐 اختبار الاتصال بالإنترنت...');

      _isInitialized = true;
      debugPrint('✅ تم تهيئة خدمة الصوت بنجاح');
    } catch (e) {
      debugPrint('❌ خطأ في تهيئة خدمة الصوت: $e');
      debugPrint('❌ تفاصيل الخطأ: ${e.toString()}');
      _isInitialized = false;
    }
  }

  /// تعيين القارئ
  void setReciter(Reciter reciter) {
    _currentReciter = reciter;
    debugPrint('🎙️ تم تعيين القارئ: ${reciter.displayName}');
  }

  /// تشغيل آية
  Future<void> playVerse(int surahNumber, int verseNumber) async {
    try {
      final url = _currentReciter.getAudioUrl(surahNumber, verseNumber);
      debugPrint('▶️ تشغيل الآية: $surahNumber:$verseNumber من $url');

      // إيقاف أي تشغيل سابق
      await _audioPlayer.stop();

      // تعيين الرابط الجديد
      await _audioPlayer.setUrl(url);

      // تشغيل الصوت
      await _audioPlayer.play();

      debugPrint('✅ بدأ تشغيل الصوت بنجاح');
    } catch (e) {
      debugPrint('❌ خطأ في تشغيل الآية: $e');
      debugPrint('❌ تفاصيل الخطأ: ${e.toString()}');
      rethrow;
    }
  }

  /// إيقاف التشغيل
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  /// استئناف التشغيل
  Future<void> resume() async {
    await _audioPlayer.play();
  }

  /// إيقاف نهائي
  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  /// تبديل التشغيل/الإيقاف
  Future<void> togglePlayPause() async {
    if (_audioPlayer.playing) {
      await pause();
    } else {
      await resume();
    }
  }

  /// حالة التشغيل
  bool get isPlaying => _audioPlayer.playing;

  /// Stream لحالة التشغيل
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  /// Stream للموضع الحالي
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  /// Stream للمدة الكاملة
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  /// تغيير الموضع
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  /// تغيير الصوت
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  /// تنظيف الموارد
  Future<void> dispose() async {
    await _audioPlayer.dispose();
    _isInitialized = false;
    debugPrint('🗑️ تم تنظيف خدمة الصوت');
  }

  /// إعادة تعيين
  Future<void> reset() async {
    await _audioPlayer.stop();
    await _audioPlayer.seek(Duration.zero);
  }

  /// الحصول على الموضع الحالي
  Duration get currentPosition => _audioPlayer.position;

  /// الحصول على المدة الكاملة
  Duration? get duration => _audioPlayer.duration;

  /// نسبة التقدم (0.0 - 1.0)
  double get progress {
    final dur = duration;
    if (dur == null || dur.inMilliseconds == 0) return 0.0;
    return currentPosition.inMilliseconds / dur.inMilliseconds;
  }
}
