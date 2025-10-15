/// نظام النقاط والرتب
class PointsSystem {
  /// حساب النقاط من الإنجازات
  static int calculatePoints(int tier) {
    switch (tier) {
      case 1: // برونزي
        return 10;
      case 2: // فضي
        return 25;
      case 3: // ذهبي
        return 50;
      case 4: // بلاتيني
        return 100;
      case 5: // ماسي
        return 200;
      case 6: // زمردي
        return 365;
      case 7: // أسطوري
        return 500;
      default:
        return 10;
    }
  }

  /// الحصول على الرتبة من النقاط
  static UserRank getRankFromPoints(int points) {
    if (points >= 3501) return UserRank.sheikh;
    if (points >= 2001) return UserRank.master;
    if (points >= 1001) return UserRank.expert;
    if (points >= 601) return UserRank.advanced;
    if (points >= 301) return UserRank.scholar;
    if (points >= 101) return UserRank.learner;
    return UserRank.beginner;
  }

  /// الحصول على نقاط الرتبة التالية
  static int getNextRankPoints(UserRank currentRank) {
    switch (currentRank) {
      case UserRank.beginner:
        return 101;
      case UserRank.learner:
        return 301;
      case UserRank.scholar:
        return 601;
      case UserRank.advanced:
        return 1001;
      case UserRank.expert:
        return 2001;
      case UserRank.master:
        return 3501;
      case UserRank.sheikh:
        return 0; // أعلى رتبة
    }
  }

  /// نسبة التقدم للرتبة التالية
  static double getProgressToNextRank(int points, UserRank currentRank) {
    final currentMin = _getRankMinPoints(currentRank);
    final nextMin = getNextRankPoints(currentRank);

    if (nextMin == 0) return 1.0; // أعلى رتبة

    final progress = (points - currentMin) / (nextMin - currentMin);
    return progress.clamp(0.0, 1.0);
  }

  static int _getRankMinPoints(UserRank rank) {
    switch (rank) {
      case UserRank.beginner:
        return 0;
      case UserRank.learner:
        return 101;
      case UserRank.scholar:
        return 301;
      case UserRank.advanced:
        return 601;
      case UserRank.expert:
        return 1001;
      case UserRank.master:
        return 2001;
      case UserRank.sheikh:
        return 3501;
    }
  }
}

/// رتب المستخدمين
enum UserRank {
  beginner, // مبتدئ (0-100)
  learner, // متعلم (101-300)
  scholar, // عالم (301-600)
  advanced, // متقدم (601-1000)
  expert, // خبير (1001-2000)
  master, // أستاذ (2001-3500)
  sheikh, // شيخ (3501+)
}

extension UserRankExtension on UserRank {
  String get displayName {
    switch (this) {
      case UserRank.beginner:
        return 'مبتدئ';
      case UserRank.learner:
        return 'متعلم';
      case UserRank.scholar:
        return 'عالم';
      case UserRank.advanced:
        return 'متقدم';
      case UserRank.expert:
        return 'خبير';
      case UserRank.master:
        return 'أستاذ';
      case UserRank.sheikh:
        return 'شيخ';
    }
  }

  String get displayNameEnglish {
    switch (this) {
      case UserRank.beginner:
        return 'Beginner';
      case UserRank.learner:
        return 'Learner';
      case UserRank.scholar:
        return 'Scholar';
      case UserRank.advanced:
        return 'Advanced';
      case UserRank.expert:
        return 'Expert';
      case UserRank.master:
        return 'Master';
      case UserRank.sheikh:
        return 'Sheikh';
    }
  }

  String get icon {
    switch (this) {
      case UserRank.beginner:
        return '🌱';
      case UserRank.learner:
        return '📚';
      case UserRank.scholar:
        return '🎓';
      case UserRank.advanced:
        return '⭐';
      case UserRank.expert:
        return '💎';
      case UserRank.master:
        return '👑';
      case UserRank.sheikh:
        return '🏆';
    }
  }

  String get color {
    switch (this) {
      case UserRank.beginner:
        return '#8BC34A'; // أخضر فاتح
      case UserRank.learner:
        return '#4CAF50'; // أخضر
      case UserRank.scholar:
        return '#2196F3'; // أزرق
      case UserRank.advanced:
        return '#9C27B0'; // بنفسجي
      case UserRank.expert:
        return '#FF9800'; // برتقالي
      case UserRank.master:
        return '#E91E63'; // وردي
      case UserRank.sheikh:
        return '#FFD700'; // ذهبي
    }
  }

  String get description {
    switch (this) {
      case UserRank.beginner:
        return 'بداية رحلتك في التدبر والذكر';
      case UserRank.learner:
        return 'تتعلم وتتقدم في طريق العلم';
      case UserRank.scholar:
        return 'باحث متقدم في الذكر والتدبر';
      case UserRank.advanced:
        return 'متقدم في العبادة والمثابرة';
      case UserRank.expert:
        return 'خبير في التدبر والذكر';
      case UserRank.master:
        return 'أستاذ في العلم والعمل';
      case UserRank.sheikh:
        return 'بلغت أعلى مراتب التفاني';
    }
  }

  /// نطاق النقاط للرتبة
  String get pointsRange {
    switch (this) {
      case UserRank.beginner:
        return '0-100 نقطة';
      case UserRank.learner:
        return '101-300 نقطة';
      case UserRank.scholar:
        return '301-600 نقطة';
      case UserRank.advanced:
        return '601-1000 نقطة';
      case UserRank.expert:
        return '1001-2000 نقطة';
      case UserRank.master:
        return '2001-3500 نقطة';
      case UserRank.sheikh:
        return '3501+ نقطة';
    }
  }
}
