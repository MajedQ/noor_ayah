import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/verse_provider.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/category_chip.dart';
import '../widgets/empty_state.dart';
import 'category_verses_screen.dart';

/// شاشة الفئات
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final verseProvider = context.watch<VerseProvider>();
    final categories = verseProvider.getAllCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الفئات'),
      ),
      body: categories.isEmpty
          ? const EmptyState(
              icon: Icons.category_outlined,
              message: 'لا توجد فئات متاحة',
            )
          : Container(
              decoration: BoxDecoration(
                gradient: isDark
                    ? null
                    : LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryGreen.withOpacity(0.05),
                          AppColors.backgroundLight,
                        ],
                      ),
              ),
              child: Column(
                children: [
                  // رأس الصفحة
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      children: [
                        Text(
                          '📚 استكشف الآيات حسب المواضيع',
                          style: AppTextStyles.heading3(isDark: isDark),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'اختر الفئة للوصول إلى الآيات المرتبطة بها',
                          style: AppTextStyles.bodyText(isDark: isDark),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // شبكة الفئات
                  Expanded(
                    child: GridView.builder(
                      padding:
                          const EdgeInsets.all(AppConstants.defaultPadding),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.1,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final count =
                            verseProvider.getVersesByCategory(category).length;

                        return CategoryCard(
                          category: category,
                          count: count,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryVersesScreen(
                                  category: category,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
