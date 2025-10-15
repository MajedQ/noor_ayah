import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/verse_provider.dart';
import '../theme/app_text_styles.dart';
import '../utils/constants.dart';
import '../widgets/search_text_field.dart';
import '../widgets/verse_card.dart';
import '../widgets/empty_state.dart';
import 'verse_details_screen.dart';

/// شاشة البحث
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final verseProvider = context.watch<VerseProvider>();
    final searchResults = verseProvider.searchResults;
    final hasSearch = verseProvider.searchQuery.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث'),
      ),
      body: Column(
        children: [
          // حقل البحث
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SearchTextField(
                  onSearch: (query) {
                    verseProvider.searchVerses(query);
                  },
                  hintText: 'ابحث في الآيات، التدبر، أو السور...',
                ),
                const SizedBox(height: 16),
                if (hasSearch && searchResults.isNotEmpty)
                  Text(
                    'تم العثور على ${searchResults.length} نتيجة',
                    style: AppTextStyles.bodyText(isDark: isDark),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),

          // النتائج أو الحالة الفارغة
          Expanded(
            child: _buildContent(verseProvider, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(VerseProvider verseProvider, bool isDark) {
    final hasSearch = verseProvider.searchQuery.isNotEmpty;
    final searchResults = verseProvider.searchResults;

    if (!hasSearch) {
      return const EmptyState(
        icon: Icons.search,
        message: 'ابدأ بالبحث عن آية',
        subtitle: 'يمكنك البحث في نص الآية، التدبر، الدعاء، أو اسم السورة',
      );
    }

    if (searchResults.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off,
        message: AppConstants.noSearchResultsMessage,
        subtitle: 'جرّب كلمات بحث مختلفة',
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final verse = searchResults[index];
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
    );
  }
}
