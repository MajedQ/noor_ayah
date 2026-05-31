import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wird_model.dart';
import '../models/verse_model.dart';
import '../models/dua_model.dart';
import '../providers/wird_provider.dart';
import '../providers/verse_provider.dart';
import '../providers/dua_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'verse_details_screen.dart';
import 'dua_details_screen.dart';

/// شاشة الورد اليومي
class DailyWirdScreen extends StatefulWidget {
  const DailyWirdScreen({super.key});

  @override
  State<DailyWirdScreen> createState() => _DailyWirdScreenState();
}

class _DailyWirdScreenState extends State<DailyWirdScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WirdProvider>().init();
    });
  }

  void _showCreateWirdDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateWirdDialog(),
    );
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
          child: Consumer<WirdProvider>(
            builder: (context, wirdProvider, child) {
              if (wirdProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final activeWird = wirdProvider.activeWird;

              if (activeWird == null || activeWird.items.isEmpty) {
                return _buildEmptyState(context, isDark);
              }

              return CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    expandedHeight: 140,
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
                            activeWird.schedule.icon,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            activeWird.title,
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
                      // زر الإعدادات
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: _showCreateWirdDialog,
                        tooltip: 'إعدادات الورد',
                      ),
                    ],
                  ),

                  // إحصائيات الورد
                  SliverToBoxAdapter(
                    child: _buildWirdStats(context, activeWird, isDark),
                  ),

                  // قائمة عناصر الورد
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = activeWird.items[index];
                          return _buildWirdItem(
                            context,
                            activeWird,
                            item,
                            index,
                            isDark,
                          );
                        },
                        childCount: activeWird.items.length,
                      ),
                    ),
                  ),

                  // زر إعادة التعيين
                  if (activeWird.items.every((item) => item.isCompleted))
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _buildResetButton(context, activeWird.id),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateWirdDialog,
        backgroundColor: AppColors.brandPrimary,
        icon: const Icon(Icons.add),
        label: const Text('ورد جديد'),
      ),
    );
  }

  Widget _buildWirdStats(BuildContext context, WirdModel wird, bool isDark) {
    final completionPercentage = (wird.completionPercentage * 100).toInt();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.brandPrimary.withOpacity(0.15),
            AppColors.brandSecondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.brandPrimary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // نسبة الإنجاز
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'التقدم اليومي',
                    style: AppTextStyles.heading3(isDark: isDark).copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${wird.completedCount} من ${wird.items.length}',
                    style: AppTextStyles.caption(isDark: isDark),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: wird.isCompletedToday
                      ? AppColors.brandSecondary.withOpacity(0.2)
                      : AppColors.brandPrimary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  wird.isCompletedToday ? '✓' : '$completionPercentage%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: wird.isCompletedToday
                        ? AppColors.brandSecondary
                        : AppColors.brandPrimary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // شريط التقدم
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: wird.completionPercentage,
              minHeight: 12,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                wird.isCompletedToday
                    ? AppColors.brandSecondary
                    : AppColors.brandPrimary,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // إحصائيات إضافية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: '🔥',
                label: 'أيام متتالية',
                value: '${wird.consecutiveDays}',
                isDark: isDark,
              ),
              Container(width: 1, height: 40, color: Colors.grey[300]),
              _buildStatItem(
                icon: wird.schedule.icon,
                label: 'الوقت',
                value: wird.schedule.displayName,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.heading3(isDark: isDark).copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption(isDark: isDark),
        ),
      ],
    );
  }

  Widget _buildWirdItem(
    BuildContext context,
    WirdModel wird,
    WirdItem item,
    int index,
    bool isDark,
  ) {
    final wirdProvider = context.read<WirdProvider>();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: item.isCompleted ? 0 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () => _navigateToContent(context, item),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: item.isCompleted
                  ? AppColors.brandSecondary.withOpacity(0.1)
                  : (isDark ? theme.colorScheme.surface : Colors.white),
              border: item.isCompleted
                  ? Border.all(
                      color: AppColors.brandSecondary.withOpacity(0.3),
                      width: 2,
                    )
                  : null,
            ),
            child: Row(
              children: [
                // Checkbox
                Checkbox(
                  value: item.isCompleted,
                  onChanged: (value) {
                    wirdProvider.toggleWirdItem(wird.id, item.id);
                  },
                  activeColor: AppColors.brandSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),

                const SizedBox(width: 12),

                // رقم العنصر
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: item.isCompleted
                        ? AppColors.brandSecondary.withOpacity(0.2)
                        : AppColors.brandPrimary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: item.isCompleted
                            ? AppColors.brandSecondary
                            : AppColors.brandPrimary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // المحتوى
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.type == WirdItemType.verse ? '📖' : '🤲',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.title,
                              style: AppTextStyles.heading3(isDark: isDark)
                                  .copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: item.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.content,
                        style: AppTextStyles.bodyText(isDark: isDark).copyWith(
                          fontSize: 14,
                          decoration: item.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // سهم
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetButton(BuildContext context, String wirdId) {
    final wirdProvider = context.read<WirdProvider>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.brandSecondary.withOpacity(0.2),
            AppColors.brandSecondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.brandSecondary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            '🎉',
            style: const TextStyle(fontSize: 50),
          ),
          const SizedBox(height: 16),
          Text(
            'بارك الله فيك!',
            style: AppTextStyles.heading2(isDark: false).copyWith(
              fontSize: 24,
              color: AppColors.brandSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'لقد أتممت وردك اليومي',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              await wirdProvider.resetWird(wirdId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('تم إعادة تعيين الورد لبداية جديدة'),
                    backgroundColor: AppColors.brandPrimary,
                  ),
                );
              }
            },
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة التعيين'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandSecondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '📿',
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 24),
            Text(
              'لم تنشئ ورداً يومياً بعد',
              style: AppTextStyles.heading2(isDark: isDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'أنشئ ورداً يومياً لتتبع تقدمك في القراءة والأذكار',
              style: AppTextStyles.bodyText(isDark: isDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _showCreateWirdDialog,
              icon: const Icon(Icons.add),
              label: const Text('إنشاء ورد يومي'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToContent(BuildContext context, WirdItem item) {
    if (item.type == WirdItemType.verse) {
      final verseProvider = context.read<VerseProvider>();
      final verse = verseProvider.getVerseById(item.contentId);
      if (verse != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerseDetailsScreen(verse: verse),
          ),
        );
      }
    } else {
      final duaProvider = context.read<DuaProvider>();
      final dua = duaProvider.getDuaById(item.contentId);
      if (dua != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DuaDetailsScreen(dua: dua),
          ),
        );
      }
    }
  }
}

