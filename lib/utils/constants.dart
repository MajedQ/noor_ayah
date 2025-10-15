/// ثوابت التطبيق
class AppConstants {
  // معلومات التطبيق
  static const String appName = 'نور آية';
  static const String appSlogan = 'من كل آية.. نور وهداية';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'تطبيق تأملي يعرض آية من القرآن الكريم يوميًا مع تفسير موجز، تدبر، ودعاء';

  // مسارات الملفات
  static const String versesJsonPath = 'assets/data/verses.json';

  // أسماء المفاتيح
  static const String isDarkModeKey = 'isDarkMode';
  static const String fontSizeKey = 'fontSize';
  static const String lastVerseIdKey = 'lastVerseId';
  static const String lastReadDateKey = 'lastReadDate';

  // الفئات المتاحة
  static const List<String> categories = [
    'صبر',
    'توكل',
    'يقين',
    'شكر',
    'هداية',
    'ثبات',
    'رحمة',
    'خوف',
    'رجاء',
    'دعاء',
    'تدبر',
    'عام',
  ];

  // أيقونات الفئات (emoji)
  static const Map<String, String> categoryIcons = {
    'صبر': '🌱',
    'توكل': '🤲',
    'يقين': '✨',
    'شكر': '🙏',
    'هداية': '🌟',
    'ثبات': '🏔️',
    'رحمة': '💚',
    'خوف': '🌙',
    'رجاء': '🌈',
    'دعاء': '☝️',
    'تدبر': '📖',
    'عام': '📜',
  };

  // رسائل
  static const String noVersesMessage = 'لا توجد آيات متاحة';
  static const String noFavoritesMessage = 'لا توجد آيات مفضلة بعد';
  static const String noSearchResultsMessage = 'لم يتم العثور على نتائج';
  static const String loadingMessage = 'جاري التحميل...';
  static const String errorMessage = 'حدث خطأ ما';

  // نصوص الأزرار
  static const String addToFavorites = 'إضافة للمفضلة';
  static const String removeFromFavorites = 'إزالة من المفضلة';
  static const String share = 'مشاركة';
  static const String copy = 'نسخ';
  static const String search = 'بحث';

  // نصوص النجاح
  static const String addedToFavorites = 'تمت الإضافة للمفضلة';
  static const String removedFromFavorites = 'تمت الإزالة من المفضلة';
  static const String copiedToClipboard = 'تم النسخ';

  // مدة الـ Animations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 2);

  // الأبعاد
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // أحجام الأيقونات
  static const double smallIconSize = 20.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 32.0;
}
