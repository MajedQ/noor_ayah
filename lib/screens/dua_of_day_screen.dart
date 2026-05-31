import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/dua_model.dart';
import '../providers/dua_provider.dart';
import '../widgets/dua_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'dua_details_screen.dart';
import 'duas_list_screen.dart';

/// شاشة دعاء اليوم
class DuaOfDayScreen extends StatefulWidget {
  const DuaOfDayScreen({super.key});

  @override
  State<DuaOfDayScreen> createState() => _DuaOfDayScreenState();
}

class _DuaOfDayScreenState extends State<DuaOfDayScreen> {
  @override
  void initState() {
    super.initState();
    // تحميل الأدعية عند بدء التطبيق
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DuaProvider>().loadDuas();
    });
  }

  void _navigateToDuaDetails(DuaModel dua) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DuaDetailsScreen(dua: dua),
      ),
    );
  }

  void _navigateToDuasList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DuasListScreen(),
      ),
    );
  }

  Future<void> _shareDua(DuaModel dua) async {
    await Share.share(
      dua.getFormattedText(),
      subject: dua.title,
    );
  }

  Future<void> _copyDua(DuaModel dua) async {
    await Clipboard.setData(ClipboardData(text: dua.getFormattedText()));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم نسخ الدعاء'),
          backgroundColor: AppColors.brandPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    theme.colorScheme.background,
                    theme.colorScheme.surface,
                  ]
                : [
                    AppColors.lightBeige,
                    Colors.white,
                  ],
          ),
        ),
        child: SafeArea(
          child: Consumer<DuaProvider>(
            builder: (context, duaProvider, child) {
              if (duaProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final todayDua = duaProvider.getTodayDua();

              if (todayDua == null) {
                return _buildEmptyState(context);
              }

              return CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: true,
                    pinned: true,
                    backgroundColor: isDark
                        ? theme.appBarTheme.backgroundColor
                        : AppColors.brandPrimary,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '🤲',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'دعاء اليوم',
                            style:
                                AppTextStyles.heading2(isDark: true).copyWith(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      centerTitle: true,
                    ),
                    actions: [
                      // زر قائمة جميع الأدعية
                      IconButton(
                        icon: const Icon(Icons.list_alt_rounded),
                        onPressed: _navigateToDuasList,
                        tooltip: 'جميع الأدعية',
                      ),
                    ],
                  ),

                  // المحتوى
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // التاريخ
                          _buildDateCard(context, isDark),

                          const SizedBox(height: 20),

                          // بطاقة دعاء اليوم
                          Hero(
                            tag: 'dua_${todayDua.id}',
                            child: Material(
                              color: Colors.transparent,
                              child: DuaCard(
                                dua: todayDua,
                                showFullContent: false,
                                onTap: () => _navigateToDuaDetails(todayDua),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // أزرار الإجراءات
                          _buildActionButtons(context, todayDua),

                          const SizedBox(height: 24),

                          // قسم الأدعية المقترحة
                          _buildSuggestedDuas(
                              context, duaProvider, todayDua.id),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDateCard(BuildContext context, bool isDark) {
    final now = DateTime.now();
    final weekday = _getArabicWeekday(now.weekday);
    final date = '${now.day}/${now.month}/${now.year}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.brandSecondary.withOpacity(0.2),
            AppColors.brandPrimary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.brandSecondary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_rounded,
            color: AppColors.brandSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Text(
                weekday,
                style: AppTextStyles.bodyText(isDark: false).copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: AppTextStyles.caption(isDark: false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, DuaModel dua) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _navigateToDuaDetails(dua),
            icon: const Icon(Icons.remove_red_eye_outlined),
            label: const Text('التفاصيل'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _shareDua(dua),
            icon: const Icon(Icons.share_outlined),
            label: const Text('مشاركة'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.brandPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: AppColors.brandPrimary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () => _copyDua(dua),
          icon: const Icon(Icons.copy_outlined),
          style: IconButton.styleFrom(
            foregroundColor: AppColors.brandPrimary,
            backgroundColor: AppColors.brandPrimary.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedDuas(
    BuildContext context,
    DuaProvider duaProvider,
    int currentDuaId,
  ) {
    final suggestedDuas = duaProvider
        .getRandomDuas(3)
        .where((d) => d.id != currentDuaId)
        .take(3)
        .toList();

    if (suggestedDuas.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أدعية أخرى',
          style: AppTextStyles.heading2(isDark: false).copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),
        ...suggestedDuas.map((dua) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DuaCard(
                dua: dua,
                isCompact: true,
                onTap: () => _navigateToDuaDetails(dua),
              ),
            )),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد أدعية متاحة',
            style: AppTextStyles.heading2(isDark: false),
          ),
          const SizedBox(height: 8),
          Text(
            'يرجى المحاولة مرة أخرى',
            style: AppTextStyles.caption(isDark: false),
          ),
        ],
      ),
    );
  }

  String _getArabicWeekday(int weekday) {
    const weekdays = [
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    return weekdays[weekday - 1];
  }
}
