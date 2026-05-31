import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/theme_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/verse_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/font_provider.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';
import '../theme/theme_colors.dart';
import '../utils/constants.dart';
import 'language_settings_screen.dart';
import 'font_selection_screen.dart';
import 'notification_settings_screen.dart';
import 'achievements_screen.dart';
import 'sync_screen.dart';

/// شاشة الإعدادات
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();
    final verseProvider = context.watch<VerseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // معلومات التطبيق
          _buildAppInfo(isDark),

          const Divider(height: 32),

          // الإعدادات العامة
          _buildSection(
            title: 'المظهر',
            icon: Icons.palette_outlined,
            isDark: isDark,
            children: [
              _buildThemeToggle(context, themeProvider, isDark),
              _buildColorThemeSetting(context, themeProvider, isDark),
              _buildFontSizeSetting(context, themeProvider, isDark),
              _buildVerseFontSetting(context, isDark),
              _buildLanguageSetting(context, isDark),
            ],
          ),

          const Divider(height: 32),

          // الإشعارات والإنجازات
          _buildSection(
            title: 'الإشعارات والإنجازات',
            icon: Icons.notifications_outlined,
            isDark: isDark,
            children: [
              _buildNotificationsSetting(context, isDark),
              _buildAchievementsSetting(context, isDark),
            ],
          ),

          const Divider(height: 32),

          // المزامنة والتحديث
          _buildSection(
            title: 'المزامنة والتحديث',
            icon: Icons.cloud_sync_outlined,
            isDark: isDark,
            children: [
              _buildListTile(
                icon: Icons.sync,
                title: 'مزامنة المحتوى',
                subtitle: 'تحديث الآيات والأدعية من السيرفر',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SyncScreen(),
                    ),
                  );
                },
                isDark: isDark,
              ),
            ],
          ),

          const Divider(height: 32),

          // الإحصائيات
          _buildSection(
            title: 'الإحصائيات',
            icon: Icons.bar_chart,
            isDark: isDark,
            children: [
              _buildStatTile(
                icon: Icons.book,
                label: 'إجمالي الآيات',
                value: '${verseProvider.totalVersesCount}',
                color: AppColors.primaryGreen,
                isDark: isDark,
              ),
              _buildStatTile(
                icon: Icons.category,
                label: 'عدد الفئات',
                value: '${verseProvider.categoriesCount}',
                color: AppColors.primaryGold,
                isDark: isDark,
              ),
              _buildStatTile(
                icon: Icons.favorite,
                label: 'الآيات المفضلة',
                value: '${favoritesProvider.favoritesCount}',
                color: AppColors.favoriteIcon,
                isDark: isDark,
              ),
            ],
          ),

          const Divider(height: 32),

          // عن التطبيق
          _buildSection(
            title: 'عن التطبيق',
            icon: Icons.info_outline,
            isDark: isDark,
            children: [
              _buildListTile(
                icon: Icons.share,
                title: 'مشاركة التطبيق',
                onTap: () => _shareApp(),
                isDark: isDark,
              ),
              _buildListTile(
                icon: Icons.star_outline,
                title: 'تقييم التطبيق',
                onTap: () => _rateApp(context),
                isDark: isDark,
              ),
              _buildListTile(
                icon: Icons.policy_outlined,
                title: 'سياسة الخصوصية',
                onTap: () => _showPrivacyPolicy(context),
                isDark: isDark,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // نسخة التطبيق
          Center(
            child: Text(
              'الإصدار ${AppConstants.appVersion}',
              style: AppTextStyles.caption(isDark: isDark),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAppInfo(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryGreen.withOpacity(0.1),
              border: Border.all(
                color: AppColors.primaryGreen,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/icon/app_icon_64.png',
                width: 94,
                height: 94,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppConstants.appName,
            style: AppTextStyles.heading1(isDark: isDark).copyWith(
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppConstants.appSlogan,
            style: AppTextStyles.bodyText(isDark: isDark).copyWith(
              color: AppColors.primaryGold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            AppConstants.appDescription,
            style: AppTextStyles.caption(isDark: isDark),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.heading3(isDark: isDark).copyWith(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildThemeToggle(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isDark,
  ) {
    return SwitchListTile(
      secondary: Icon(
        isDark ? Icons.dark_mode : Icons.light_mode,
        color: AppColors.primaryGreen,
      ),
      title: const Text('الوضع الليلي'),
      subtitle: Text(
        isDark ? 'مُفعّل' : 'غير مُفعّل',
        style: AppTextStyles.caption(isDark: isDark),
      ),
      value: isDark,
      onChanged: (value) {
        themeProvider.toggleTheme();
      },
    );
  }

  Widget _buildColorThemeSetting(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isDark,
  ) {
    final l10n = AppLocalizations.of(context);
    final colors = ThemeColors(themeProvider.colorTheme);

    return ListTile(
      leading: Icon(
        Icons.color_lens,
        color: colors.primary,
      ),
      title: Text(l10n?.colorTheme ?? 'ثيم الألوان'),
      subtitle: Text(
        _getThemeDisplayName(context, themeProvider.colorTheme),
        style: AppTextStyles.caption(isDark: isDark),
      ),
      // معاينة لونية مصغّرة للثيم النشط
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _miniSwatch(colors.primary),
          const SizedBox(width: 4),
          _miniSwatch(colors.secondary),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () => _showColorThemeDialog(context, themeProvider),
    );
  }

  Widget _miniSwatch(Color color) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildFontSizeSetting(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isDark,
  ) {
    return ListTile(
      leading: const Icon(
        Icons.format_size,
        color: AppColors.primaryGreen,
      ),
      title: const Text('حجم الخط'),
      subtitle: Text(
        themeProvider.fontSize.displayName,
        style: AppTextStyles.caption(isDark: isDark),
      ),
      onTap: () => _showFontSizeDialog(context, themeProvider),
    );
  }

  Widget _buildVerseFontSetting(BuildContext context, bool isDark) {
    final fontProvider = context.watch<FontProvider>();

    return ListTile(
      leading: const Icon(
        Icons.font_download,
        color: AppColors.primaryGreen,
      ),
      title: const Text('خط الآيات'),
      subtitle: Text(
        fontProvider.selectedFont.displayName,
        style: AppTextStyles.caption(isDark: isDark),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const FontSelectionScreen(),
          ),
        );
      },
    );
  }

  Widget _buildLanguageSetting(BuildContext context, bool isDark) {
    final localeProvider = context.watch<LocaleProvider>();
    final currentLanguage = localeProvider.getLanguageName(
      localeProvider.locale.languageCode,
    );
    final flag = localeProvider.getLanguageFlag(
      localeProvider.locale.languageCode,
    );

    return ListTile(
      leading: const Icon(
        Icons.language,
        color: AppColors.primaryGreen,
      ),
      title: const Text('اللغة • Language'),
      subtitle: Text(
        '$flag $currentLanguage',
        style: AppTextStyles.caption(isDark: isDark),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const LanguageSettingsScreen(),
          ),
        );
      },
    );
  }

  Widget _buildNotificationsSetting(BuildContext context, bool isDark) {
    return ListTile(
      leading: const Icon(
        Icons.notifications,
        color: AppColors.primaryGreen,
      ),
      title: const Text('الإشعارات اليومية'),
      subtitle: Text(
        'استلم آية يومياً في الوقت المحدد',
        style: AppTextStyles.caption(isDark: isDark),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const NotificationSettingsScreen(),
          ),
        );
      },
    );
  }

  Widget _buildAchievementsSetting(BuildContext context, bool isDark) {
    return ListTile(
      leading: const Icon(
        Icons.emoji_events,
        color: AppColors.primaryGold,
      ),
      title: const Text('الإنجازات'),
      subtitle: Text(
        'تتبع تقدمك واحصل على الإنجازات',
        style: AppTextStyles.caption(isDark: isDark),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AchievementsScreen(),
          ),
        );
      },
    );
  }

  Widget _buildStatTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(label),
      trailing: Text(
        value,
        style: AppTextStyles.heading3(isDark: isDark).copyWith(
          color: color,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  String _getThemeDisplayName(BuildContext context, AppThemeColor theme) {
    final l10n = AppLocalizations.of(context);
    switch (theme) {
      case AppThemeColor.classic:
        return l10n?.classicTheme ?? theme.displayName;
      case AppThemeColor.night:
        return l10n?.nightTheme ?? theme.displayName;
      case AppThemeColor.rose:
        return l10n?.roseTheme ?? theme.displayName;
      case AppThemeColor.sage:
        return l10n?.sageTheme ?? theme.displayName;
      case AppThemeColor.golden:
        return l10n?.goldenTheme ?? theme.displayName;
      case AppThemeColor.beige:
        return l10n?.beigeTheme ?? theme.displayName;
    }
  }

  String _getThemeDescription(BuildContext context, AppThemeColor theme) {
    final l10n = AppLocalizations.of(context);
    switch (theme) {
      case AppThemeColor.classic:
        return l10n?.classicThemeDesc ?? theme.description;
      case AppThemeColor.night:
        return l10n?.nightThemeDesc ?? theme.description;
      case AppThemeColor.rose:
        return l10n?.roseThemeDesc ?? theme.description;
      case AppThemeColor.sage:
        return l10n?.sageThemeDesc ?? theme.description;
      case AppThemeColor.golden:
        return l10n?.goldenThemeDesc ?? theme.description;
      case AppThemeColor.beige:
        return l10n?.beigeThemeDesc ?? theme.description;
    }
  }

  void _showColorThemeDialog(
    BuildContext context,
    ThemeProvider themeProvider,
  ) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        return AlertDialog(
          title: Text(l10n?.selectColorTheme ?? 'اختر ثيم الألوان'),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: AppThemeColor.values.map((theme) {
                  return _buildThemeOption(
                    context: dialogContext,
                    theme: theme,
                    isSelected: themeProvider.colorTheme == theme,
                    isDark: isDark,
                    onTap: () {
                      themeProvider.setColorTheme(theme);
                      Navigator.pop(dialogContext);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }

  /// عنصر اختيار ثيم مع معاينة لونية مرئية
  Widget _buildThemeOption({
    required BuildContext context,
    required AppThemeColor theme,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final colors = ThemeColors(theme);
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withOpacity(0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? colors.primary
                : (isDark ? Colors.white24 : Colors.black12),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // معاينة لونية (دائرتان متداخلتان)
            SizedBox(
              width: 52,
              height: 36,
              child: Stack(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colors.secondary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getThemeDisplayName(context, theme),
                    style: AppTextStyles.labelText(isDark: isDark).copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getThemeDescription(context, theme),
                    style: AppTextStyles.caption(isDark: isDark)
                        .copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: colors.primary, size: 22)
            else
              Icon(
                Icons.radio_button_unchecked,
                color: isDark ? Colors.white30 : Colors.black26,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  void _showFontSizeDialog(
    BuildContext context,
    ThemeProvider themeProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حجم الخط'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: FontSize.values.map((size) {
            return RadioListTile<FontSize>(
              title: Text(size.displayName),
              value: size,
              groupValue: themeProvider.fontSize,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setFontSize(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _shareApp() async {
    await Share.share(
      'جرّب تطبيق ${AppConstants.appName} - ${AppConstants.appSlogan}\n\nتطبيق تأملي رائع لعرض آيات القرآن الكريم مع التدبر والأدعية.',
      subject: AppConstants.appName,
    );
  }

  void _rateApp(BuildContext context) {
    // يمكن إضافة رابط للمتجر هنا
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('شكراً لاهتمامك! سيتم إضافة رابط التقييم قريباً'),
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('سياسة الخصوصية'),
        content: const SingleChildScrollView(
          child: Text(
            'نحن نحترم خصوصيتك. هذا التطبيق:\n\n'
            '• لا يجمع أي بيانات شخصية\n'
            '• لا يتطلب اتصال بالإنترنت للعمل\n'
            '• جميع البيانات محفوظة محلياً على جهازك\n'
            '• لا نشارك أي معلومات مع أطراف ثالثة\n\n'
            'التطبيق مفتوح المصدر ومجاني بالكامل.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}
