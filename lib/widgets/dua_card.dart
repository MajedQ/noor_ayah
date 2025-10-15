import 'package:flutter/material.dart';
import '../models/dua_model.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';
import '../providers/font_provider.dart';
import '../providers/favorites_provider.dart';
import 'package:provider/provider.dart';

/// بطاقة عرض الدعاء
class DuaCard extends StatelessWidget {
  final DuaModel dua;
  final VoidCallback? onTap;
  final bool showFullContent;
  final bool isCompact;

  const DuaCard({
    super.key,
    required this.dua,
    this.onTap,
    this.showFullContent = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fontProvider = Provider.of<FontProvider>(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(isCompact ? 12 : 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: isDark
                  ? [
                      theme.colorScheme.surface,
                      theme.colorScheme.surface.withOpacity(0.95),
                    ]
                  : [
                      Colors.white,
                      AppColors.lightBeige.withOpacity(0.3),
                    ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // العنوان والأيقونات
              Row(
                children: [
                  // أيقونة الفئة
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primaryGreen.withOpacity(0.2)
                          : AppColors.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      dua.category.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // العنوان
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dua.title,
                          style:
                              AppTextStyles.heading3(isDark: isDark).copyWith(
                            fontSize: isCompact ? 16 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dua.category.displayName,
                          style: AppTextStyles.caption(isDark: isDark).copyWith(
                            color: AppColors.primaryGreen,
                            fontSize: isCompact ? 12 : 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // أيقونة المناسبة
                  if (dua.occasion != DuaOccasion.general)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dua.occasion.icon,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dua.occasion.displayName,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // زر المفضلة
                  Consumer<FavoritesProvider>(
                    builder: (context, favoritesProvider, _) {
                      final isFavorite =
                          favoritesProvider.isDuaFavorite(dua.id);
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                        ),
                        color: isFavorite ? AppColors.primaryGold : Colors.grey,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () async {
                          await favoritesProvider.toggleDuaFavorite(dua);
                        },
                        tooltip:
                            isFavorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // نص الدعاء
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withOpacity(0.2)
                      : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryGreen.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  showFullContent
                      ? dua.duaText
                      : _getTruncatedText(dua.duaText),
                  style: TextStyle(
                    fontFamily: fontProvider.fontFamily,
                    fontSize: isCompact ? 16 : 18,
                    height: 1.8,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: showFullContent ? null : 3,
                  overflow: showFullContent ? null : TextOverflow.ellipsis,
                ),
              ),

              if (showFullContent) ...[
                // الفوائد
                if (dua.benefits != null && dua.benefits!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryGold.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '💡',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            dua.benefits!,
                            style:
                                AppTextStyles.bodyText(isDark: isDark).copyWith(
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // المصدر
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: 16,
                      color: isDark ? AppColors.iconDark : AppColors.iconLight,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        dua.source,
                        style: AppTextStyles.caption(isDark: isDark).copyWith(
                          fontSize: isCompact ? 12 : 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              if (!showFullContent) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // المصدر
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.book_outlined,
                            size: 14,
                            color: isDark
                                ? AppColors.iconDark
                                : AppColors.iconLight,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              dua.source,
                              style: AppTextStyles.caption(isDark: isDark)
                                  .copyWith(
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // زر المزيد
                    if (onTap != null)
                      TextButton.icon(
                        onPressed: onTap,
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: const Text('التفاصيل'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryGreen,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getTruncatedText(String text) {
    const maxLength = 120;
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
