import 'package:flutter/material.dart';
import '../../models/verse_model.dart';
import '../../theme/app_colors.dart';

/// قالب داكن أنيق للمشاركة
class DarkTemplate extends StatelessWidget {
  final VerseModel verse;
  final Color backgroundColor;
  final Color goldColor;
  final String fontFamily;

  const DarkTemplate({
    super.key,
    required this.verse,
    this.backgroundColor = const Color(0xFF1A1A1A),
    this.goldColor = AppColors.primaryGold,
    this.fontFamily = 'Amiri',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1080,
      height: 1920,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            backgroundColor,
            backgroundColor.withOpacity(0.95),
            const Color(0xFF2D2D2D),
          ],
        ),
      ),
      child: Stack(
        children: [
          // نجوم في الخلفية
          ...List.generate(30, (index) {
            return Positioned(
              left: (index * 137) % 1080,
              top: (index * 251) % 1920,
              child: Icon(
                Icons.star,
                size: (index % 3 + 1) * 8.0,
                color: goldColor.withOpacity(0.3),
              ),
            );
          }),

          // المحتوى الرئيسي
          Padding(
            padding: const EdgeInsets.all(60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),

                // رأس البطاقة
                _buildHeader(),

                const SizedBox(height: 100),

                // البطاقة الرئيسية
                Container(
                  padding: const EdgeInsets.all(60),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF2D2D2D),
                        const Color(0xFF1E1E1E),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: goldColor,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: goldColor.withOpacity(0.3),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // البسملة مع توهج
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                goldColor.withOpacity(0.2),
                                goldColor.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            '﷽',
                            style: TextStyle(
                              fontSize: 80,
                              color: goldColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      const SizedBox(height: 70),

                      // نص الآية
                      Text(
                        verse.verseText,
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 70,
                          height: 2.2,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(
                              color: goldColor.withOpacity(0.5),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),

                      const SizedBox(height: 70),

                      // خط فاصل متوهج
                      Container(
                        width: 250,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              goldColor.withOpacity(0),
                              goldColor,
                              goldColor,
                              goldColor.withOpacity(0),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: goldColor.withOpacity(0.6),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),

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
                              color: Color(0xFFE0E0E0),
                            ),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      const SizedBox(height: 30),

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
                              color: goldColor,
                            ),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      const SizedBox(height: 40),

                      // اسم السورة
                      Center(
                        child: Text(
                          '﴿ ${verse.surah} ﴾',
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: 42,
                            color: goldColor,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
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
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            goldColor.withOpacity(0.3),
            goldColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: goldColor.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🌙', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 20),
          Text(
            'نور آية',
            style: TextStyle(
              fontFamily: 'IBMPlexArabic',
              fontSize: 46,
              fontWeight: FontWeight.bold,
              color: goldColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D).withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: goldColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Text(
        'من كل آية.. نور وهداية',
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 34,
          color: goldColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// رسام للنمط الإسلامي البسيط
class IslamicPatternPainter extends CustomPainter {
  final Color color;

  IslamicPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // رسم نمط هندسي إسلامي بسيط
    final spacing = 150.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 40, paint);
        canvas.drawCircle(Offset(x, y), 20, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// رسام للزخرفة الركنية
class OrnamentPainter extends CustomPainter {
  final Color color;
  final bool isLeft;

  OrnamentPainter({required this.color, required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();

    if (isLeft) {
      path.moveTo(0, size.height / 2);
      path.quadraticBezierTo(
        size.width / 3,
        0,
        size.width,
        size.height / 3,
      );
      path.moveTo(0, size.height / 2);
      path.quadraticBezierTo(
        size.width / 3,
        size.height,
        size.width,
        size.height * 2 / 3,
      );
    } else {
      path.moveTo(size.width, size.height / 2);
      path.quadraticBezierTo(
        size.width * 2 / 3,
        0,
        0,
        size.height / 3,
      );
      path.moveTo(size.width, size.height / 2);
      path.quadraticBezierTo(
        size.width * 2 / 3,
        size.height,
        0,
        size.height * 2 / 3,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
