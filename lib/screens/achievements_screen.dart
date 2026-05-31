import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/achievements_provider.dart';
import '../models/achievement_model.dart';
import '../models/points_system.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// شاشة الإنجازات
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final achievementsProvider = context.watch<AchievementsProvider>();
    final achievements = achievementsProvider.achievements;
    final unlocked = achievementsProvider.unlockedCount;
    final total = achievementsProvider.totalAchievements;
    final percentage = achievementsProvider.completionPercentage;
    final totalPoints = achievementsProvider.totalPoints;
    final currentRank = achievementsProvider.currentRank;
    final progressToNext = achievementsProvider.progressToNextRank;
    final nextRankPoints = achievementsProvider.nextRankPoints;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإنجازات'),
      ),
      body: Column(
        children: [
          // رأس الصفحة مع الإحصائيات
          _buildHeader(
            unlocked,
            total,
            percentage,
            totalPoints,
            currentRank,
            progressToNext,
            nextRankPoints,
            isDark,
          ),

          // قائمة الإنجازات
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                return _buildAchievementCard(achievement, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    int unlocked,
    int total,
    double percentage,
    int totalPoints,
    UserRank currentRank,
    double progressToNext,
    int nextRankPoints,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brandSecondary.withOpacity(0.2),
            AppColors.brandPrimary.withOpacity(0.2),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.brandPrimary.withOpacity(0.3),
          ),
        ),
      ),
      child: Column(
        children: [
          // الرتبة الحالية
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.brandSecondary.withOpacity(0.3),
                  AppColors.brandPrimary.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.brandSecondary,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentRank.icon,
                  style: const TextStyle(fontSize: 40),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentRank.displayName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandSecondary,
                      ),
                    ),
                    Text(
                      '$totalPoints نقطة',
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            isDark ? Colors.white70 : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // التقدم للرتبة التالية
          if (nextRankPoints > 0) ...[
            Text(
              'التقدم للرتبة التالية',
              style: AppTextStyles.caption(isDark: isDark),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progressToNext,
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.brandSecondary),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'تحتاج ${nextRankPoints - totalPoints} نقطة',
              style:
                  AppTextStyles.caption(isDark: isDark).copyWith(fontSize: 12),
            ),
            const SizedBox(height: 16),
          ],

          // الإحصائيات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(
                icon: '🏆',
                label: 'الإنجازات',
                value: '$unlocked/$total',
                isDark: isDark,
              ),
              Container(width: 1, height: 40, color: Colors.grey[300]),
              _buildStat(
                icon: '⭐',
                label: 'النقاط',
                value: '$totalPoints',
                isDark: isDark,
              ),
              Container(width: 1, height: 40, color: Colors.grey[300]),
              _buildStat(
                icon: '📊',
                label: 'التقدم',
                value: '${percentage.toInt()}%',
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required String icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.brandPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.caption(isDark: isDark).copyWith(fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(Achievement achievement, bool isDark) {
    final tierColor = _getTierColor(achievement.tier);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Opacity(
        opacity: achievement.isUnlocked ? 1.0 : 0.6,
        child: Card(
          elevation: achievement.isUnlocked ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: achievement.isUnlocked
                  ? Border.all(
                      color: tierColor,
                      width: 2,
                    )
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // أيقونة الإنجاز
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: achievement.isUnlocked
                            ? tierColor.withOpacity(0.2)
                            : Colors.grey.shade200,
                        border: Border.all(
                          color: achievement.isUnlocked
                              ? tierColor
                              : Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          achievement.icon,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // معلومات الإنجاز
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  achievement.title,
                                  style: AppTextStyles.heading3(isDark: isDark)
                                      .copyWith(
                                    fontSize: 18,
                                    color: achievement.isUnlocked
                                        ? tierColor
                                        : null,
                                  ),
                                ),
                              ),
                              // المستوى والنقاط
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    achievement.tierIcon,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    '+${achievement.points}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.brandSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            achievement.description,
                            style: AppTextStyles.caption(isDark: isDark),
                          ),
                          if (!achievement.isUnlocked) ...[
                            const SizedBox(height: 8),
                            // شريط التقدم
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: achievement.progressPercentage / 100,
                                    minHeight: 6,
                                    backgroundColor: Colors.grey.shade300,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      tierColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${achievement.currentProgress} / ${achievement.requiredCount}',
                                  style: AppTextStyles.caption(isDark: isDark)
                                      .copyWith(fontSize: 11),
                                ),
                              ],
                            ),
                          ] else ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: tierColor,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'تم الفتح في ${_formatDate(achievement.unlockedAt!)}',
                                    style: AppTextStyles.caption(isDark: isDark)
                                        .copyWith(
                                      color: tierColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTierColor(int tier) {
    switch (tier) {
      case 1:
        return const Color(0xFFCD7F32); // برونزي
      case 2:
        return const Color(0xFFC0C0C0); // فضي
      case 3:
        return AppColors.brandSecondary; // ذهبي
      case 4:
        return const Color(0xFFE5E4E2); // بلاتيني
      case 5:
        return const Color(0xFFB9F2FF); // ماسي
      case 6:
        return const Color(0xFF50C878); // زمردي
      case 7:
        return const Color(0xFFFF6347); // أسطوري
      default:
        return const Color(0xFFCD7F32);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
