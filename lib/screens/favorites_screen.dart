import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/verse_provider.dart';
import '../providers/dua_provider.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/verse_card.dart';
import '../widgets/dua_card.dart';
import '../widgets/empty_state.dart';
import 'verse_details_screen.dart';
import 'dua_details_screen.dart';

/// شاشة المفضلة
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المفضلة'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'الآيات', icon: Icon(Icons.book, size: 20)),
              Tab(text: 'الأدعية', icon: Icon(Icons.mode_comment, size: 20)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _VersesTab(),
            _DuasTab(),
          ],
        ),
      ),
    );
  }
}

/// تبويب الآيات المفضلة
class _VersesTab extends StatelessWidget {
  const _VersesTab();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favoritesProvider = context.watch<FavoritesProvider>();
    final verseProvider = context.watch<VerseProvider>();

    final favoriteVerses = favoritesProvider.getFavoriteVerses(
      verseProvider.allVerses,
    );

    return favoriteVerses.isEmpty
        ? const EmptyState(
            icon: Icons.favorite_border,
            message: AppConstants.noFavoritesMessage,
            subtitle: 'ابدأ بإضافة آياتك المفضلة لتظهر هنا',
          )
        : Column(
            children: [
              // عداد المفضلة
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.cardDark
                      : AppColors.favoriteIcon.withOpacity(0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.favoriteIcon.withOpacity(0.3),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: AppColors.favoriteIcon,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'لديك ${favoriteVerses.length} آية مفضلة',
                      style: AppTextStyles.bodyText(isDark: isDark).copyWith(
                        color: AppColors.favoriteIcon,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // قائمة الآيات المفضلة
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: favoriteVerses.length,
                  itemBuilder: (context, index) {
                    final verse = favoriteVerses[index];
                    return Dismissible(
                      key: Key('favorite_${verse.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        color: AppColors.error,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 32,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'حذف',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                      ),
                      onDismissed: (direction) {
                        favoritesProvider.removeFavorite(verse.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تمت الإزالة من المفضلة'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: CompactVerseCard(
                        verse: verse,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VerseDetailsScreen(verse: verse),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}

/// تبويب الأدعية المفضلة
class _DuasTab extends StatelessWidget {
  const _DuasTab();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favoritesProvider = context.watch<FavoritesProvider>();
    final duaProvider = context.watch<DuaProvider>();

    final favoriteDuas = favoritesProvider.getFavoriteDuas(
      duaProvider.allDuas,
    );

    return favoriteDuas.isEmpty
        ? const EmptyState(
            icon: Icons.favorite_border,
            message: 'لا توجد أدعية مفضلة',
            subtitle: 'ابدأ بإضافة أدعيتك المفضلة لتظهر هنا',
          )
        : Column(
            children: [
              // عداد المفضلة
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.cardDark
                      : AppColors.primaryGold.withOpacity(0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.primaryGold.withOpacity(0.3),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: AppColors.primaryGold,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'لديك ${favoriteDuas.length} دعاء مفضل',
                      style: AppTextStyles.bodyText(isDark: isDark).copyWith(
                        color: AppColors.primaryGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // قائمة الأدعية المفضلة
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: favoriteDuas.length,
                  itemBuilder: (context, index) {
                    final dua = favoriteDuas[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: DuaCard(
                        dua: dua,
                        isCompact: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DuaDetailsScreen(dua: dua),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
