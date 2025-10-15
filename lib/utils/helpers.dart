import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../models/verse_model.dart';
import 'constants.dart';

/// دوال مساعدة للتطبيق
class AppHelpers {
  /// نسخ نص إلى الحافظة
  static Future<void> copyToClipboard(String text, BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppConstants.copiedToClipboard,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'IBMPlexArabic'),
          ),
          duration: AppConstants.snackBarDuration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  /// مشاركة آية
  static Future<void> shareVerse(VerseModel verse) async {
    final text = verse.getFormattedText();
    await Share.share(
      text,
      subject: 'آية من تطبيق ${AppConstants.appName}',
    );
  }

  /// عرض رسالة SnackBar
  static void showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'IBMPlexArabic'),
        ),
        backgroundColor: isError ? Colors.red.shade600 : null,
        duration: AppConstants.snackBarDuration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// تنسيق التاريخ بالعربية
  static String formatDateArabic(DateTime date) {
    const arabicMonths = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];

    const arabicDays = [
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];

    final dayName = arabicDays[date.weekday - 1];
    final monthName = arabicMonths[date.month - 1];

    return '$dayName، ${date.day} $monthName ${date.year}';
  }

  /// تحويل الأرقام الإنجليزية إلى عربية
  static String toArabicNumbers(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String output = input;
    for (int i = 0; i < english.length; i++) {
      output = output.replaceAll(english[i], arabic[i]);
    }
    return output;
  }

  /// الحصول على أيقونة الفئة
  static String getCategoryIcon(String category) {
    return AppConstants.categoryIcons[category] ??
        AppConstants.categoryIcons['عام']!;
  }

  /// تمييز النص المطابق في البحث
  static List<TextSpan> highlightSearchText(
    String text,
    String query, {
    required Color highlightColor,
    required TextStyle normalStyle,
  }) {
    if (query.isEmpty) {
      return [TextSpan(text: text, style: normalStyle)];
    }

    final List<TextSpan> spans = [];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    int start = 0;
    int indexOfQuery = lowerText.indexOf(lowerQuery);

    while (indexOfQuery != -1) {
      // إضافة النص قبل التطابق
      if (indexOfQuery > start) {
        spans.add(TextSpan(
          text: text.substring(start, indexOfQuery),
          style: normalStyle,
        ));
      }

      // إضافة النص المطابق مع التمييز
      spans.add(TextSpan(
        text: text.substring(indexOfQuery, indexOfQuery + query.length),
        style: normalStyle.copyWith(
          backgroundColor: highlightColor,
          fontWeight: FontWeight.bold,
        ),
      ));

      start = indexOfQuery + query.length;
      indexOfQuery = lowerText.indexOf(lowerQuery, start);
    }

    // إضافة باقي النص
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: normalStyle,
      ));
    }

    return spans;
  }

  /// Haptic Feedback
  static void lightHaptic() {
    HapticFeedback.lightImpact();
  }

  static void mediumHaptic() {
    HapticFeedback.mediumImpact();
  }

  static void selectionHaptic() {
    HapticFeedback.selectionClick();
  }
}
