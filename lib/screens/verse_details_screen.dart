import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/verse_model.dart';
import '../providers/verse_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/font_provider.dart';
import '../providers/achievements_provider.dart';
import '../providers/audio_provider.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/favorite_button.dart';
import '../widgets/share_button.dart';
import '../services/audio_player_service.dart';
import 'share_preview_screen.dart';

/// شاشة تفاصيل الآية - محسّنة
class VerseDetailsScreen extends StatefulWidget {
  final VerseModel verse;

  const VerseDetailsScreen({super.key, required this.verse});

  @override
  State<VerseDetailsScreen> createState() => _VerseDetailsScreenState();
}

class _VerseDetailsScreenState extends State<VerseDetailsScreen>
    with SingleTickerProviderStateMixin {
  late VerseModel currentVerse;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    currentVerse = widget.verse;

    // إعداد fade animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // تسجيل قراءة الآية كإنجاز
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AchievementsProvider>().recordRead();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _navigateToNextVerse() async {
    if (_isAnimating) return;

    final verseProvider = context.read<VerseProvider>();
    final nextVerse = verseProvider.getNextVerse(currentVerse.id);

    if (nextVerse != null) {
      setState(() => _isAnimating = true);

      // Fade out
      _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
      );
      await _fadeController.forward();

      setState(() {
        currentVerse = nextVerse;
      });

      // Fade in
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
      );
      _fadeController.reset();
      await _fadeController.forward();

      _scrollController.jumpTo(0);
      setState(() => _isAnimating = false);
    }
  }

  void _navigateToPreviousVerse() async {
    if (_isAnimating) return;

    final verseProvider = context.read<VerseProvider>();
    final previousVerse = verseProvider.getPreviousVerse(currentVerse.id);

    if (previousVerse != null) {
      setState(() => _isAnimating = true);

      // Fade out
      _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
      );
      await _fadeController.forward();

      setState(() {
        currentVerse = previousVerse;
      });

      // Fade in
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
      );
      _fadeController.reset();
      await _fadeController.forward();

      _scrollController.jumpTo(0);
      setState(() => _isAnimating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();
    final fontProvider = context.watch<FontProvider>();
    final sizeMultiplier = themeProvider.fontSizeMultiplier;
    final categoryColor = AppColors.getCategoryColor(currentVerse.mainCategory);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${currentVerse.surah} - آية: ${currentVerse.verseNumber}',
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          // زر المفضلة
          FavoriteButton(verse: currentVerse, size: 24),
          const SizedBox(width: 8),

          // زر النسخ
          CopyButton(verse: currentVerse),

          // زر المشاركة
          ShareButton(verse: currentVerse),

          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! < 0) {
                // سحب لليسار - الآية التالية
                _navigateToNextVerse();
              } else if (details.primaryVelocity! > 0) {
                // سحب لليمين - الآية السابقة
                _navigateToPreviousVerse();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: isDark
                    ? null
                    : LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          categoryColor.withOpacity(0.1),
                          AppColors.backgroundLight,
                        ],
                      ),
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // نص الآية
                        Hero(
                          tag: 'verse_${currentVerse.id}',
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.cardDark
                                    : AppColors.cardLight,
                                borderRadius: BorderRadius.circular(
                                  AppConstants.cardBorderRadius,
                                ),
                                border: Border.all(
                                  color: categoryColor.withOpacity(0.3),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: categoryColor.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // أيقونة زخرفية
                                  Text(
                                    '﷽',
                                    style: TextStyle(
                                      fontSize: 32 * sizeMultiplier,
                                      color: categoryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // نص الآية
                                  Text(
                                    currentVerse.verseText,
                                    style: AppTextStyles.verseText(
                                      isDark: isDark,
                                      sizeMultiplier: sizeMultiplier,
                                      fontFamily: fontProvider.fontFamily,
                                    ),
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),

                                  const SizedBox(height: 16),

                                  // أيقونة زخرفية
                                  Container(
                                    width: 60,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          categoryColor.withOpacity(0),
                                          categoryColor,
                                          categoryColor.withOpacity(0),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // تصنيف الآية
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: categoryColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: categoryColor.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AppHelpers.getCategoryIcon(
                                              currentVerse.mainCategory),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          currentVerse.mainCategory,
                                          style: AppTextStyles.bodyText(
                                                  isDark: isDark)
                                              .copyWith(
                                            color: categoryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // مشغل الصوت المدمج
                                  if (currentVerse.surahNumber != null &&
                                      currentVerse.verseNumber != null) ...[
                                    const SizedBox(height: 16),
                                    Divider(
                                      color: categoryColor.withOpacity(0.2),
                                      thickness: 1,
                                    ),
                                    const SizedBox(height: 12),
                                    _buildInlineAudioPlayer(
                                        isDark, categoryColor),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // التدبر
                        _buildSectionCard(
                          icon: '💭',
                          title: 'التدبر',
                          content: currentVerse.reflection,
                          color: AppColors.primaryGreen,
                          isDark: isDark,
                          sizeMultiplier: sizeMultiplier,
                        ),

                        const SizedBox(height: 16),

                        // الدعاء
                        _buildSectionCard(
                          icon: '🤲',
                          title: 'الدعاء',
                          content: currentVerse.dua,
                          color: AppColors.primaryGold,
                          isDark: isDark,
                          sizeMultiplier: sizeMultiplier,
                        ),

                        const SizedBox(height: 24),

                        // أزرار الإجراءات
                        _buildActionButtons(isDark),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // أزرار التنقل في الأسفل
      bottomNavigationBar: _buildBottomNavigationArrows(isDark),
    );
  }

  Widget _buildSectionCard({
    required String icon,
    required String title,
    required String content,
    required Color color,
    required bool isDark,
    required double sizeMultiplier,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.heading3(isDark: isDark).copyWith(
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: title == 'التدبر'
                ? AppTextStyles.reflectionText(
                    isDark: isDark,
                    sizeMultiplier: sizeMultiplier,
                  )
                : AppTextStyles.duaText(
                    isDark: isDark,
                    sizeMultiplier: sizeMultiplier,
                  ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  await AppHelpers.copyToClipboard(
                    currentVerse.verseText,
                    context,
                  );
                },
                icon: const Icon(Icons.copy, size: 20),
                label: const Text('نسخ'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  await AppHelpers.shareVerse(currentVerse);
                  // تسجيل إنجاز المشاركة
                  if (context.mounted) {
                    context.read<AchievementsProvider>().recordShare();
                  }
                },
                icon: const Icon(Icons.share, size: 20),
                label: const Text('مشاركة نص'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // زر مشاركة كصورة
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SharePreviewScreen(verse: currentVerse),
                ),
              );
            },
            icon: const Icon(Icons.image, size: 22),
            label: const Text('مشاركة كصورة مصممة ✨'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGold,
              foregroundColor: AppColors.textPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildBottomNavigationArrows(bool isDark) {
    final verseProvider = context.watch<VerseProvider>();
    final hasPrevious = verseProvider.getPreviousVerse(currentVerse.id) != null;
    final hasNext = verseProvider.getNextVerse(currentVerse.id) != null;

    if (!hasPrevious && !hasNext) return null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // زر السابقة
            if (hasPrevious)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isAnimating ? null : _navigateToPreviousVerse,
                  icon: const Icon(Icons.arrow_back, size: 20),
                  label: const Text('السابقة'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: isDark
                        ? AppColors.primaryGold.withOpacity(0.8)
                        : AppColors.primaryGreen,
                  ),
                ),
              )
            else
              const Expanded(child: SizedBox()),

            if (hasPrevious && hasNext) const SizedBox(width: 12),

            // زر التالية
            if (hasNext)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isAnimating ? null : _navigateToNextVerse,
                  icon: const Icon(Icons.arrow_forward, size: 20),
                  label: const Text('التالية'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: isDark
                        ? AppColors.primaryGold.withOpacity(0.8)
                        : AppColors.primaryGold,
                  ),
                ),
              )
            else
              const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }

  /// مشغل الصوت المدمج في كارد الآية
  Widget _buildInlineAudioPlayer(bool isDark, Color categoryColor) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, _) {
        if (!audioProvider.isInitialized) {
          return const SizedBox.shrink();
        }

        return StreamBuilder(
          stream: audioProvider.playerStateStream,
          builder: (context, snapshot) {
            final isPlaying = audioProvider.isPlayingVerse(
              currentVerse.surahNumber!,
              currentVerse.verseNumber!,
            );

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // زر التشغيل/الإيقاف
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: categoryColor.withOpacity(0.1),
                      ),
                      child: IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: categoryColor,
                          size: 24,
                        ),
                        onPressed: () async {
                          if (isPlaying) {
                            await audioProvider.pause();
                          } else {
                            final success = await audioProvider.playVerse(
                              currentVerse.surahNumber!,
                              currentVerse.verseNumber!,
                            );
                            if (!success && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('حدث خطأ في تشغيل التلاوة'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        tooltip: isPlaying ? 'إيقاف' : 'تشغيل',
                      ),
                    ),

                    const SizedBox(width: 12),

                    // أيقونة القارئ
                    Icon(
                      Icons.record_voice_over,
                      color: categoryColor,
                      size: 18,
                    ),

                    const SizedBox(width: 8),

                    // اسم القارئ
                    Expanded(
                      child: Text(
                        audioProvider.currentReciter.displayName,
                        style: AppTextStyles.bodyText(isDark: isDark).copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(width: 8),

                    // زر تغيير القارئ
                    TextButton(
                      onPressed: () => _showReciterDialog(audioProvider),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'تغيير',
                        style: TextStyle(
                          fontSize: 12,
                          color: categoryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // شريط التقدم (يظهر فقط عند التشغيل)
                if (isPlaying) ...[
                  const SizedBox(height: 12),
                  StreamBuilder<Duration>(
                    stream: audioProvider.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      return StreamBuilder<Duration?>(
                        stream: audioProvider.durationStream,
                        builder: (context, durationSnapshot) {
                          final duration =
                              durationSnapshot.data ?? Duration.zero;
                          final progress = duration.inMilliseconds > 0
                              ? position.inMilliseconds /
                                  duration.inMilliseconds
                              : 0.0;

                          return Column(
                            children: [
                              // شريط التقدم
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 4,
                                  backgroundColor:
                                      categoryColor.withOpacity(0.2),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    categoryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              // الوقت
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(position),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? Colors.white70
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    _formatDuration(duration),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? Colors.white70
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  /// عرض dialog لاختيار القارئ
  void _showReciterDialog(AudioProvider audioProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر القارئ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Reciter.values.map((reciter) {
            final isSelected = audioProvider.currentReciter == reciter;
            return ListTile(
              leading: Icon(
                Icons.record_voice_over,
                color: isSelected ? AppColors.primaryGreen : Colors.grey,
              ),
              title: Text(
                reciter.displayName,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primaryGreen : null,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check, color: AppColors.primaryGreen)
                  : null,
              onTap: () {
                audioProvider.setReciter(reciter);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
