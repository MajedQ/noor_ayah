import 'package:hijri/hijri_calendar.dart';

/// خدمة التقويم الهجري
class HijriDateService {
  /// أسماء الأشهر الهجرية بالعربية
  static const List<String> hijriMonthsArabic = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  /// أسماء الأشهر الهجرية بالإنجليزية
  static const List<String> hijriMonthsEnglish = [
    'Muharram',
    'Safar',
    'Rabi\' al-Awwal',
    'Rabi\' al-Thani',
    'Jumada al-Ula',
    'Jumada al-Akhirah',
    'Rajab',
    'Sha\'ban',
    'Ramadan',
    'Shawwal',
    'Dhu al-Qi\'dah',
    'Dhu al-Hijjah',
  ];

  /// أسماء الأيام بالعربية
  static const List<String> weekdaysArabic = [
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  /// تحويل من ميلادي لهجري
  static HijriCalendar gregorianToHijri(DateTime date) {
    final hijri = HijriCalendar.fromDate(date);
    return hijri;
  }

  /// الحصول على التاريخ الهجري الحالي
  static HijriCalendar getCurrentHijriDate() {
    return HijriCalendar.now();
  }

  /// تنسيق التاريخ الهجري بالعربية
  static String formatHijriDateArabic(HijriCalendar hijri,
      {bool includeDay = true}) {
    final monthName = hijriMonthsArabic[hijri.hMonth - 1];
    final day = toArabicNumbers(hijri.hDay.toString());
    final year = toArabicNumbers(hijri.hYear.toString());

    if (includeDay && hijri.wkDay != null && hijri.getDayName() != null) {
      final wkDayIndex = (hijri.wkDay! - 1).clamp(0, 6);
      final dayName = weekdaysArabic[wkDayIndex];
      return '$dayName، $day $monthName $year هـ';
    }

    return '$day $monthName $year هـ';
  }

  /// تنسيق التاريخ الهجري بالإنجليزية
  static String formatHijriDateEnglish(HijriCalendar hijri) {
    final monthName = hijriMonthsEnglish[hijri.hMonth - 1];
    return '${hijri.hDay} $monthName ${hijri.hYear} AH';
  }

  /// تنسيق التاريخ الهجري حسب اللغة
  static String formatHijriDate(HijriCalendar hijri, {String locale = 'ar'}) {
    if (locale == 'ar' || locale == 'ur') {
      return formatHijriDateArabic(hijri);
    } else {
      return formatHijriDateEnglish(hijri);
    }
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

  /// التحقق من شهر رمضان
  static bool isRamadan(HijriCalendar? hijri) {
    hijri ??= getCurrentHijriDate();
    return hijri.hMonth == 9; // رمضان هو الشهر التاسع
  }

  /// الحصول على عدد الأيام المتبقية لرمضان
  static int getDaysUntilRamadan() {
    final current = getCurrentHijriDate();
    if (current.hMonth == 9) {
      return 0; // نحن في رمضان
    }

    // حساب تقريبي
    int monthsUntilRamadan = 9 - current.hMonth;
    if (monthsUntilRamadan < 0) {
      monthsUntilRamadan += 12;
    }

    return monthsUntilRamadan * 30; // تقريبي
  }

  /// التحقق من الأشهر الحرم
  static bool isSacredMonth(HijriCalendar? hijri) {
    hijri ??= getCurrentHijriDate();
    final sacredMonths = [1, 7, 11, 12]; // محرم، رجب، ذو القعدة، ذو الحجة
    return sacredMonths.contains(hijri.hMonth);
  }

  /// الحصول على اسم الشهر بالعربية
  static String getMonthNameArabic(int month) {
    if (month < 1 || month > 12) return '';
    return hijriMonthsArabic[month - 1];
  }

  /// الحصول على اسم الشهر بالإنجليزية
  static String getMonthNameEnglish(int month) {
    if (month < 1 || month > 12) return '';
    return hijriMonthsEnglish[month - 1];
  }
}
