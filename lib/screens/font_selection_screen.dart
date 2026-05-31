import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/font_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// شاشة اختيار خط الآيات القرآنية
class FontSelectionScreen extends StatelessWidget {
  const FontSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fontProvider = context.watch<FontProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('خط الآيات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // رسالة تعليمية
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.brandSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'اختر الخط المفضل لعرض الآيات',
                        style: AppTextStyles.bodyText(isDark: isDark).copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'جميع الخطوط تدعم التشكيل الكامل للآيات القرآنية',
                    style: AppTextStyles.caption(isDark: isDark),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // قائمة الخطوط
          ...QuranicFont.values.map((font) {
            return _buildFontCard(
              context,
              font,
              fontProvider,
              isDark,
            );
          }),

          const SizedBox(height: 16),

          // ملاحظة حول تحميل الخطوط
          Card(
            color: AppColors.warning.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.download,
                        color: AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ملاحظة مهمة',
                        style: AppTextStyles.bodyText(isDark: isDark).copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'بعض الخطوط قد لا تعمل بشكل صحيح إذا لم يتم تحميلها. '
                    'يرجى الرجوع إلى ملف README في مجلد assets/fonts/ لتحميل الخطوط المطلوبة.',
                    style: AppTextStyles.caption(isDark: isDark),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFontCard(
    BuildContext context,
    QuranicFont font,
    FontProvider fontProvider,
    bool isDark,
  ) {
    final isSelected = fontProvider.selectedFont == font;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: isSelected ? 4 : 1,
        child: InkWell(
          onTap: () => fontProvider.setFont(font),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(
                      color: AppColors.brandPrimary,
                      width: 2,
                    )
                  : null,
              color:
                  isSelected ? AppColors.brandPrimary.withOpacity(0.05) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم الخط
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          font.displayName,
                          style:
                              AppTextStyles.heading3(isDark: isDark).copyWith(
                            color: isSelected ? AppColors.brandPrimary : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          font.displayNameEnglish,
                          style: AppTextStyles.caption(isDark: isDark),
                        ),
                      ],
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: AppColors.brandPrimary,
                        size: 28,
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // الوصف
                Text(
                  font.description,
                  style: AppTextStyles.caption(isDark: isDark),
                ),

                const SizedBox(height: 16),

                // معاينة الخط
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.backgroundDark
                        : AppColors.veryLightGreen,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.brandPrimary.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        QuranicFontExtension.sampleVerse,
                        style: TextStyle(
                          fontFamily: font.fontFamily,
                          fontSize: 24,
                          height: 2.0,
                          color: isDark
                              ? AppColors.textDarkMode
                              : AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'رَبَّنَا آتِنَا مِن لَّدُنكَ رَحْمَةً وَهَيِّئْ لَنَا مِنْ أَمْرِنَا رَشَدًا',
                        style: TextStyle(
                          fontFamily: font.fontFamily,
                          fontSize: 20,
                          height: 1.8,
                          color: isDark
                              ? AppColors.textDarkMode
                              : AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
