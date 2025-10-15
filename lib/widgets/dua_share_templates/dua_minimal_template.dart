import 'package:flutter/material.dart';
import '../../models/dua_model.dart';
import '../../theme/app_colors.dart';

/// قالب بسيط (Minimalist) لمشاركة الأدعية
class DuaMinimalTemplate extends StatelessWidget {
  final DuaModel dua;

  const DuaMinimalTemplate({
    super.key,
    required this.dua,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1080,
      height: 1920,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 2),

            // الأيقونة
            Center(
              child: Text(
                dua.category.icon,
                style: const TextStyle(fontSize: 80),
              ),
            ),

            const SizedBox(height: 60),

            // نص الدعاء
            Text(
              dua.duaText,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 52,
                height: 2.2,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 80),

            // خط فاصل رفيع
            Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 150),
              color: AppColors.textPrimary.withOpacity(0.2),
            ),

            const SizedBox(height: 40),

            // العنوان
            Text(
              dua.title,
              style: const TextStyle(
                fontFamily: 'IBMPlexArabic',
                fontSize: 36,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // المصدر
            Text(
              dua.source,
              style: TextStyle(
                fontFamily: 'IBMPlexArabic',
                fontSize: 28,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(flex: 3),

            // Footer بسيط
            Column(
              children: [
                // نقطة صغيرة
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(height: 20),

                // اسم التطبيق
                const Text(
                  'نور آية',
                  style: TextStyle(
                    fontFamily: 'IBMPlexArabic',
                    fontSize: 32,
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
