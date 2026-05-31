import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/dua_model.dart';
import '../providers/dua_provider.dart';
import '../providers/font_provider.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'dua_share_preview_screen.dart';

/// شاشة تفاصيل الدعاء
class DuaDetailsScreen extends StatefulWidget {
  final DuaModel dua;

  const DuaDetailsScreen({
    super.key,
    required this.dua,
  });

  @override
  State<DuaDetailsScreen> createState() => _DuaDetailsScreenState();
}

class _DuaDetailsScreenState extends State<DuaDetailsScreen> {
  late DuaModel currentDua;

  @override
  void initState() {
    super.initState();
    currentDua = widget.dua;
  }

  void _navigateToNextDua() {
    final duaProvider = context.read<DuaProvider>();
    final nextDua = duaProvider.getNextDua(currentDua.id);
    if (nextDua != null) {
      setState(() {
        currentDua = nextDua;
      });
    }
  }

  void _navigateToPreviousDua() {
    final duaProvider = context.read<DuaProvider>();
    final prevDua = duaProvider.getPreviousDua(currentDua.id);
    if (prevDua != null) {
      setState(() {
        currentDua = prevDua;
      });
    }
  }

  Future<void> _shareDua() async {
    await Share.share(
      currentDua.getFormattedText(),
      subject: currentDua.title,
    );
  }

  Future<void> _copyDua() async {
    await Clipboard.setData(
      ClipboardData(text: currentDua.getFormattedText()),
    );
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
    final fontProvider = Provider.of<FontProvider>(context);
    final duaProvider = Provider.of<DuaProvider>(context);

    final hasNext = duaProvider.getNextDua(currentDua.id) != null;
    final hasPrev = duaProvider.getPreviousDua(currentDua.id) != null;

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
          child: Column(
            children: [
              // App Bar مخصص
              _buildCustomAppBar(context, isDark),

              // المحتوى القابل للتمرير
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // العنوان والأيقونات
                      _buildHeader(context, isDark),

                      const SizedBox(height: 24),

                      // نص الدعاء
                      _buildDuaText(context, fontProvider),

                      const SizedBox(height: 24),

                      // النطق (إن وجد)
                      if (currentDua.transliteration != null &&
                          currentDua.transliteration!.isNotEmpty) ...[
                        _buildTransliteration(context, isDark),
                        const SizedBox(height: 24),
                      ],

                      // الفوائد
                      if (currentDua.benefits != null &&
                          currentDua.benefits!.isNotEmpty) ...[
                        _buildBenefits(context, isDark),
                        const SizedBox(height: 24),
                      ],

                      // المصدر
                      _buildSource(context, isDark),

                      const SizedBox(height: 24),

                      // أزرار الإجراءات
                      _buildActionButtons(context),
                    ],
                  ),
                ),
              ),

              // شريط التنقل السفلي
              if (hasNext || hasPrev)
                _buildNavigationBar(context, hasNext, hasPrev, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(context).appBarTheme.backgroundColor
            : AppColors.brandPrimary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'تفاصيل الدعاء',
              style: AppTextStyles.heading2(isDark: isDark).copyWith(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // زر المفضلة
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, _) {
              final isFavorite = favoritesProvider.isDuaFavorite(currentDua.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.brandSecondary : Colors.white,
                ),
                onPressed: () async {
                  await favoritesProvider.toggleDuaFavorite(currentDua);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFavorite
                              ? 'تم إزالة الدعاء من المفضلة'
                              : 'تم إضافة الدعاء للمفضلة',
                        ),
                        duration: const Duration(seconds: 1),
                        backgroundColor: isFavorite
                            ? Colors.grey[700]
                            : AppColors.brandSecondary,
                      ),
                    );
                  }
                },
                tooltip: isFavorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareDua,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          // أيقونة الفئة
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandPrimary.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              currentDua.category.icon,
              style: const TextStyle(fontSize: 40),
            ),
          ),

          const SizedBox(height: 16),

          // العنوان
          Text(
            currentDua.title,
            style: AppTextStyles.heading2(isDark: isDark).copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // الفئة والمناسبة
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              Chip(
                label: Text(currentDua.category.displayName),
                backgroundColor: AppColors.brandPrimary.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: AppColors.brandPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (currentDua.occasion != DuaOccasion.general)
                Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(currentDua.occasion.icon),
                      const SizedBox(width: 4),
                      Text(currentDua.occasion.displayName),
                    ],
                  ),
                  backgroundColor: AppColors.brandSecondary.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: AppColors.brandSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDuaText(BuildContext context, FontProvider fontProvider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withOpacity(0.2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.brandPrimary.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandPrimary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.format_quote,
            color: AppColors.brandSecondary.withOpacity(0.3),
            size: 32,
          ),
          const SizedBox(height: 16),
          Text(
            currentDua.duaText,
            style: TextStyle(
              fontFamily: fontProvider.fontFamily,
              fontSize: 22,
              height: 2.0,
              color: theme.textTheme.bodyLarge?.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Transform.rotate(
            angle: 3.14159, // 180 degrees
            child: Icon(
              Icons.format_quote,
              color: AppColors.brandSecondary.withOpacity(0.3),
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransliteration(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBeige.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.brandPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.record_voice_over_outlined,
                color: AppColors.brandPrimary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'النطق:',
                style: AppTextStyles.heading3(isDark: isDark).copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            currentDua.transliteration!,
            style: AppTextStyles.bodyText(isDark: isDark).copyWith(
              fontSize: 16,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefits(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brandSecondary.withOpacity(0.1),
            AppColors.brandSecondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.brandSecondary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💡',
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الفائدة:',
                  style: AppTextStyles.heading3(isDark: isDark).copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentDua.benefits!,
                  style: AppTextStyles.bodyText(isDark: isDark).copyWith(
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSource(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.brandPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.brandPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.menu_book_rounded,
            color: AppColors.brandPrimary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المصدر:',
                  style: AppTextStyles.caption(isDark: isDark).copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentDua.source,
                  style: AppTextStyles.bodyText(isDark: isDark)
                      .copyWith(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _shareDua,
                icon: const Icon(Icons.share_outlined),
                label: const Text('مشاركة نص'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _copyDua,
                icon: const Icon(Icons.copy_outlined),
                label: const Text('نسخ'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.brandPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: AppColors.brandPrimary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DuaSharePreviewScreen(dua: currentDua),
                ),
              );
            },
            icon: const Icon(Icons.image_outlined),
            label: const Text('مشاركة كصورة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandSecondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationBar(
    BuildContext context,
    bool hasNext,
    bool hasPrev,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // زر السابق
          TextButton.icon(
            onPressed: hasPrev ? _navigateToPreviousDua : null,
            icon: const Icon(Icons.arrow_back_ios_rounded),
            label: const Text('السابق'),
            style: TextButton.styleFrom(
              foregroundColor: hasPrev ? AppColors.brandPrimary : Colors.grey,
            ),
          ),

          // زر التالي
          TextButton.icon(
            onPressed: hasNext ? _navigateToNextDua : null,
            icon: const Icon(Icons.arrow_forward_ios_rounded),
            label: const Text('التالي'),
            style: TextButton.styleFrom(
              foregroundColor: hasNext ? AppColors.brandPrimary : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
