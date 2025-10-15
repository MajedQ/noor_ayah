import 'package:flutter/material.dart';
import '../../models/dua_model.dart';
import '../../theme/app_colors.dart';

/// قالب عصري لمشاركة الأدعية
class DuaModernTemplate extends StatelessWidget {
  final DuaModel dua;

  const DuaModernTemplate({
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGreen,
            AppColors.mediumGreen,
            AppColors.primaryGold.withOpacity(0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          // نمط هندسي في الخلفية
          _buildGeometricPattern(),

          // المحتوى
          Padding(
            padding: const EdgeInsets.all(70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),

                // الهيدر
                _buildHeader(),

                const Spacer(),

                // نص الدعاء
                _buildDuaCard(),

                const Spacer(),

                // الفوتر
                _buildFooter(),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeometricPattern() {
    return Stack(
      children: [
        // دوائر متداخلة
        Positioned(
          top: 100,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 2,
              ),
            ),
          ),
        ),
        Positioned(
          top: 150,
          right: 0,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),

        // مثلثات في الأسفل
        Positioned(
          bottom: -50,
          left: -50,
          child: Transform.rotate(
            angle: 0.5,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العلامة المائية
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dua.category.icon,
                style: const TextStyle(fontSize: 30),
              ),
              const SizedBox(width: 12),
              Text(
                dua.category.displayName,
                style: const TextStyle(
                  fontFamily: 'IBMPlexArabic',
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // العنوان
        Text(
          dua.title,
          style: const TextStyle(
            fontFamily: 'IBMPlexArabic',
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDuaCard() {
    return Container(
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // نص الدعاء
          Text(
            dua.duaText,
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 46,
              height: 2.0,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          // الفوائد إن وجدت
          if (dua.benefits != null && dua.benefits!.isNotEmpty) ...[
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryGold.withOpacity(0.15),
                    AppColors.primaryGold.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Text(
                    '💡',
                    style: TextStyle(fontSize: 35),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      dua.benefits!,
                      style: const TextStyle(
                        fontFamily: 'IBMPlexArabic',
                        fontSize: 28,
                        height: 1.6,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 30),

          // المصدر
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.book_outlined,
                  color: AppColors.primaryGreen,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  dua.source,
                  style: const TextStyle(
                    fontFamily: 'IBMPlexArabic',
                    fontSize: 26,
                    color: AppColors.textSecondary,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🌟',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'نور آية',
                    style: TextStyle(
                      fontFamily: 'IBMPlexArabic',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'من كل آية.. نور وهداية',
                    style: TextStyle(
                      fontFamily: 'IBMPlexArabic',
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
