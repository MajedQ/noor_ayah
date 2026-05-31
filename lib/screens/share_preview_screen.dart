import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/verse_model.dart';
import '../providers/font_provider.dart';
import '../providers/achievements_provider.dart';
import '../services/image_share_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/helpers.dart';
import '../widgets/share_templates/classic_template.dart';
import '../widgets/share_templates/modern_template.dart';
import '../widgets/share_templates/minimal_template.dart';
import '../widgets/share_templates/dark_template.dart';
import '../widgets/share_templates/elegant_template.dart';

/// أنواع القوالب
enum ShareTemplateType {
  classic,
  modern,
  minimal,
  elegant,
  dark,
}

extension ShareTemplateTypeExtension on ShareTemplateType {
  String get displayName {
    switch (this) {
      case ShareTemplateType.classic:
        return 'كلاسيكي';
      case ShareTemplateType.modern:
        return 'عصري';
      case ShareTemplateType.minimal:
        return 'بسيط';
      case ShareTemplateType.elegant:
        return 'أنيق';
      case ShareTemplateType.dark:
        return 'داكن';
    }
  }

  String get icon {
    switch (this) {
      case ShareTemplateType.classic:
        return '📜';
      case ShareTemplateType.modern:
        return '🎨';
      case ShareTemplateType.minimal:
        return '✨';
      case ShareTemplateType.elegant:
        return '💎';
      case ShareTemplateType.dark:
        return '🌙';
    }
  }
}

/// شاشة معاينة ومشاركة الصورة
class SharePreviewScreen extends StatefulWidget {
  final VerseModel verse;

  const SharePreviewScreen({
    super.key,
    required this.verse,
  });

  @override
  State<SharePreviewScreen> createState() => _SharePreviewScreenState();
}

class _SharePreviewScreenState extends State<SharePreviewScreen> {
  ShareTemplateType _selectedTemplate = ShareTemplateType.classic;
  final GlobalKey _captureKey = GlobalKey();
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fontProvider = context.watch<FontProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('مشاركة كصورة'),
        actions: [
          if (!_isSharing)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareImage,
              tooltip: 'مشاركة',
            ),
        ],
      ),
      body: Stack(
        children: [
          // Widget للالتقاط (مخفي خارج الشاشة) - نفس الحجم الأصلي
          Positioned(
            left: -10000,
            top: -10000,
            child: RepaintBoundary(
              key: _captureKey,
              child: SizedBox(
                width: 1080,
                height: 1920,
                child: _buildTemplate(fontProvider.fontFamily),
              ),
            ),
          ),

          // الشاشة المرئية
          Column(
            children: [
              // معاينة الصورة
              Expanded(
                child: Container(
                  color: isDark ? Colors.grey[900] : Colors.grey[200],
                  padding: const EdgeInsets.all(8.0),
                  child: _isSharing
                      ? const Center(child: CircularProgressIndicator())
                      // FittedBox يصغّر القالب مع الإبلاغ عن حجمه المُصغَّر،
                      // فتظهر المعاينة مطابقة تمامًا للصورة التي ستتم مشاركتها.
                      : Center(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: SizedBox(
                              width: 1080,
                              height: 1920,
                              child: _buildTemplate(fontProvider.fontFamily),
                            ),
                          ),
                        ),
                ),
              ),

              // خيارات القوالب
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اختر القالب',
                      style: AppTextStyles.heading3(isDark: isDark),
                    ),
                    const SizedBox(height: 16),

                    // شبكة القوالب
                    GridView.count(
                      crossAxisCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: ShareTemplateType.values.map((template) {
                        return _buildTemplateOption(template, isDark);
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // زر المشاركة
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isSharing ? null : _shareImage,
                        icon: _isSharing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(Icons.share),
                        label: Text(
                            _isSharing ? 'جاري المشاركة...' : 'مشاركة الآن'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: AppColors.brandPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTemplate(String fontFamily) {
    switch (_selectedTemplate) {
      case ShareTemplateType.classic:
        return ClassicTemplate(
          verse: widget.verse,
          fontFamily: fontFamily,
        );
      case ShareTemplateType.modern:
        return ModernTemplate(
          verse: widget.verse,
          fontFamily: fontFamily,
        );
      case ShareTemplateType.minimal:
        return MinimalTemplate(
          verse: widget.verse,
          fontFamily: fontFamily,
        );
      case ShareTemplateType.elegant:
        return ElegantTemplate(
          verse: widget.verse,
          fontFamily: fontFamily,
        );
      case ShareTemplateType.dark:
        return DarkTemplate(
          verse: widget.verse,
          fontFamily: fontFamily,
        );
    }
  }

  Widget _buildTemplateOption(ShareTemplateType template, bool isDark) {
    final isSelected = _selectedTemplate == template;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTemplate = template;
        });
        AppHelpers.selectionHaptic();
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.brandPrimary.withOpacity(0.1)
              : isDark
                  ? AppColors.cardDark
                  : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.brandPrimary : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              template.icon,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              template.displayName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.brandPrimary : null,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.brandPrimary,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareImage() async {
    setState(() {
      _isSharing = true;
    });

    try {
      AppHelpers.mediumHaptic();

      // انتظار بناء الـ Widget
      await Future.delayed(const Duration(milliseconds: 500));

      // التقاط ومشاركة الصورة
      final success = await ImageShareService.captureAndShare(
        key: _captureKey,
        fileName:
            'verse_${widget.verse.id}_${DateTime.now().millisecondsSinceEpoch}',
        text: widget.verse.getFormattedText(),
      );

      if (success && mounted) {
        // تسجيل إنجاز المشاركة
        context.read<AchievementsProvider>().recordShare();

        AppHelpers.showSnackBar(
          context,
          'تمت المشاركة بنجاح ✨',
        );

        // الرجوع للشاشة السابقة
        Navigator.pop(context);
      } else if (mounted) {
        AppHelpers.showSnackBar(
          context,
          'حدث خطأ أثناء المشاركة',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('Error sharing image: $e');
      if (mounted) {
        AppHelpers.showSnackBar(
          context,
          'حدث خطأ أثناء المشاركة',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }
}
