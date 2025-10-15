import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/verse_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/helpers.dart';
import '../widgets/verse_card.dart';
import '../widgets/empty_state.dart';
import 'verse_details_screen.dart';

/// شاشة عرض آيات حسب الفئة
class CategoryVersesScreen extends StatelessWidget {
  final String category;

  const CategoryVersesScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final verseProvider = context.watch<VerseProvider>();
    final verses = verseProvider.getVersesByCategory(category);
    final categoryColor = AppColors.getCategoryColor(category);
    final categoryIcon = AppHelpers.getCategoryIcon(category);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(categoryIcon),
            const SizedBox(width: 8),
            Text(category),
          ],
        ),
        backgroundColor: categoryColor,
      ),
      body: verses.isEmpty
          ? EmptyState(
              icon: Icons.search_off,
              message: 'لا توجد آيات في هذه الفئة',
              subtitle: 'جرّب البحث في فئات أخرى',
              onAction: () => Navigator.pop(context),
              actionText: 'رجوع للفئات',
            )
          : Column(
              children: [
                // معلومات الفئة
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.1),
                    border: Border(
                      bottom: BorderSide(
                        color: categoryColor.withOpacity(0.3),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.book, color: categoryColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${verses.length} آية في هذه الفئة',
                        style: AppTextStyles.bodyText(isDark: isDark).copyWith(
                          color: categoryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // قائمة الآيات
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: verses.length,
                    itemBuilder: (context, index) {
                      final verse = verses[index];
                      return CompactVerseCard(
                        verse: verse,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VerseDetailsScreen(verse: verse),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
