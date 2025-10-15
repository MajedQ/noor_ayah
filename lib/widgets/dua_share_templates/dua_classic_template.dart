import 'package:flutter/material.dart';
import '../../models/dua_model.dart';
import '../../theme/app_colors.dart';

/// قالب كلاسيكي لمشاركة الأدعية
class DuaClassicTemplate extends StatelessWidget {
  final DuaModel dua;

  const DuaClassicTemplate({
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
            AppColors.primaryBeige,
            Colors.white,
            AppColors.lightBeige,
          ],
        ),
      ),
      child: Stack(
        children: [
          // زخارف الخلفية
          _buildBackgroundDecorations(),

          // المحتوى الرئيسي
          Padding(
            padding: const EdgeInsets.all(80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 100),

                // الأيقونة والعنوان
                _buildHeader(),

                const SizedBox(height: 80),

                // نص الدعاء
                _buildDuaText(),

                const SizedBox(height: 60),

                // الفوائد
                if (dua.benefits != null && dua.benefits!.isNotEmpty) ...[
                  _buildBenefits(),
                  const SizedBox(height: 40),
                ],

                const Spacer(),

                // المصدر
                _buildSource(),

                const SizedBox(height: 40),

                // Footer
                _buildFooter(),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        // زخرفة علوية يمنى
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryGold.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // زخرفة سفلية يسرى
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryGreen.withOpacity(0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // إطار ذهبي
        Positioned.fill(
          child: Container(
            margin: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primaryGold.withOpacity(0.3),
                width: 3,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),

        // إطار داخلي
        Positioned.fill(
          child: Container(
            margin: const EdgeInsets.all(50),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primaryGold.withOpacity(0.15),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // أيقونة الفئة
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGold.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Text(
              dua.category.icon,
              style: const TextStyle(fontSize: 60),
            ),
          ),
        ),

        const SizedBox(height: 30),

        // العنوان
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.primaryGold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryGold.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Text(
            dua.title,
            style: const TextStyle(
              fontFamily: 'IBMPlexArabic',
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 20),

        // الفئة
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            dua.category.displayName,
            style: TextStyle(
              fontFamily: 'IBMPlexArabic',
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryGreen,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildDuaText() {
    return Container(
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.2),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // علامة اقتباس علوية
          Text(
            '﴿',
            style: TextStyle(
              fontSize: 60,
              color: AppColors.primaryGold.withOpacity(0.4),
              height: 0.5,
            ),
          ),

          const SizedBox(height: 20),

          // نص الدعاء
          Text(
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

          const SizedBox(height: 20),

          // علامة اقتباس سفلية
          Text(
            '﴾',
            style: TextStyle(
              fontSize: 60,
              color: AppColors.primaryGold.withOpacity(0.4),
              height: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefits() {
    return Container(
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGold.withOpacity(0.15),
            AppColors.primaryGold.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💡',
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              dua.benefits!,
              style: const TextStyle(
                fontFamily: 'IBMPlexArabic',
                fontSize: 32,
                height: 1.8,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSource() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_rounded,
            color: AppColors.primaryGreen,
            size: 36,
          ),
          const SizedBox(width: 15),
          Text(
            dua.source,
            style: const TextStyle(
              fontFamily: 'IBMPlexArabic',
              fontSize: 30,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        // خط فاصل
        Container(
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 100),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.primaryGold.withOpacity(0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // اسم التطبيق
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🌟',
              style: const TextStyle(fontSize: 35),
            ),
            const SizedBox(width: 15),
            const Text(
              'نور آية',
              style: TextStyle(
                fontFamily: 'IBMPlexArabic',
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              '🌟',
              style: const TextStyle(fontSize: 35),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // الشعار
        const Text(
          'من كل آية.. نور وهداية',
          style: TextStyle(
            fontFamily: 'IBMPlexArabic',
            fontSize: 26,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
