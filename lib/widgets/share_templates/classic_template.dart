import 'package:flutter/material.dart';
import '../../models/verse_model.dart';
import '../../theme/app_colors.dart';

/// قالب كلاسيكي للمشاركة
class ClassicTemplate extends StatelessWidget {
  final VerseModel verse;
  final Color backgroundColor;
  final Color textColor;
  final String fontFamily;

  const ClassicTemplate({
    super.key,
    required this.verse,
    this.backgroundColor = AppColors.backgroundLight,
    this.textColor = AppColors.textPrimary,
    this.fontFamily = 'Amiri',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1080,
      height: 1920,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: AppColors.primaryGreen,
          width: 8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // الزخرفة العلوية
            _buildTopDecoration(),

            const SizedBox(height: 60),

            // البسملة
            Text(
              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: 48,
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 80),

            // نص الآية
            Container(
              padding: const EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.05),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppColors.primaryGreen.withOpacity(0.3),
                  width: 3,
                ),
              ),
              child: Text(
                verse.verseText,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 72,
                  height: 2.2,
                  color: textColor,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),

            const SizedBox(height: 40),

            // التدبر
            if (verse.reflection.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primaryGold.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Text(
                  '💭 ${verse.reflection}',
                  style: const TextStyle(
                    fontFamily: 'IBMPlexArabic',
                    fontSize: 32,
                    height: 1.8,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            const SizedBox(height: 30),

            // الدعاء
            if (verse.dua.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '☝️ ${verse.dua}',
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 36,
                    height: 1.8,
                    color: AppColors.primaryGreen,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            const SizedBox(height: 40),

            // معلومات السورة
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              decoration: BoxDecoration(
                color: AppColors.primaryGold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                '﴿ ${verse.surah} ﴾',
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 36,
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Spacer(),

            // الزخرفة السفلية
            _buildBottomDecoration(),

            const SizedBox(height: 40),

            // شعار التطبيق
            _buildAppLogo(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopDecoration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDecorativeLine(),
        const SizedBox(width: 30),
        Text(
          '✦',
          style: TextStyle(
            fontSize: 50,
            color: AppColors.primaryGold,
          ),
        ),
        const SizedBox(width: 30),
        _buildDecorativeLine(),
      ],
    );
  }

  Widget _buildBottomDecoration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDecorativeLine(),
        const SizedBox(width: 30),
        Text(
          '✦',
          style: TextStyle(
            fontSize: 50,
            color: AppColors.primaryGold,
          ),
        ),
        const SizedBox(width: 30),
        _buildDecorativeLine(),
      ],
    );
  }

  Widget _buildDecorativeLine() {
    return Container(
      width: 200,
      height: 4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen.withOpacity(0),
            AppColors.primaryGold,
            AppColors.primaryGreen.withOpacity(0),
          ],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Column(
      children: [
        Text(
          'نور آية',
          style: TextStyle(
            fontFamily: 'IBMPlexArabic',
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'من كل آية.. نور وهداية',
          style: TextStyle(
            fontFamily: 'IBMPlexArabic',
            fontSize: 32,
            color: AppColors.primaryGold,
          ),
        ),
      ],
    );
  }
}
