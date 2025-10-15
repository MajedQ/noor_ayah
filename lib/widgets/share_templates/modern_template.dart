import 'package:flutter/material.dart';
import '../../models/verse_model.dart';
import '../../theme/app_colors.dart';

/// قالب عصري للمشاركة مع Gradients
class ModernTemplate extends StatelessWidget {
  final VerseModel verse;
  final Color primaryColor;
  final Color secondaryColor;
  final String fontFamily;

  const ModernTemplate({
    super.key,
    required this.verse,
    this.primaryColor = AppColors.primaryGreen,
    this.secondaryColor = AppColors.primaryGold,
    this.fontFamily = 'Amiri',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1080,
      height: 1920,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor,
            primaryColor.withOpacity(0.8),
            secondaryColor.withOpacity(0.6),
            secondaryColor,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // شعار التطبيق في الأعلى
            _buildHeader(),

            const SizedBox(height: 100),

            // البطاقة الرئيسية
            Container(
              padding: const EdgeInsets.all(60),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // أيقونة زخرفية
                  Text(
                    '﷽',
                    style: TextStyle(
                      fontSize: 80,
                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // نص الآية
                  Text(
                    verse.verseText,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 70,
                      height: 2.0,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),

                  const SizedBox(height: 50),

                  // خط فاصل
                  Container(
                    width: 150,
                    height: 5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withOpacity(0),
                          secondaryColor,
                          primaryColor.withOpacity(0),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),

                  const SizedBox(height: 50),

                  const SizedBox(height: 30),

                  // التدبر
                  if (verse.reflection.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        '💭 ${verse.reflection}',
                        style: const TextStyle(
                          fontFamily: 'IBMPlexArabic',
                          fontSize: 28,
                          height: 1.6,
                          color: Color(0xFF424242),
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  const SizedBox(height: 25),

                  // الدعاء
                  if (verse.dua.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        '☝️ ${verse.dua}',
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 32,
                          height: 1.6,
                          color: primaryColor,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  const SizedBox(height: 35),

                  // اسم السورة
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, secondaryColor],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      '﴿ ${verse.surah} ﴾',
                      style: const TextStyle(
                        fontFamily: 'IBMPlexArabic',
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // الشعار السفلي
            _buildFooter(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.menu_book,
              color: Colors.white,
              size: 35,
            ),
          ),
          const SizedBox(width: 20),
          const Text(
            'نور آية',
            style: TextStyle(
              fontFamily: 'IBMPlexArabic',
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: const Text(
        'من كل آية.. نور وهداية',
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 36,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
