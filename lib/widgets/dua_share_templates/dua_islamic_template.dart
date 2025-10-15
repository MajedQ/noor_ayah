import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../models/dua_model.dart';
import '../../theme/app_colors.dart';

/// قالب إسلامي بزخارف تراثية لمشاركة الأدعية
class DuaIslamicTemplate extends StatelessWidget {
  final DuaModel dua;

  const DuaIslamicTemplate({
    super.key,
    required this.dua,
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
            const Color(0xFF0A3D2C), // أخضر إسلامي داكن
            AppColors.darkGreen,
            const Color(0xFF1A5C3E),
          ],
        ),
      ),
      child: Stack(
        children: [
          // نجوم متلألئة
          _buildStars(),

          // زخارف إسلامية
          _buildIslamicDecorations(),

          // المحتوى
          Padding(
            padding: const EdgeInsets.all(80),
            child: Column(
              children: [
                const SizedBox(height: 100),

                // هلال وأيقونة
                _buildTopDecoration(),

                const SizedBox(height: 80),

                // المحتوى الرئيسي
                Expanded(
                  child: Center(
                    child: _buildMainContent(),
                  ),
                ),

                // الفوتر
                _buildFooter(),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStars() {
    return Stack(
      children: List.generate(30, (index) {
        final random = math.Random(index);
        return Positioned(
          top: random.nextDouble() * 1920,
          left: random.nextDouble() * 1080,
          child: Icon(
            Icons.star,
            color: AppColors.primaryGold
                .withOpacity(0.3 + random.nextDouble() * 0.4),
            size: 15 + random.nextDouble() * 25,
          ),
        );
      }),
    );
  }

  Widget _buildIslamicDecorations() {
    return Stack(
      children: [
        // زخرفة علوية
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                colors: [
                  AppColors.primaryGold.withOpacity(0.15),
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),

        // زخرفة سفلية
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryGold.withOpacity(0.15),
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopDecoration() {
    return Column(
      children: [
        // هلال ذهبي
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.primaryGold,
                AppColors.darkGold,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGold.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '🌙',
              style: const TextStyle(fontSize: 60),
            ),
          ),
        ),

        const SizedBox(height: 30),

        // خط ذهبي زخرفي
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGoldenLine(width: 150),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                dua.category.icon,
                style: const TextStyle(fontSize: 40),
              ),
            ),
            _buildGoldenLine(width: 150),
          ],
        ),
      ],
    );
  }

  Widget _buildGoldenLine({required double width}) {
    return Container(
      height: 2,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.primaryGold,
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.3),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGold.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // العنوان
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryGold.withOpacity(0.3),
                  AppColors.primaryGold.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.primaryGold.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Text(
              dua.title,
              style: const TextStyle(
                fontFamily: 'IBMPlexArabic',
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 50),

          // نص الدعاء
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: AppColors.primaryGold.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Text(
              dua.duaText,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 48,
                height: 2.2,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 40),

          // المصدر
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryGold.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_stories,
                  color: AppColors.primaryGold,
                  size: 30,
                ),
                const SizedBox(width: 12),
                Text(
                  dua.source,
                  style: const TextStyle(
                    fontFamily: 'IBMPlexArabic',
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        // خط زخرفي
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGoldenLine(width: 200),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.mosque,
                color: AppColors.primaryGold,
                size: 35,
              ),
            ),
            _buildGoldenLine(width: 200),
          ],
        ),

        const SizedBox(height: 25),

        // اسم التطبيق
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryGold.withOpacity(0.3),
                AppColors.primaryGold.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: AppColors.primaryGold.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Column(
            children: const [
              Text(
                'نور آية',
                style: TextStyle(
                  fontFamily: 'IBMPlexArabic',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'من كل آية.. نور وهداية',
                style: TextStyle(
                  fontFamily: 'IBMPlexArabic',
                  fontSize: 24,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
