import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// شاشة إعدادات اللغة
class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localeProvider = context.watch<LocaleProvider>();
    final currentLocale = localeProvider.locale;

    return Scaffold(
      appBar: AppBar(
        title: const Text('اللغة • Language'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: LocaleProvider.supportedLocales.length,
        itemBuilder: (context, index) {
          final locale = LocaleProvider.supportedLocales[index];
          final isSelected = currentLocale.languageCode == locale.languageCode;
          final languageName =
              localeProvider.getLanguageName(locale.languageCode);
          final flag = localeProvider.getLanguageFlag(locale.languageCode);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await localeProvider.setLocale(locale);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.brandPrimary.withOpacity(0.1)
                        : isDark
                            ? AppColors.cardDark
                            : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.brandPrimary
                          : isDark
                              ? AppColors.iconDark.withOpacity(0.3)
                              : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        flag,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          languageName,
                          style:
                              AppTextStyles.bodyText(isDark: isDark).copyWith(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? AppColors.brandPrimary : null,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: AppColors.brandPrimary,
                          size: 28,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
