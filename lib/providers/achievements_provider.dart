import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/achievement_model.dart';
import '../models/points_system.dart';

/// Provider لإدارة الإنجازات
class AchievementsProvider extends ChangeNotifier {
  static const String _achievementsBoxName = 'achievements';
  static const String _statsBoxName = 'achievementStats';

  late Box<Map> _achievementsBox;
  late Box<dynamic> _statsBox;

  List<Achievement> _achievements = [];
  int _currentStreak = 0;
  int _totalReads = 0;
  int _totalFavorites = 0;
  int _totalShares = 0;
  int _categoriesExplored = 0;
  int _totalDuas = 0; // إجمالي الأدعية المقروءة
  int _totalWirdDays = 0; // إجمالي أيام الورد
  int _totalAudioMinutes = 0; // إجمالي دقائق الاستماع
  DateTime? _lastReadDate;

  List<Achievement> get achievements => _achievements;
  int get currentStreak => _currentStreak;
  int get totalReads => _totalReads;
  int get totalDuas => _totalDuas;
  int get totalWirdDays => _totalWirdDays;
  int get totalAudioMinutes => _totalAudioMinutes;
  List<Achievement> get unlockedAchievements =>
      _achievements.where((a) => a.isUnlocked).toList();
  int get totalAchievements => _achievements.length;
  int get unlockedCount => unlockedAchievements.length;
  double get completionPercentage =>
      totalAchievements > 0 ? (unlockedCount / totalAchievements * 100) : 0;

  /// حساب النقاط الكلية
  int get totalPoints {
    int points = 0;
    for (var achievement in unlockedAchievements) {
      points += achievement.points;
    }
    return points;
  }

  /// الرتبة الحالية
  UserRank get currentRank => PointsSystem.getRankFromPoints(totalPoints);

  /// نقاط الرتبة التالية
  int get nextRankPoints => PointsSystem.getNextRankPoints(currentRank);

  /// نسبة التقدم للرتبة التالية
  double get progressToNextRank =>
      PointsSystem.getProgressToNextRank(totalPoints, currentRank);

  /// تهيئة الإنجازات
  Future<void> init() async {
    try {
      _achievementsBox = await Hive.openBox<Map>(_achievementsBoxName);
      _statsBox = await Hive.openBox(_statsBoxName);

      _initializeAchievements();
      _loadStats();
      _loadAchievements();
    } catch (e) {
      debugPrint('Error initializing AchievementsProvider: $e');
    }
  }

