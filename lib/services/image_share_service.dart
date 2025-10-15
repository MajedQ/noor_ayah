import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;

/// خدمة المشاركة كصورة
class ImageShareService {
  /// إنشاء صورة من Widget
  static Future<Uint8List?> captureWidget(GlobalKey key) async {
    try {
      // التحقق من أن الـ context موجود
      if (key.currentContext == null) {
        debugPrint('Error: Widget context is null');
        return null;
      }

      final renderObject = key.currentContext!.findRenderObject();
      if (renderObject == null || renderObject is! RenderRepaintBoundary) {
        debugPrint('Error: Invalid render object');
        return null;
      }

      RenderRepaintBoundary boundary = renderObject;

      // التقاط الصورة بدقة عالية
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        debugPrint('Error: Failed to convert image to bytes');
        return null;
      }

      return byteData.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing widget: $e');
      return null;
    }
  }

  /// حفظ الصورة محلياً
  static Future<File?> saveImage(Uint8List imageBytes, String fileName) async {
    try {
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/$fileName.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(imageBytes);

      debugPrint('✅ تم حفظ الصورة: $imagePath');
      return imageFile;
    } catch (e) {
      debugPrint('Error saving image: $e');
      return null;
    }
  }

  /// مشاركة الصورة
  static Future<void> shareImage(File imageFile, String text) async {
    try {
      await Share.shareXFiles(
        [XFile(imageFile.path)],
        text: text,
        subject: 'نور آية - من كل آية.. نور وهداية',
      );
      debugPrint('✅ تم مشاركة الصورة');
    } catch (e) {
      debugPrint('Error sharing image: $e');
    }
  }

  /// إنشاء ومشاركة صورة من Widget
  static Future<bool> captureAndShare({
    required GlobalKey key,
    required String fileName,
    String? text,
  }) async {
    try {
      // التقاط الصورة
      final imageBytes = await captureWidget(key);
      if (imageBytes == null) return false;

      // حفظ الصورة
      final imageFile = await saveImage(imageBytes, fileName);
      if (imageFile == null) return false;

      // مشاركة الصورة
      await shareImage(imageFile, text ?? '');

      return true;
    } catch (e) {
      debugPrint('Error in captureAndShare: $e');
      return false;
    }
  }

  /// حذف الصور المؤقتة
  static Future<void> cleanupTempImages() async {
    try {
      final directory = await getTemporaryDirectory();
      final files = directory.listSync();

      for (var file in files) {
        if (file.path.endsWith('.png') && file.path.contains('verse_')) {
          await file.delete();
        }
      }

      debugPrint('✅ تم تنظيف الصور المؤقتة');
    } catch (e) {
      debugPrint('Error cleaning temp images: $e');
    }
  }
}
