import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/dua_model.dart';
import '../widgets/dua_share_templates/dua_classic_template.dart';
import '../widgets/dua_share_templates/dua_modern_template.dart';
import '../widgets/dua_share_templates/dua_minimal_template.dart';
import '../widgets/dua_share_templates/dua_islamic_template.dart';
import '../theme/app_colors.dart';

/// أنواع قوالب مشاركة الأدعية
enum DuaShareTemplateType {
  classic,
  modern,
  minimal,
  islamic,
}

extension DuaShareTemplateTypeExtension on DuaShareTemplateType {
  String get displayName {
    switch (this) {
      case DuaShareTemplateType.classic:
        return 'كلاسيكي';
      case DuaShareTemplateType.modern:
        return 'عصري';
      case DuaShareTemplateType.minimal:
        return 'بسيط';
      case DuaShareTemplateType.islamic:
        return 'إسلامي';
    }
  }

  String get icon {
    switch (this) {
      case DuaShareTemplateType.classic:
        return '📜';
      case DuaShareTemplateType.modern:
        return '🎨';
      case DuaShareTemplateType.minimal:
        return '✨';
      case DuaShareTemplateType.islamic:
        return '🕌';
    }
  }
}

/// شاشة معاينة ومشاركة الدعاء كصورة
class DuaSharePreviewScreen extends StatefulWidget {
  final DuaModel dua;

  const DuaSharePreviewScreen({
    super.key,
    required this.dua,
  });

  @override
  State<DuaSharePreviewScreen> createState() => _DuaSharePreviewScreenState();
}

class _DuaSharePreviewScreenState extends State<DuaSharePreviewScreen> {
  DuaShareTemplateType _selectedTemplate = DuaShareTemplateType.classic;
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSharing = false;

  Widget _getTemplateWidget() {
    switch (_selectedTemplate) {
      case DuaShareTemplateType.classic:
        return DuaClassicTemplate(dua: widget.dua);
      case DuaShareTemplateType.modern:
        return DuaModernTemplate(dua: widget.dua);
      case DuaShareTemplateType.minimal:
        return DuaMinimalTemplate(dua: widget.dua);
      case DuaShareTemplateType.islamic:
        return DuaIslamicTemplate(dua: widget.dua);
    }
  }

  Future<void> _shareImage() async {
    setState(() {
      _isSharing = true;
    });

    try {
      // التقاط الصورة
      final imageBytes = await _screenshotController.capture(
        pixelRatio: 2.0, // دقة عالية ولكن معقولة
        delay:
            const Duration(milliseconds: 100), // انتظار قصير للتأكد من التحميل
      );

      if (imageBytes == null) {
        throw Exception('فشل التقاط الصورة');
      }

      // حفظ الصورة مؤقتاً
      final tempDir = await getTemporaryDirectory();
      final file = File(
          '${tempDir.path}/dua_${widget.dua.id}_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(imageBytes);

      // مشاركة الصورة
      await Share.shareXFiles(
        [XFile(file.path)],
        text: '${widget.dua.title}\n${widget.dua.duaText}',
        subject: widget.dua.title,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: $e'),
            backgroundColor: Colors.red,
          ),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.grey[200],
      appBar: AppBar(
        title: const Text('مشاركة كصورة'),
        backgroundColor:
            isDark ? theme.appBarTheme.backgroundColor : AppColors.brandPrimary,
        foregroundColor: Colors.white,
        actions: [
          if (_isSharing)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareImage,
              tooltip: 'مشاركة',
            ),
        ],
      ),
      body: Column(
        children: [
          // معاينة القالب
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        // معاينة مصغرة
                        Transform.scale(
                          scale: 0.3,
                          child: Transform.translate(
                            offset: const Offset(0, 0),
                            child: _getTemplateWidget(),
                          ),
                        ),
                        // Screenshot مخفي للحجم الكامل
                        Positioned(
                          left: -10000, // خارج الشاشة
                          top: -10000,
                          child: Screenshot(
                            controller: _screenshotController,
                            child: _getTemplateWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // شريط اختيار القوالب
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'اختر القالب',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: DuaShareTemplateType.values.map((type) {
                      final isSelected = _selectedTemplate == type;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedTemplate = type;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.brandPrimary
                                  : (isDark
                                      ? AppColors.cardDark
                                      : Colors.grey[200]),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.brandPrimary
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  type.icon,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  type.displayName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark
                                            ? Colors.white
                                            : Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _isSharing ? null : _shareImage,
                  icon: _isSharing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.share),
                  label:
                      Text(_isSharing ? 'جاري المشاركة...' : 'مشاركة الصورة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