  /// تهيئة قائمة الإنجازات
  void _initializeAchievements() {
    _achievements = [
      // إنجازات القراءة اليومية
      Achievement(
        id: 'first_read',
        title: 'البداية',
        titleEnglish: 'First Steps',
        description: 'اقرأ أول آية',
        descriptionEnglish: 'Read your first verse',
        icon: '📖',
        requiredCount: 1,
        type: AchievementType.dailyReading,
        tier: 1,
      ),
      Achievement(
        id: 'reader_7',
        title: 'القارئ المجتهد',
        titleEnglish: 'Devoted Reader',
        description: 'اقرأ 7 آيات',
        descriptionEnglish: 'Read 7 verses',
        icon: '📚',
        requiredCount: 7,
        type: AchievementType.totalReading,
        tier: 1,
      ),
      Achievement(
        id: 'reader_30',
        title: 'المتدبر',
        titleEnglish: 'The Contemplator',
        description: 'اقرأ 30 آية',
        descriptionEnglish: 'Read 30 verses',
        icon: '🌟',
        requiredCount: 30,
        type: AchievementType.totalReading,
        tier: 2,
      ),

      // إنجازات المفضلة
      Achievement(
        id: 'favorite_1',
        title: 'أول مفضلة',
        titleEnglish: 'First Favorite',
        description: 'أضف آية واحدة للمفضلة',
        descriptionEnglish: 'Add your first favorite verse',
        icon: '❤️',
        requiredCount: 1,
        type: AchievementType.favorites,
        tier: 1,
      ),
      Achievement(
        id: 'favorite_10',
        title: 'الجامع',
        titleEnglish: 'The Collector',
        description: 'أضف 10 آيات للمفضلة',
        descriptionEnglish: 'Add 10 verses to favorites',
        icon: '💝',
        requiredCount: 10,
        type: AchievementType.favorites,
        tier: 2,
      ),

      // إنجازات المشاركة
      Achievement(
        id: 'share_1',
        title: 'الناشر',
        titleEnglish: 'The Sharer',
        description: 'شارك آية واحدة',
        descriptionEnglish: 'Share your first verse',
        icon: '🔗',
        requiredCount: 1,
        type: AchievementType.sharing,
        tier: 1,
      ),
      Achievement(
        id: 'share_5',
        title: 'المشارك النشط',
        titleEnglish: 'Active Sharer',
        description: 'شارك 5 آيات',
        descriptionEnglish: 'Share 5 verses',
        icon: '📤',
        requiredCount: 5,
        type: AchievementType.sharing,
        tier: 2,
      ),

      // إنجازات التواصل (Streak)
      Achievement(
        id: 'streak_3',
        title: 'المواظب',
        titleEnglish: 'Consistent',
        description: 'اقرأ 3 أيام متتالية',
        descriptionEnglish: 'Read for 3 consecutive days',
        icon: '🔥',
        requiredCount: 3,
        type: AchievementType.streak,
        tier: 1,
      ),
      Achievement(
        id: 'streak_7',
        title: 'الملتزم',
        titleEnglish: 'Committed',
        description: 'اقرأ 7 أيام متتالية',
        descriptionEnglish: 'Read for 7 consecutive days',
        icon: '⭐',
        requiredCount: 7,
        type: AchievementType.streak,
        tier: 2,
      ),
      Achievement(
        id: 'streak_30',
        title: 'الثابت',
        titleEnglish: 'The Steadfast',
        description: 'اقرأ 30 يوماً متتالياً',
        descriptionEnglish: 'Read for 30 consecutive days',
        icon: '🏆',
        requiredCount: 30,
        type: AchievementType.streak,
        tier: 3,
      ),

      // إنجازات الفئات
      Achievement(
        id: 'explorer',
        title: 'المكتشف',
        titleEnglish: 'The Explorer',
        description: 'استكشف جميع الفئات',
        descriptionEnglish: 'Explore all categories',
        icon: '🧭',
        requiredCount: 12,
        type: AchievementType.categories,
        tier: 2,
      ),

      // ============ إنجازات جديدة موسعة ============

      // إنجازات القراءة الموسعة
      Achievement(
        id: 'reader_5',
        title: 'القارئ المبتدئ',
        titleEnglish: 'Beginner Reader',
        description: 'اقرأ 5 آيات',
        descriptionEnglish: 'Read 5 verses',
        icon: '📗',
        requiredCount: 5,
        type: AchievementType.totalReading,
        tier: 1,
      ),
      Achievement(
        id: 'reader_10',
        title: 'القارئ المجتهد',
        titleEnglish: 'Diligent Reader',
        description: 'اقرأ 10 آيات',
        descriptionEnglish: 'Read 10 verses',
        icon: '📘',
        requiredCount: 10,
        type: AchievementType.totalReading,
        tier: 1,
      ),
      Achievement(
        id: 'reader_50',
        title: 'الحافظ',
        titleEnglish: 'The Keeper',
        description: 'اقرأ 50 آية',
        descriptionEnglish: 'Read 50 verses',
        icon: '📕',
        requiredCount: 50,
        type: AchievementType.totalReading,
        tier: 3,
      ),
      Achievement(
        id: 'reader_100',
        title: 'العالم',
        titleEnglish: 'The Scholar',
        description: 'اقرأ 100 آية',
        descriptionEnglish: 'Read 100 verses',
        icon: '🎓',
        requiredCount: 100,
        type: AchievementType.totalReading,
        tier: 3,
      ),
      Achievement(
        id: 'reader_200',
        title: 'المفسر',
        titleEnglish: 'The Interpreter',
        description: 'اقرأ 200 آية',
        descriptionEnglish: 'Read 200 verses',
        icon: '📚',
        requiredCount: 200,
        type: AchievementType.totalReading,
        tier: 4,
      ),
      Achievement(
        id: 'reader_365',
        title: 'الأستاذ',
        titleEnglish: 'The Professor',
        description: 'اقرأ 365 آية',
        descriptionEnglish: 'Read 365 verses',
        icon: '⭐',
        requiredCount: 365,
        type: AchievementType.totalReading,
        tier: 5,
      ),
      Achievement(
        id: 'reader_500',
        title: 'المعلم',
        titleEnglish: 'The Teacher',
        description: 'اقرأ 500 آية',
        descriptionEnglish: 'Read 500 verses',
        icon: '🌟',
        requiredCount: 500,
        type: AchievementType.totalReading,
        tier: 6,
      ),
      Achievement(
        id: 'reader_700',
        title: 'الشيخ',
        titleEnglish: 'The Sheikh',
        description: 'اقرأ 700 آية',
        descriptionEnglish: 'Read 700 verses',
        icon: '👑',
        requiredCount: 700,
        type: AchievementType.totalReading,
        tier: 7,
      ),

      // إنجازات الـ Streak الموسعة
      Achievement(
        id: 'streak_14',
        title: 'المستمر',
        titleEnglish: 'The Continuous',
        description: 'اقرأ 14 يوماً متتالياً',
        descriptionEnglish: 'Read for 14 consecutive days',
        icon: '📅',
        requiredCount: 14,
        type: AchievementType.streak,
        tier: 2,
      ),
      Achievement(
        id: 'streak_60',
        title: 'الصابر',
        titleEnglish: 'The Patient',
        description: 'اقرأ 60 يوماً متتالياً',
        descriptionEnglish: 'Read for 60 consecutive days',
        icon: '💪',
        requiredCount: 60,
        type: AchievementType.streak,
        tier: 3,
      ),
      Achievement(
        id: 'streak_100',
        title: 'المتقن',
        titleEnglish: 'The Perfect',
        description: 'اقرأ 100 يوم متتالي',
        descriptionEnglish: 'Read for 100 consecutive days',
        icon: '🎯',
        requiredCount: 100,
        type: AchievementType.streak,
        tier: 4,
      ),
      Achievement(
        id: 'streak_180',
        title: 'الراسخ',
        titleEnglish: 'The Firm',
        description: 'اقرأ 180 يوماً متتالياً',
        descriptionEnglish: 'Read for 180 consecutive days',
        icon: '🗻',
        requiredCount: 180,
        type: AchievementType.streak,
        tier: 5,
      ),
      Achievement(
        id: 'streak_365',
        title: 'الخالد',
        titleEnglish: 'The Eternal',
        description: 'اقرأ 365 يوماً متتالياً',
        descriptionEnglish: 'Read for 365 consecutive days',
        icon: '♾️',
        requiredCount: 365,
        type: AchievementType.streak,
        tier: 7,
      ),

      // إنجازات المفضلة الموسعة
      Achievement(
        id: 'favorite_25',
        title: 'الخازن',
        titleEnglish: 'The Keeper',
        description: 'أضف 25 آية للمفضلة',
        descriptionEnglish: 'Add 25 verses to favorites',
        icon: '💖',
        requiredCount: 25,
        type: AchievementType.favorites,
        tier: 3,
      ),
      Achievement(
        id: 'favorite_50',
        title: 'الأمين',
        titleEnglish: 'The Trusted',
        description: 'أضف 50 آية للمفضلة',
        descriptionEnglish: 'Add 50 verses to favorites',
        icon: '💗',
        requiredCount: 50,
        type: AchievementType.favorites,
        tier: 4,
      ),
      Achievement(
        id: 'favorite_75',
        title: 'الحافظ',
        titleEnglish: 'The Guardian',
        description: 'أضف 75 آية للمفضلة',
        descriptionEnglish: 'Add 75 verses to favorites',
        icon: '💝',
        requiredCount: 75,
        type: AchievementType.favorites,
        tier: 5,
      ),
      Achievement(
        id: 'favorite_100',
        title: 'الكنز',
        titleEnglish: 'The Treasure',
        description: 'أضف 100 آية للمفضلة',
        descriptionEnglish: 'Add 100 verses to favorites',
        icon: '💰',
        requiredCount: 100,
        type: AchievementType.favorites,
        tier: 6,
      ),

      // إنجازات المشاركة الموسعة
      Achievement(
        id: 'share_10',
        title: 'الداعي',
        titleEnglish: 'The Caller',
        description: 'شارك 10 مرات',
        descriptionEnglish: 'Share 10 times',
        icon: '📢',
        requiredCount: 10,
        type: AchievementType.sharing,
        tier: 2,
      ),
      Achievement(
        id: 'share_25',
        title: 'الهادي',
        titleEnglish: 'The Guide',
        description: 'شارك 25 مرة',
        descriptionEnglish: 'Share 25 times',
        icon: '🌈',
        requiredCount: 25,
        type: AchievementType.sharing,
        tier: 3,
      ),
      Achievement(
        id: 'share_50',
        title: 'المرشد',
        titleEnglish: 'The Mentor',
        description: 'شارك 50 مرة',
        descriptionEnglish: 'Share 50 times',
        icon: '🧭',
        requiredCount: 50,
        type: AchievementType.sharing,
        tier: 4,
      ),
      Achievement(
        id: 'share_100',
        title: 'المبلغ',
        titleEnglish: 'The Messenger',
        description: 'شارك 100 مرة',
        descriptionEnglish: 'Share 100 times',
        icon: '📯',
        requiredCount: 100,
        type: AchievementType.sharing,
        tier: 5,
      ),
      Achievement(
        id: 'share_200',
        title: 'السفير',
        titleEnglish: 'The Ambassador',
        description: 'شارك 200 مرة',
        descriptionEnglish: 'Share 200 times',
        icon: '🎖️',
        requiredCount: 200,
        type: AchievementType.sharing,
        tier: 7,
      ),

      // ============ إنجازات دعاء اليوم (جديدة) ============
      Achievement(
        id: 'dua_1',
        title: 'أول دعاء',
        titleEnglish: 'First Dua',
        description: 'اقرأ أول دعاء',
        descriptionEnglish: 'Read your first dua',
        icon: '🤲',
        requiredCount: 1,
        type: AchievementType.duas,
        tier: 1,
      ),
      Achievement(
        id: 'dua_10',
        title: 'الداعي',
        titleEnglish: 'The Supplicant',
        description: 'اقرأ 10 أدعية',
        descriptionEnglish: 'Read 10 duas',
        icon: '🙏',
        requiredCount: 10,
        type: AchievementType.duas,
        tier: 1,
      ),
      Achievement(
        id: 'dua_30',
        title: 'المبتهل',
        titleEnglish: 'The Devoted',
        description: 'اقرأ 30 دعاء',
        descriptionEnglish: 'Read 30 duas',
        icon: '🕌',
        requiredCount: 30,
        type: AchievementType.duas,
        tier: 2,
      ),
      Achievement(
        id: 'dua_60',
        title: 'الخاشع',
        titleEnglish: 'The Humble',
        description: 'اقرأ 60 دعاء',
        descriptionEnglish: 'Read 60 duas',
        icon: '🌙',
        requiredCount: 60,
        type: AchievementType.duas,
        tier: 3,
      ),
      Achievement(
        id: 'dua_100',
        title: 'المتضرع',
        titleEnglish: 'The Beseecher',
        description: 'اقرأ 100 دعاء',
        descriptionEnglish: 'Read 100 duas',
        icon: '✨',
        requiredCount: 100,
        type: AchievementType.duas,
        tier: 4,
      ),
      Achievement(
        id: 'dua_200',
        title: 'الراجي',
        titleEnglish: 'The Hopeful',
        description: 'اقرأ 200 دعاء',
        descriptionEnglish: 'Read 200 duas',
        icon: '🌟',
        requiredCount: 200,
        type: AchievementType.duas,
        tier: 5,
      ),
      Achievement(
        id: 'dua_365',
        title: 'المناجي',
        titleEnglish: 'The Whisperer',
        description: 'اقرأ 365 دعاء',
        descriptionEnglish: 'Read 365 duas',
        icon: '💫',
        requiredCount: 365,
        type: AchievementType.duas,
        tier: 6,
      ),
      Achievement(
        id: 'dua_500',
        title: 'المستجاب له',
        titleEnglish: 'The Answered',
        description: 'اقرأ 500 دعاء',
        descriptionEnglish: 'Read 500 duas',
        icon: '🎊',
        requiredCount: 500,
        type: AchievementType.duas,
        tier: 7,
      ),

      // ============ إنجازات الورد اليومي (جديدة) ============
      Achievement(
        id: 'wird_3',
        title: 'بداية الورد',
        titleEnglish: 'Wird Beginning',
        description: 'أكمل الورد 3 أيام متتالية',
        descriptionEnglish: 'Complete wird for 3 days',
        icon: '📿',
        requiredCount: 3,
        type: AchievementType.wird,
        tier: 1,
      ),
      Achievement(
        id: 'wird_7',
        title: 'المحافظ على الورد',
        titleEnglish: 'Wird Keeper',
        description: 'أكمل الورد 7 أيام متتالية',
        descriptionEnglish: 'Complete wird for 7 days',
        icon: '📖',
        requiredCount: 7,
        type: AchievementType.wird,
        tier: 2,
      ),
      Achievement(
        id: 'wird_30',
        title: 'ورد الشهر',
        titleEnglish: 'Monthly Wird',
        description: 'أكمل الورد 30 يوماً',
        descriptionEnglish: 'Complete wird for 30 days',
        icon: '🌙',
        requiredCount: 30,
        type: AchievementType.wird,
        tier: 3,
      ),
      Achievement(
        id: 'wird_100',
        title: 'ورد الثبات',
        titleEnglish: 'Steadfast Wird',
        description: 'أكمل الورد 100 يوم',
        descriptionEnglish: 'Complete wird for 100 days',
        icon: '💪',
        requiredCount: 100,
        type: AchievementType.wird,
        tier: 4,
      ),
      Achievement(
        id: 'wird_365',
        title: 'الورد الذهبي',
        titleEnglish: 'Golden Wird',
        description: 'أكمل الورد 365 يوماً',
        descriptionEnglish: 'Complete wird for 365 days',
        icon: '🏅',
        requiredCount: 365,
        type: AchievementType.wird,
        tier: 7,
      ),

      // ============ إنجازات الاستماع للتلاوة (جديدة) ============
      Achievement(
        id: 'audio_1',
        title: 'المستمع الأول',
        titleEnglish: 'First Listener',
        description: 'استمع لآية واحدة',
        descriptionEnglish: 'Listen to first verse',
        icon: '🎧',
        requiredCount: 1,
        type: AchievementType.audio,
        tier: 1,
      ),
      Achievement(
        id: 'audio_10',
        title: 'المستمع النشط',
        titleEnglish: 'Active Listener',
        description: 'استمع لـ 10 آيات',
        descriptionEnglish: 'Listen to 10 verses',
        icon: '🎵',
        requiredCount: 10,
        type: AchievementType.audio,
        tier: 2,
      ),
      Achievement(
        id: 'audio_60',
        title: 'محب التلاوة',
        titleEnglish: 'Recitation Lover',
        description: 'استمع لـ 60 دقيقة',
        descriptionEnglish: 'Listen for 60 minutes',
        icon: '🎼',
        requiredCount: 60,
        type: AchievementType.audio,
        tier: 3,
      ),
    ];
  }