/// Dialog لإنشاء ورد جديد
class CreateWirdDialog extends StatefulWidget {
  const CreateWirdDialog({super.key});

  @override
  State<CreateWirdDialog> createState() => _CreateWirdDialogState();
}

class _CreateWirdDialogState extends State<CreateWirdDialog> {
  final _titleController = TextEditingController(text: 'وردي اليومي');
  WirdSchedule _selectedSchedule = WirdSchedule.morning;
  final List<WirdItem> _selectedItems = [];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _createWird() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إضافة عناصر للورد'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final wird = WirdModel(
      id: 'wird_${DateTime.now().millisecondsSinceEpoch}',
      title:
          _titleController.text.isEmpty ? 'وردي اليومي' : _titleController.text,
      items: _selectedItems,
      schedule: _selectedSchedule,
      createdAt: DateTime.now(),
    );

    context.read<WirdProvider>().createWird(wird);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم إنشاء الورد بنجاح'),
        backgroundColor: AppColors.brandPrimary,
      ),
    );
  }

  void _addVerses() {
    showDialog(
      context: context,
      builder: (context) => SelectVersesDialog(
        onSelected: (verses) {
          setState(() {
            for (var verse in verses) {
              _selectedItems.add(WirdItem(
                id: 'item_${DateTime.now().millisecondsSinceEpoch}_${verse.id}',
                type: WirdItemType.verse,
                contentId: verse.id,
                title: verse.surah,
                content: verse.verseText.substring(
                      0,
                      verse.verseText.length > 50 ? 50 : verse.verseText.length,
                    ) +
                    (verse.verseText.length > 50 ? '...' : ''),
              ));
            }
          });
        },
      ),
    );
  }

  void _addDuas() {
    showDialog(
      context: context,
      builder: (context) => SelectDuasDialog(
        onSelected: (duas) {
          setState(() {
            for (var dua in duas) {
              _selectedItems.add(WirdItem(
                id: 'item_${DateTime.now().millisecondsSinceEpoch}_${dua.id}',
                type: WirdItemType.dua,
                contentId: dua.id,
                title: dua.title,
                content: dua.duaText.substring(
                      0,
                      dua.duaText.length > 50 ? 50 : dua.duaText.length,
                    ) +
                    (dua.duaText.length > 50 ? '...' : ''),
              ));
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إنشاء ورد يومي'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // اسم الورد
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'اسم الورد',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // اختيار الوقت
              DropdownButtonFormField<WirdSchedule>(
                value: _selectedSchedule,
                decoration: const InputDecoration(
                  labelText: 'الوقت المفضل',
                  border: OutlineInputBorder(),
                ),
                items: WirdSchedule.values.map((schedule) {
                  return DropdownMenuItem(
                    value: schedule,
                    child: Row(
                      children: [
                        Text(schedule.icon),
                        const SizedBox(width: 8),
                        Text(schedule.displayName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSchedule = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              // العناصر المضافة
              if (_selectedItems.isNotEmpty) ...[
                const Text(
                  'العناصر المضافة:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _selectedItems.length,
                    itemBuilder: (context, index) {
                      final item = _selectedItems[index];
                      return ListTile(
                        dense: true,
                        leading:
                            Text(item.type == WirdItemType.verse ? '📖' : '🤲'),
                        title: Text(
                          item.title,
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            setState(() {
                              _selectedItems.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // أزرار إضافة
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _addVerses,
                      icon: const Icon(Icons.book_outlined),
                      label: const Text('إضافة آيات'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.brandPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _addDuas,
                      icon: const Icon(Icons.mode_comment_outlined),
                      label: const Text('إضافة أدعية'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.brandSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _createWird,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brandPrimary,
          ),
          child: const Text('إنشاء'),
        ),
      ],
    );
  }
}

/// Dialog لاختيار الآيات
class SelectVersesDialog extends StatefulWidget {
  final Function(List<VerseModel>) onSelected;

  const SelectVersesDialog({super.key, required this.onSelected});

  @override
  State<SelectVersesDialog> createState() => _SelectVersesDialogState();
}

class _SelectVersesDialogState extends State<SelectVersesDialog> {
  final List<VerseModel> _selectedVerses = [];

  @override
  Widget build(BuildContext context) {
    final verseProvider = context.watch<VerseProvider>();

    return AlertDialog(
      title: const Text('اختر الآيات'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: ListView.builder(
          itemCount: verseProvider.allVerses.length,
          itemBuilder: (context, index) {
            final verse = verseProvider.allVerses[index];
            final isSelected = _selectedVerses.contains(verse);

            return CheckboxListTile(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedVerses.add(verse);
                  } else {
                    _selectedVerses.remove(verse);
                  }
                });
              },
              title: Text(verse.surah, style: const TextStyle(fontSize: 14)),
              subtitle: Text(
                verse.verseText.substring(
                        0,
                        verse.verseText.length > 40
                            ? 40
                            : verse.verseText.length) +
                    '...',
                style: const TextStyle(fontSize: 12),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSelected(_selectedVerses);
            Navigator.pop(context);
          },
          child: Text('إضافة (${_selectedVerses.length})'),
        ),
      ],
    );
  }
}

/// Dialog لاختيار الأدعية
class SelectDuasDialog extends StatefulWidget {
  final Function(List<DuaModel>) onSelected;

  const SelectDuasDialog({super.key, required this.onSelected});

  @override
  State<SelectDuasDialog> createState() => _SelectDuasDialogState();
}

class _SelectDuasDialogState extends State<SelectDuasDialog> {
  final List<DuaModel> _selectedDuas = [];

  @override
  Widget build(BuildContext context) {
    final duaProvider = context.watch<DuaProvider>();

    return AlertDialog(
      title: const Text('اختر الأدعية'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: ListView.builder(
          itemCount: duaProvider.allDuas.length,
          itemBuilder: (context, index) {
            final dua = duaProvider.allDuas[index];
            final isSelected = _selectedDuas.contains(dua);

            return CheckboxListTile(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedDuas.add(dua);
                  } else {
                    _selectedDuas.remove(dua);
                  }
                });
              },
              title: Text(dua.title, style: const TextStyle(fontSize: 14)),
              subtitle: Text(
                dua.duaText.substring(
                        0, dua.duaText.length > 40 ? 40 : dua.duaText.length) +
                    '...',
                style: const TextStyle(fontSize: 12),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSelected(_selectedDuas);
            Navigator.pop(context);
          },
          child: Text('إضافة (${_selectedDuas.length})'),
        ),
      ],
    );
  }
}
