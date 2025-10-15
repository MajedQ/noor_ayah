import 'package:flutter/material.dart';
import '../../models/verse_model.dart';
import '../../theme/app_colors.dart';

/// قالب أنيق مع زخارف إسلامية
class ElegantTemplate extends StatelessWidget {
  final VerseModel verse;
  final Color backgroundColor;
  final Color patternColor;
  final String fontFamily;

  const ElegantTemplate({
    super.key,
    required this.verse,
    this.backgroundColor = AppColors.primaryBeige,
    this.patternColor = AppColors.primaryGreen,
    this.fontFamily = 'Amiri',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1080,
      height: 1920,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Stack(
        children: [
          // نمط الخلفية الزخرفي
          _buildBackgroundPattern(),

          // المحتوى الرئيسي
          Padding(
            padding: const EdgeInsets.all(60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // الإطار الزخرفي
                Container(
                  padding: const EdgeInsets.all(70),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: patternColor,
                      width: 5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: patternColor.withOpacity(0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // زخرفة علوية
                      _buildTopOrnament(),

                      const SizedBox(height: 60),

                      // نص الآية
                      Text(
                        verse.verseText,
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 68,
                          height: 2.2,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),

                      const SizedBox(height: 60),

                      // زخرفة سفلية
                      _buildBottomOrnament(),

                      const SizedBox(height: 50),

                      // معلومات السورة
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 30,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              patternColor,
                              patternColor.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Text(
                          verse.surah,
                          style: const TextStyle(
                            fontFamily: 'IBMPlexArabic',
                            fontSize: 42,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // الشعار السفلي
                _buildLogo(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.05,
        child: CustomPaint(
          painter: IslamicPatternPainter(color: patternColor),
        ),
      ),
    );
  }

  Widget _buildTopOrnament() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildOrnamentCorner(isLeft: true),
        const SizedBox(width: 40),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                patternColor,
                AppColors.primaryGold,
              ],
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
        const SizedBox(width: 40),
        _buildOrnamentCorner(isLeft: false),
      ],
    );
  }

  Widget _buildBottomOrnament() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: index == 2 ? AppColors.primaryGold : patternColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrnamentCorner({required bool isLeft}) {
    return CustomPaint(
      size: const Size(80, 80),
      painter: OrnamentPainter(
        color: patternColor,
        isLeft: isLeft,
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Text(
            'نور آية',
            style: TextStyle(
              fontFamily: 'IBMPlexArabic',
              fontSize: 44,
              fontWeight: FontWeight.bold,
              color: patternColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'من كل آية.. نور وهداية',
            style: TextStyle(
              fontFamily: 'IBMPlexArabic',
              fontSize: 30,
              color: AppColors.primaryGold,
            ),
          ),
        ],
      ),
    );
  }
}

/// رسام للنمط الإسلامي
class IslamicPatternPainter extends CustomPainter {
  final Color color;

  IslamicPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final spacing = 100.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        // رسم نجمة بسيطة
        _drawStar(canvas, Offset(x, y), 30, paint);
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * 3.14159 / 180;
      final x = center.dx + size * (i % 2 == 0 ? 1 : 0.5) * cos(angle);
      final y = center.dy + size * (i % 2 == 0 ? 1 : 0.5) * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double cos(double angle) => angle > 0 ? 1 : -1;
  double sin(double angle) => angle > 0 ? 1 : -1;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// رسام للزخرفة
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
        size.width / 2,
        0,
        size.width,
        size.height / 2,
      );
    } else {
      path.moveTo(size.width, size.height / 2);
      path.quadraticBezierTo(
        size.width / 2,
        0,
        0,
        size.height / 2,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