  /// تحميل الإحصائيات
  void _loadStats() {
    _currentStreak = _statsBox.get('currentStreak', defaultValue: 0);
    _totalReads = _statsBox.get('totalReads', defaultValue: 0);
    _totalFavorites = _statsBox.get('totalFavorites', defaultValue: 0);
    _totalShares = _statsBox.get('totalShares', defaultValue: 0);
    _categoriesExplored = _statsBox.get('categoriesExplored', defaultValue: 0);
    _totalDuas = _statsBox.get('totalDuas', defaultValue: 0);
    _totalWirdDays = _statsBox.get('totalWirdDays', defaultValue: 0);
    _totalAudioMinutes = _statsBox.get('totalAudioMinutes', defaultValue: 0);

    final lastReadStr = _statsBox.get('lastReadDate');
    if (lastReadStr != null) {
      _lastReadDate = DateTime.parse(lastReadStr);
    }
  }

  /// تحميل الإنجازات المحفوظة
  void _loadAchievements() {
    for (var achievement in _achievements) {
      final savedData = _achievementsBox.get(achievement.id);
      if (savedData != null) {
        final map = Map<String, dynamic>.from(savedData);
        achievement.isUnlocked = map['isUnlocked'] ?? false;
        achievement.currentProgress = map['currentProgress'] ?? 0;
        if (map['unlockedAt'] != null) {
          achievement.unlockedAt = DateTime.parse(map['unlockedAt']);
        }
      }
    }
    notifyListeners();
  }

