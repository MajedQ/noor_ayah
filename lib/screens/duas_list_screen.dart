import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dua_model.dart';
import '../providers/dua_provider.dart';
import '../widgets/dua_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'dua_details_screen.dart';

/// شاشة قائمة جميع الأدعية
class DuasListScreen extends StatefulWidget {
  const DuasListScreen({super.key});

  @override
  State<DuasListScreen> createState() => _DuasListScreenState();
}

class _DuasListScreenState extends State<DuasListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DuaCategory? _selectedCategory;
  DuaOccasion? _selectedOccasion;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToDuaDetails(DuaModel dua) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DuaDetailsScreen(dua: dua),
      ),
    );
  }

  List<DuaModel> _getFilteredDuas(DuaProvider duaProvider) {
    List<DuaModel> duas;

    // تطبيق فلتر البحث
    if (_searchQuery.isNotEmpty) {
      duaProvider.searchDuas(_searchQuery);
      duas = duaProvider.searchResults;
    } else {
      duas = duaProvider.allDuas;
    }

    // تطبيق فلتر الفئة
    if (_selectedCategory != null) {
      duas = duas.where((d) => d.category == _selectedCategory).toList();
    }

    // تطبيق فلتر المناسبة
    if (_selectedOccasion != null) {
      duas = duas.where((d) => d.occasion == _selectedOccasion).toList();
    }

    return duas;
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
          child: Column(
            children: [
              // App Bar
              _buildAppBar(context, isDark),

              // شريط البحث
              _buildSearchBar(context),

              // التبويبات
              _buildTabBar(context, isDark),

              // المحتوى
              Expanded(
                child: Consumer<DuaProvider>(
                  builder: (context, duaProvider, child) {
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        // كل الأدعية
                        _buildAllDuasTab(duaProvider),

                        // حسب الفئة
                        _buildCategoriesTab(duaProvider),

                        // حسب المناسبة
                        _buildOccasionsTab(duaProvider),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(context).appBarTheme.backgroundColor
            : AppColors.primaryGreen,
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
              'جميع الأدعية',
              style: AppTextStyles.heading2(isDark: isDark).copyWith(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // للتوازن
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'ابحث في الأدعية...',
          prefixIcon: Icon(Icons.search, color: AppColors.primaryGreen),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: AppColors.primaryGreen.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: AppColors.primaryGreen.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, bool isDark) {
    return Container(
      color: isDark ? Theme.of(context).cardColor : Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primaryGreen,
        unselectedLabelColor: Colors.grey,
        indicatorColor: AppColors.primaryGreen,
        tabs: const [
          Tab(text: 'الكل'),
          Tab(text: 'الفئات'),
          Tab(text: 'المناسبات'),
        ],
      ),
    );
  }

  Widget _buildAllDuasTab(DuaProvider duaProvider) {
    final duas = _getFilteredDuas(duaProvider);

    if (duas.isEmpty) {
      return _buildEmptyState('لا توجد أدعية');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: duas.length,
      itemBuilder: (context, index) {
        final dua = duas[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DuaCard(
            dua: dua,
            isCompact: true,
            onTap: () => _navigateToDuaDetails(dua),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesTab(DuaProvider duaProvider) {
    if (_selectedCategory == null) {
      return _buildCategoryGrid(duaProvider);
    } else {
      return _buildCategoryDuasList(duaProvider);
    }
  }

  Widget _buildCategoryGrid(DuaProvider duaProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = duaProvider.getAllCategories();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final count = duaProvider.getDuasByCategory(category).length;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppColors.primaryGreen.withOpacity(0.1),
                    AppColors.primaryGold.withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category.icon,
                    style: const TextStyle(fontSize: 40),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.displayName,
                    style: AppTextStyles.heading3(isDark: isDark).copyWith(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count ${count == 1 ? "دعاء" : "أدعية"}',
                    style: AppTextStyles.caption(isDark: isDark).copyWith(
                      fontSize: 12,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryDuasList(DuaProvider duaProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final duas = duaProvider.getDuasByCategory(_selectedCategory!);

    return Column(
      children: [
        // Header للفئة المختارة
        Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.primaryGreen.withOpacity(0.1),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedCategory = null;
                  });
                },
              ),
              Text(
                _selectedCategory!.icon,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _selectedCategory!.displayName,
                  style: AppTextStyles.heading2(isDark: isDark)
                      .copyWith(fontSize: 18),
                ),
              ),
              Text(
                '${duas.length} ${duas.length == 1 ? "دعاء" : "أدعية"}',
                style: AppTextStyles.caption(isDark: isDark),
              ),
            ],
          ),
        ),

        // قائمة الأدعية
        Expanded(
          child: duas.isEmpty
              ? _buildEmptyState('لا توجد أدعية في هذه الفئة')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: duas.length,
                  itemBuilder: (context, index) {
                    final dua = duas[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DuaCard(
                        dua: dua,
                        isCompact: true,
                        onTap: () => _navigateToDuaDetails(dua),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildOccasionsTab(DuaProvider duaProvider) {
    if (_selectedOccasion == null) {
      return _buildOccasionGrid(duaProvider);
    } else {
      return _buildOccasionDuasList(duaProvider);
    }
  }

  Widget _buildOccasionGrid(DuaProvider duaProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final occasions = duaProvider.getAllOccasions();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: occasions.length,
      itemBuilder: (context, index) {
        final occasion = occasions[index];
        final count = duaProvider.getDuasByOccasion(occasion).length;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedOccasion = occasion;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppColors.primaryGold.withOpacity(0.2),
                    AppColors.primaryGreen.withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    occasion.icon,
                    style: const TextStyle(fontSize: 40),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    occasion.displayName,
                    style: AppTextStyles.heading3(isDark: isDark).copyWith(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count ${count == 1 ? "دعاء" : "أدعية"}',
                    style: AppTextStyles.caption(isDark: isDark).copyWith(
                      fontSize: 12,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOccasionDuasList(DuaProvider duaProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final duas = duaProvider.getDuasByOccasion(_selectedOccasion!);

    return Column(
      children: [
        // Header للمناسبة المختارة
        Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.primaryGold.withOpacity(0.1),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedOccasion = null;
                  });
                },
              ),
              Text(
                _selectedOccasion!.icon,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _selectedOccasion!.displayName,
                  style: AppTextStyles.heading2(isDark: isDark)
                      .copyWith(fontSize: 18),
                ),
              ),
              Text(
                '${duas.length} ${duas.length == 1 ? "دعاء" : "أدعية"}',
                style: AppTextStyles.caption(isDark: isDark),
              ),
            ],
          ),
        ),

        // قائمة الأدعية
        Expanded(
          child: duas.isEmpty
              ? _buildEmptyState('لا توجد أدعية في هذه المناسبة')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: duas.length,
                  itemBuilder: (context, index) {
                    final dua = duas[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DuaCard(
                        dua: dua,
                        isCompact: true,
                        onTap: () => _navigateToDuaDetails(dua),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.heading2(isDark: isDark).copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
