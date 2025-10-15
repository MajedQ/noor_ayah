import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/verse_model.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';
import '../providers/theme_provider.dart';
import '../providers/font_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'favorite_button.dart';

/// بطاقة الآية - محسّنة
class VerseCard extends StatelessWidget {
  final VerseModel verse;
  final VoidCallback? onTap;
  final bool showActions;
  final bool isCompact;

  const VerseCard({
    super.key,
    required this.verse,
    this.onTap,
    this.showActions = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();
    final fontProvider = context.watch<FontProvider>();
    final sizeMultiplier = themeProvider.fontSizeMultiplier;
    final categoryColor = AppColors.getCategoryColor(verse.mainCategory);

    return Card(
      elevation: 4,
      shadowColor: isDark
          ? Colors.black.withOpacity(0.3)
          : Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: InkWell(
        onTap: onTap != null
            ? () {
                AppHelpers.lightHaptic();
                onTap!();
              }
            : null,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            gradient:
                isDark ? AppColors.darkCardGradient : AppColors.cardGradient,
            border: Border.all(
              color: categoryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(isCompact ? 12.0 : 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // رأس البطاقة - اسم السورة والآية مع الفئة والمفضلة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // الفئة
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
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
                            AppHelpers.getCategoryIcon(verse.mainCategory),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            verse.mainCategory,
                            style:
                                AppTextStyles.caption(isDark: isDark).copyWith(
                              color: categoryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // المفضلة في الأعلى
                    if (showActions)
                      FavoriteButton(
                        verse: verse,
                        size: 24,
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // السورة ورقم الآية
                Text(
                  'السورة: ${verse.surah} - آية: ${verse.verseNumber}',
                  style: AppTextStyles.surahName(
                    isDark: isDark,
                    sizeMultiplier: sizeMultiplier,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // نص الآية
                Text(
                  verse.verseText,
                  style: AppTextStyles.verseText(
                    isDark: isDark,
                    sizeMultiplier: sizeMultiplier,
                    fontFamily: fontProvider.fontFamily,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),

                if (!isCompact) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // التدبر (عرض جزئي)
                  Text(
                    '💭 ${verse.reflection}',
                    style: AppTextStyles.reflectionText(
                      isDark: isDark,
                      sizeMultiplier: sizeMultiplier * 0.9,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ],

                // الأزرار السفلية
                if (showActions && onTap != null) ...[
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: onTap,
                      style: TextButton.styleFrom(
                        foregroundColor: categoryColor,
                      ),
                      child: const Text('التفاصيل والتدبر'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// بطاقة آية صغيرة (للقوائم)
class CompactVerseCard extends StatelessWidget {
  final VerseModel verse;
  final VoidCallback onTap;

  const CompactVerseCard({
    super.key,
    required this.verse,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoryColor = AppColors.getCategoryColor(verse.mainCategory);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () {
          AppHelpers.lightHaptic();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // أيقونة الفئة
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    AppHelpers.getCategoryIcon(verse.mainCategory),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // محتوى الآية
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      verse.verseText,
                      style: AppTextStyles.bodyText(isDark: isDark).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${verse.surah} • ${verse.mainCategory}',
                      style: AppTextStyles.caption(isDark: isDark).copyWith(
                        color: categoryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // المفضلة
              FavoriteButton(
                verse: verse,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
