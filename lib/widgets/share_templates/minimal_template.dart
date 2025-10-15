import 'package:flutter/material.dart';
import '../../models/verse_model.dart';
import '../../theme/app_colors.dart';

/// قالب بسيط وأنيق للمشاركة
class MinimalTemplate extends StatelessWidget {
  final VerseModel verse;
  final Color backgroundColor;
  final Color accentColor;
  final String fontFamily;

  const MinimalTemplate({
    super.key,
    required this.verse,
    this.backgroundColor = Colors.white,
    this.accentColor = AppColors.primaryGreen,
    this.fontFamily = 'Amiri',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1080,
      height: 1920,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),

            // نص الآية
            Text(
              verse.verseText,
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: 78,
                height: 2.3,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),

            const SizedBox(height: 80),

            // خط فاصل بسيط
            Container(
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 30),

            // التدبر (مختصر)
            if (verse.reflection.isNotEmpty)
              Text(
                verse.reflection,
                style: const TextStyle(
                  fontFamily: 'IBMPlexArabic',
                  fontSize: 26,
                  height: 1.5,
                  color: Color(0xFF666666),
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

            const SizedBox(height: 30),

            // اسم السورة
            Text(
              verse.surah,
              style: TextStyle(
                fontFamily: 'IBMPlexArabic',
                fontSize: 40,
                color: accentColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            // الشعار السفلي
            Column(
              children: [
                Text(
                  'نور آية',
                  style: TextStyle(
                    fontFamily: 'IBMPlexArabic',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'من كل آية.. نور وهداية',
                  style: TextStyle(
                    fontFamily: 'IBMPlexArabic',
                    fontSize: 28,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