  /// حفظ إنجاز
  Future<void> _saveAchievement(Achievement achievement) async {
    await _achievementsBox.put(achievement.id, achievement.toJson());
  }

  /// حفظ الإحصائيات
  Future<void> _saveStats() async {
    await _statsBox.put('currentStreak', _currentStreak);
    await _statsBox.put('totalReads', _totalReads);
    await _statsBox.put('totalFavorites', _totalFavorites);
    await _statsBox.put('totalShares', _totalShares);
    await _statsBox.put('categoriesExplored', _categoriesExplored);
    await _statsBox.put('totalDuas', _totalDuas);
    await _statsBox.put('totalWirdDays', _totalWirdDays);
    await _statsBox.put('totalAudioMinutes', _totalAudioMinutes);
    if (_lastReadDate != null) {
      await _statsBox.put('lastReadDate', _lastReadDate!.toIso8601String());
    }
  }

  /// تحديث التقدم
  Future<void> updateProgress(AchievementType type, int increment) async {
    // تحديث الإحصائيات
    switch (type) {
      case AchievementType.dailyReading:
      case AchievementType.totalReading:
        _totalReads += increment;
        await _updateStreak();
        break;
      case AchievementType.favorites:
        _totalFavorites += increment;
        break;
      case AchievementType.sharing:
        _totalShares += increment;
        break;
      case AchievementType.categories:
        _categoriesExplored += increment;
        break;
      case AchievementType.duas:
        _totalDuas += increment;
        break;
      case AchievementType.wird:
        _totalWirdDays += increment;
        break;
      case AchievementType.audio:
        _totalAudioMinutes += increment;
        break;
      case AchievementType.streak:
        // يُحدث تلقائياً في _updateStreak
        break;
    }

    await _saveStats();

    // تحديث تقدم الإنجازات
    for (var achievement in _achievements) {
      if (achievement.type == type && !achievement.isUnlocked) {
        int progress = 0;

        switch (type) {
          case AchievementType.totalReading:
            progress = _totalReads;
            break;
          case AchievementType.favorites:
            progress = _totalFavorites;
            break;
          case AchievementType.sharing:
            progress = _totalShares;
            break;
          case AchievementType.streak:
            progress = _currentStreak;
            break;
          case AchievementType.categories:
            progress = _categoriesExplored;
            break;
          case AchievementType.duas:
            progress = _totalDuas;
            break;
          case AchievementType.wird:
            progress = _totalWirdDays;
            break;
          case AchievementType.audio:
            progress = _totalAudioMinutes;
            break;
          default:
            progress = achievement.currentProgress + increment;
        }

        achievement.currentProgress = progress;

        if (achievement.isCompleted && !achievement.isUnlocked) {
          await _unlockAchievement(achievement);
        } else {
          await _saveAchievement(achievement);
        }
      }
    }

    notifyListeners();
  }

