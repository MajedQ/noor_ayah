import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/audio_player_service.dart';

/// Provider لإدارة حالة مشغل الصوت
class AudioProvider extends ChangeNotifier {
  final AudioPlayerService _audioService = AudioPlayerService();
  static const String _reciterKey = 'selectedReciter';

  bool _isInitialized = false;
  int? _currentSurahNumber;
  int? _currentVerseNumber;
  bool _autoPlay = false;

  AudioPlayerService get audioService => _audioService;
  bool get isInitialized => _isInitialized;
  Reciter get currentReciter => _audioService.currentReciter;
  int? get currentSurahNumber => _currentSurahNumber;
  int? get currentVerseNumber => _currentVerseNumber;
  bool get autoPlay => _autoPlay;

  AudioProvider() {
    _init();
  }

  /// تهيئة الخدمة
  Future<void> _init() async {
    try {
      await _audioService.init();
      await _loadSavedReciter();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('خطأ في تهيئة AudioProvider: $e');
    }
  }

  /// تحميل القارئ المحفوظ
  Future<void> _loadSavedReciter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reciterIndex = prefs.getInt(_reciterKey);

      if (reciterIndex != null && reciterIndex < Reciter.values.length) {
        _audioService.setReciter(Reciter.values[reciterIndex]);
      }
    } catch (e) {
      debugPrint('خطأ في تحميل القارئ المحفوظ: $e');
    }
  }

  /// تعيين القارئ
  Future<void> setReciter(Reciter reciter) async {
    _audioService.setReciter(reciter);
    notifyListeners();

    // حفظ الاختيار
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_reciterKey, reciter.index);
    } catch (e) {
      debugPrint('خطأ في حفظ القارئ: $e');
    }
  }

  /// تشغيل آية
  Future<bool> playVerse(int surahNumber, int verseNumber) async {
    try {
      // التأكد من تهيئة الخدمة
      if (!_isInitialized) {
        await _init();
        if (!_isInitialized) {
          debugPrint('❌ فشل في تهيئة خدمة الصوت');
          return false;
        }
      }

      _currentSurahNumber = surahNumber;
      _currentVerseNumber = verseNumber;

      debugPrint('🎵 محاولة تشغيل الآية: $surahNumber:$verseNumber');
      await _audioService.playVerse(surahNumber, verseNumber);
      notifyListeners();
      debugPrint('✅ تم تشغيل الآية بنجاح');
      return true;
    } catch (e) {
      debugPrint('❌ خطأ في تشغيل الآية: $e');
      _currentSurahNumber = null;
      _currentVerseNumber = null;
      notifyListeners();
      return false;
    }
  }

  /// إيقاف/استئناف
  Future<void> togglePlayPause() async {
    await _audioService.togglePlayPause();
    notifyListeners();
  }

  /// إيقاف
  Future<void> stop() async {
    await _audioService.stop();
    _currentSurahNumber = null;
    _currentVerseNumber = null;
    notifyListeners();
  }

  /// إيقاف مؤقت
  Future<void> pause() async {
    await _audioService.pause();
    notifyListeners();
  }

  /// استئناف
  Future<void> resume() async {
    await _audioService.resume();
    notifyListeners();
  }

  /// تبديل التشغيل التلقائي
  void toggleAutoPlay() {
    _autoPlay = !_autoPlay;
    notifyListeners();
  }

  /// تعيين التشغيل التلقائي
  void setAutoPlay(bool value) {
    _autoPlay = value;
    notifyListeners();
  }

  /// هل يتم تشغيل آية محددة حالياً
  bool isPlayingVerse(int surahNumber, int verseNumber) {
    return _audioService.isPlaying &&
        _currentSurahNumber == surahNumber &&
        _currentVerseNumber == verseNumber;
  }

  /// Stream لحالة المشغل
  Stream get playerStateStream => _audioService.playerStateStream;

  /// Stream للموضع
  Stream<Duration> get positionStream => _audioService.positionStream;

  /// Stream للمدة
  Stream<Duration?> get durationStream => _audioService.durationStream;

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
