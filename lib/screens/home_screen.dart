import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/verse_card.dart';
import '../widgets/dua_card.dart';
import '../providers/verse_provider.dart';
import '../providers/dua_provider.dart';
import '../providers/wird_provider.dart';
import '../providers/calendar_provider.dart';
import '../providers/achievements_provider.dart';
import '../providers/theme_provider.dart';
import '../services/notification_service.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';
import '../theme/theme_colors.dart';
import '../utils/constants.dart';
import 'verse_details_screen.dart';
import 'dua_of_day_screen.dart';
import 'daily_wird_screen.dart';
import 'achievements_screen.dart';

/// الشاشة الرئيسية - آية اليوم
class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _notificationsEnabled = false;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    // تحميل الآيات عند بدء التطبيق
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VerseProvider>().loadVerses();
      _loadNotificationSettings();
    });
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      final savedHour = prefs.getInt('notificationHour') ?? 9;
      final savedMinute = prefs.getInt('notificationMinute') ?? 0;
      _selectedTime = TimeOfDay(hour: savedHour, minute: savedMinute);
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value) {
      final hasPermission = await NotificationService.requestPermissions();
      if (!hasPermission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('يرجى تفعيل أذونات الإشعارات من إعدادات الجهاز'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      await NotificationService.scheduleDailyNotification(time: _selectedTime);
    } else {
      await NotificationService.cancelAllNotifications();
    }

    setState(() {
      _notificationsEnabled = value;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('notificationHour', _selectedTime.hour);
      await prefs.setInt('notificationMinute', _selectedTime.minute);

      if (_notificationsEnabled) {
        await NotificationService.scheduleDailyNotification(
            time: _selectedTime);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'تم تحديث وقت الإشعار إلى ${_formatTime(_selectedTime)}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'مساءً' : 'صباحاً';
    return '${hour}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final verseProvider = context.watch<VerseProvider>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundDark,
                    AppColors.cardDark,
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.brandPrimary.withOpacity(0.1),
                    AppColors.backgroundLight,
                  ],
                ),
        ),
        child: SafeArea(
          child: verseProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _buildContent(context, verseProvider, isDark),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    VerseProvider verseProvider,
    bool isDark,
  ) {
    final todayVerse = verseProvider.getTodayVerse();

    if (todayVerse == null) {
      return Center(
        child: Text(
          AppConstants.noVersesMessage,
          style: AppTextStyles.bodyText(isDark: isDark),
        ),
      );
    }

    final calendarProvider = context.watch<CalendarProvider>();
    final formattedDate = calendarProvider.getFormattedDate();
    final isRamadan = calendarProvider.isRamadan();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // العنوان والشعار (مضغوط)
            _buildCompactHeader(isDark),

            const SizedBox(height: 12),

            // التاريخ
            _buildDateCard(formattedDate, isDark, calendarProvider, isRamadan),

            const SizedBox(height: 12),

            // بطاقة الآية
            Hero(
              tag: 'verse_${todayVerse.id}',
              child: VerseCard(
                verse: todayVerse,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VerseDetailsScreen(verse: todayVerse),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // بطاقة دعاء اليوم
            _buildDuaOfDaySection(context, isDark),

            const SizedBox(height: 16),

            // بطاقة الورد اليومي
            _buildWirdSection(context, isDark),

            const SizedBox(height: 12),

            // الإنجازات
            _buildAchievementsCard(context, isDark),

            const SizedBox(height: 12),

            // بطاقة الإشعارات
            _buildNotificationsCard(isDark),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactHeader(bool isDark) {
    final themeProvider = context.read<ThemeProvider>();
    final themeColors = ThemeColors(themeProvider.colorTheme);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              // أيقونة التطبيق
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/icon/app_icon_64.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.appName,
                      style: AppTextStyles.heading1(isDark: isDark).copyWith(
                        color: themeColors.primary,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppConstants.appSlogan,
                      style: AppTextStyles.caption(isDark: isDark).copyWith(
                        color: themeColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // آية اليوم badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: themeColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: themeColors.primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🌟',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 4),
              Text(
                'اليوم',
                style: AppTextStyles.caption(isDark: isDark).copyWith(
                  color: themeColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark) {
    final themeProvider = context.read<ThemeProvider>();
    final themeColors = ThemeColors(themeProvider.colorTheme);

    return Column(
      children: [
        Text(
          AppConstants.appName,
          style: AppTextStyles.heading1(isDark: isDark).copyWith(
            color: themeColors.primary,
            fontSize: 36,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          AppConstants.appSlogan,
          style: AppTextStyles.bodyText(isDark: isDark).copyWith(
            color: themeColors.secondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDateCard(
    String formattedDate,
    bool isDark,
    CalendarProvider calendarProvider,
    bool isRamadan,
  ) {
    final dateColor =
        isRamadan ? AppColors.brandSecondary : AppColors.brandPrimary;

    return GestureDetector(
      onTap: () => calendarProvider.toggleCalendar(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : dateColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: dateColor.withOpacity(0.3),
            width: isRamadan ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isRamadan) ...[
              const Text('🌙', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
            ],
            Icon(
              calendarProvider.calendarIcon,
              size: 18,
              color: dateColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                formattedDate,
                style: AppTextStyles.bodyText(isDark: isDark).copyWith(
                  color: dateColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.swap_horiz,
              size: 18,
              color: dateColor.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(VerseProvider verseProvider, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.book,
            label: 'إجمالي الآيات',
            value: '${verseProvider.totalVersesCount}',
            color: AppColors.brandPrimary,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.category,
            label: 'الفئات',
            value: '${verseProvider.categoriesCount}',
            color: AppColors.brandSecondary,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.heading2(isDark: isDark).copyWith(
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption(isDark: isDark),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsCard(bool isDark) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.info.withOpacity(0.1),
              AppColors.brandPrimary.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // العنوان مع الأيقونة
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _notificationsEnabled
                        ? AppColors.brandPrimary.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    border: Border.all(
                      color: _notificationsEnabled
                          ? AppColors.brandPrimary
                          : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    _notificationsEnabled
                        ? Icons.notifications_active
                        : Icons.notifications_off,
                    color: _notificationsEnabled
                        ? AppColors.brandPrimary
                        : Colors.grey,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🔔 الإشعارات اليومية',
                        style: AppTextStyles.heading3(isDark: isDark).copyWith(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _notificationsEnabled
                            ? 'آية يومياً في ${_formatTime(_selectedTime)}'
                            : 'فعّل لتلقي آية يومياً',
                        style: AppTextStyles.caption(isDark: isDark),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _notificationsEnabled,
                  onChanged: _toggleNotifications,
                  activeColor: AppColors.brandPrimary,
                ),
              ],
            ),

            // زر اختيار الوقت
            if (_notificationsEnabled) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectTime,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brandPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.brandPrimary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppColors.brandPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'تغيير الوقت: ${_formatTime(_selectedTime)}',
                        style: AppTextStyles.bodyText(isDark: isDark).copyWith(
                          color: AppColors.brandPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsCard(BuildContext context, bool isDark) {
    final achievementsProvider = context.watch<AchievementsProvider>();
    final unlocked = achievementsProvider.unlockedCount;
    final total = achievementsProvider.totalAchievements;
    final streak = achievementsProvider.currentStreak;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AchievementsScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.brandSecondary.withOpacity(0.1),
                AppColors.brandPrimary.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // أيقونة الإنجازات
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.brandSecondary.withOpacity(0.2),
                  border: Border.all(
                    color: AppColors.brandSecondary,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.emoji_events,
                    color: AppColors.brandSecondary,
                    size: 30,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // معلومات الإنجازات
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🏆 الإنجازات',
                      style: AppTextStyles.heading3(isDark: isDark).copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$unlocked من $total مفتوح',
                      style: AppTextStyles.caption(isDark: isDark),
                    ),
                    if (streak > 0) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(
                            '$streak يوم متتالي',
                            style:
                                AppTextStyles.caption(isDark: isDark).copyWith(
                              color: AppColors.brandSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // سهم
              Icon(
                Icons.chevron_right,
                color: AppColors.brandSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExploreCard(BuildContext context, bool isDark) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.brandSecondary.withOpacity(0.1),
              AppColors.brandPrimary.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              '✨ استكشف المزيد',
              style: AppTextStyles.heading3(isDark: isDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'تصفح الآيات حسب الفئات أو ابحث عن آية معينة',
              style: AppTextStyles.bodyText(isDark: isDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // الانتقال لشاشة الفئات (tab index 1)
                    widget.onNavigateToTab?.call(1);
                  },
                  icon: const Icon(Icons.category, size: 20),
                  label: const Text('الفئات'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    // الانتقال لشاشة البحث (tab index 3)
                    widget.onNavigateToTab?.call(3);
                  },
                  icon: const Icon(Icons.search, size: 20),
                  label: const Text('بحث'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuaOfDaySection(BuildContext context, bool isDark) {
    final duaProvider = context.watch<DuaProvider>();
    final todayDua = duaProvider.getTodayDua();

    if (todayDua == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // عنوان القسم
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '🤲',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                Text(
                  'دعاء اليوم',
                  style: AppTextStyles.heading2(isDark: isDark).copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DuaOfDayScreen(),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'المزيد',
                    style: TextStyle(
                      color: AppColors.brandPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: AppColors.brandPrimary,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // بطاقة الدعاء
        DuaCard(
          dua: todayDua,
          isCompact: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DuaOfDayScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWirdSection(BuildContext context, bool isDark) {
    final wirdProvider = context.watch<WirdProvider>();
    final activeWird = wirdProvider.activeWird;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.brandSecondary.withOpacity(0.15),
            AppColors.brandPrimary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.brandSecondary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // عنوان القسم
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '📿',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'الورد اليومي',
                    style: AppTextStyles.heading2(isDark: isDark).copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DailyWirdScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      activeWird == null ? 'إنشاء' : 'عرض',
                      style: TextStyle(
                        color: AppColors.brandSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppColors.brandSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // المحتوى
          if (activeWird != null && activeWird.items.isNotEmpty) ...[
            // شريط التقدم
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: activeWird.completionPercentage,
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  activeWird.isCompletedToday
                      ? AppColors.brandSecondary
                      : AppColors.brandPrimary,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // الإحصائيات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWirdStat(
                  icon: '✓',
                  label: 'مكتمل',
                  value:
                      '${activeWird.completedCount}/${activeWird.items.length}',
                  isDark: isDark,
                ),
                Container(width: 1, height: 30, color: Colors.grey[300]),
                _buildWirdStat(
                  icon: '🔥',
                  label: 'متتالية',
                  value: '${activeWird.consecutiveDays} يوم',
                  isDark: isDark,
                ),
              ],
            ),

            if (activeWird.isCompletedToday) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.brandSecondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.brandSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'تم إكمال الورد اليوم - بارك الله فيك',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ] else ...[
            // رسالة فارغة
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '📚',
                    style: const TextStyle(fontSize: 40),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'لم تنشئ ورداً يومياً بعد',
                    style: AppTextStyles.bodyText(isDark: isDark).copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اضغط على "إنشاء" لإنشاء ورد يومي',
                    style: AppTextStyles.caption(isDark: isDark),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWirdStat({
    required String icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Column(
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.heading3(isDark: isDark).copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
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
}