  /// تحديث Streak (الأيام المتتالية)
  Future<void> _updateStreak() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastReadDate == null) {
      _currentStreak = 1;
      _lastReadDate = today;
    } else {
      final lastRead = DateTime(
        _lastReadDate!.year,
        _lastReadDate!.month,
        _lastReadDate!.day,
      );
      final difference = today.difference(lastRead).inDays;

      if (difference == 0) {
        // نفس اليوم - لا نفعل شيء
        return;
      } else if (difference == 1) {
        // يوم متتالي
        _currentStreak++;
        _lastReadDate = today;
      } else {
        // انقطع التواصل
        _currentStreak = 1;
        _lastReadDate = today;
      }
    }

    // تحديث إنجازات الـ Streak
    await updateProgress(AchievementType.streak, 0);
  }

  /// فتح إنجاز
  Future<void> _unlockAchievement(Achievement achievement) async {
    achievement.isUnlocked = true;
    achievement.unlockedAt = DateTime.now();
    await _saveAchievement(achievement);
    notifyListeners();
  }

  /// الحصول على الإنجازات حسب النوع
  List<Achievement> getAchievementsByType(AchievementType type) {
    return _achievements.where((a) => a.type == type).toList();
  }

  /// الحصول على الإنجاز بـ ID
  Achievement? getAchievementById(String id) {
    try {
      return _achievements.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  /// إعادة تعيين جميع الإنجازات (للاختبار)
  Future<void> resetAllAchievements() async {
    for (var achievement in _achievements) {
      achievement.isUnlocked = false;
      achievement.currentProgress = 0;
      achievement.unlockedAt = null;
      await _saveAchievement(achievement);
    }

    _currentStreak = 0;
    _totalReads = 0;
    _totalFavorites = 0;
    _totalShares = 0;
    _categoriesExplored = 0;
    _lastReadDate = null;

    await _saveStats();
    notifyListeners();
  }

  /// إضافة قراءة جديدة
  Future<void> recordRead() async {
    await updateProgress(AchievementType.totalReading, 1);
  }

  /// إضافة مفضلة
  Future<void> recordFavorite() async {
    await updateProgress(AchievementType.favorites, 1);
  }

  /// إزالة مفضلة
  Future<void> removeFavorite() async {
    if (_totalFavorites > 0) {
      _totalFavorites--;
      await _saveStats();

      // تحديث تقدم إنجازات المفضلة
      for (var achievement in _achievements) {
        if (achievement.type == AchievementType.favorites) {
          achievement.currentProgress = _totalFavorites;
          await _saveAchievement(achievement);
        }
      }

      notifyListeners();
    }
  }

  /// إضافة مشاركة
  Future<void> recordShare() async {
    await updateProgress(AchievementType.sharing, 1);
  }

  /// إضافة فئة مستكشفة
  Future<void> recordCategoryExplored() async {
    await updateProgress(AchievementType.categories, 1);
  }

  /// إضافة قراءة دعاء
  Future<void> recordDua() async {
    await updateProgress(AchievementType.duas, 1);
  }

  /// إضافة إتمام ورد
  Future<void> recordWirdDay() async {
    await updateProgress(AchievementType.wird, 1);
  }

  /// إضافة دقائق استماع
  Future<void> recordAudioMinutes(int minutes) async {
    await updateProgress(AchievementType.audio, minutes);
  }

  /// إعادة تعيين الإحصائيات الموسعة
  Future<void> resetAllAchievementsExtended() async {
    await resetAllAchievements();

    _totalDuas = 0;
    _totalWirdDays = 0;
    _totalAudioMinutes = 0;

    await _saveStats();
    notifyListeners();
  }
}
