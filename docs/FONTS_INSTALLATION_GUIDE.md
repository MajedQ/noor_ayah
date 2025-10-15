# دليل تثبيت الخطوط الرسمية 📝

## نظرة عامة

تم تحميل وتكوين جميع الخطوط اللازمة لدعم اللغات المتعددة في تطبيق **نور آية**. يدعم التطبيق حالياً:

- 🇸🇦 **العربية** (ar) - مع 4 خطوط قرآنية للاختيار
- 🇵🇰 **الأردية** (ur) - بخط نستعليق أصيل
- 🇬🇧 **الإنجليزية** (en)
- 🇫🇷 **الفرنسية** (fr)
- 🇮🇩 **الإندونيسية** (id)

---

## ✅ ما تم إنجازه

### 1. الخطوط العربية القرآنية

تم تحميل وتكوين 4 خطوط قرآنية احترافية:

| الخط | الحجم | المصدر | الحالة |
|------|------|--------|--------|
| Amiri | 421 KB | Google Fonts | ✅ محمّل |
| Scheherazade New | 324 KB | Google Fonts | ✅ محمّل |
| Lateef | 235 KB | Google Fonts | ✅ محمّل |
| Cairo | 585 KB | Google Fonts | ✅ محمّل |
| Uthmanic Hafs | 421 KB | مجمع الملك فهد | ⚠️ بديل مؤقت |

**ملاحظة:** خط Uthmanic Hafs يستخدم حالياً Amiri كبديل. انظر القسم أدناه للحصول على الخط الأصلي.

### 2. خطوط اللغة الأردية

| الخط | الحجم | المصدر | الحالة |
|------|------|--------|--------|
| Noto Nastaliq Urdu | 287 KB | Google Fonts | ✅ محمّل |

### 3. خطوط اللغات اللاتينية

| الخط | الحجم | المصدر | الحالة |
|------|------|--------|--------|
| Roboto | 286 KB | Google Fonts | ✅ محمّل |
| Noto Sans | 2.0 MB | Google Fonts | ✅ محمّل |

---

## 📋 التغييرات التي تم إجراؤها

### 1. ملفات الخطوط (`assets/fonts/`)

تم تحميل 15 ملف خط (Regular + Bold لكل عائلة):

```
assets/fonts/
├── Amiri-Regular.ttf
├── Amiri-Bold.ttf
├── ScheherazadeNew-Regular.ttf
├── ScheherazadeNew-Bold.ttf
├── Lateef-Regular.ttf
├── Lateef-Bold.ttf
├── Cairo-Regular.ttf
├── Cairo-Bold.ttf
├── UthmanicHafs1Ver18.ttf (بديل مؤقت)
├── NotoNastaliqUrdu-Regular.ttf
├── NotoNastaliqUrdu-Bold.ttf
├── Roboto-Regular.ttf
├── Roboto-Bold.ttf
├── NotoSans-Regular.ttf
└── NotoSans-Bold.ttf
```

### 2. تحديثات `pubspec.yaml`

تم إضافة تعريفات جميع الخطوط مع التعليقات التوضيحية:

```yaml
fonts:
  # خطوط عربية قرآنية
  - family: UthmanicHafs
  - family: ScheherazadeNew
  - family: Lateef
  - family: Amiri
  - family: Cairo
  
  # خطوط للغة الأردية
  - family: NotoNastaliqUrdu
  
  # خطوط للغات اللاتينية
  - family: Roboto
  - family: NotoSans
```

### 3. تحديثات `font_provider.dart`

تم تحسين `FontProvider` ليشمل:

#### إضافات جديدة:
- ✅ `UIFont` enum - لخطوط الواجهة
- ✅ `setUIFont()` - لتغيير خط الواجهة
- ✅ `setLocale()` - لتحديث اللغة الحالية
- ✅ `getLocalizedUIFont()` - للحصول على الخط المناسب للغة
- ✅ `getArabicTextFont()` - للنصوص العربية (التدبر والأدعية)

#### مثال على الاستخدام:
```dart
// في main.dart أو حيث يتم إدارة اللغة
fontProvider.setLocale(locale.languageCode);

// في الويدجت
Text(
  'نص عربي',
  style: TextStyle(
    fontFamily: fontProvider.uiFontFamily, // يختار تلقائياً حسب اللغة
  ),
);
```

---

## 🔧 كيفية الحصول على خط الرسم العثماني الأصلي

### الطريقة الأولى: من موقع مجمع الملك فهد

1. **زيارة الموقع الرسمي:**
   ```
   https://fonts.qurancomplex.gov.sa/
   ```

2. **البحث عن الخط:**
   - ابحث عن "خط حفص" أو "Uthmanic Hafs"
   - أو اختر "الخطوط القرآنية" من القائمة

3. **التحميل:**
   - حمّل الإصدار 18 أو الأحدث
   - اختر صيغة TrueType (.ttf) أو OpenType (.otf)

4. **التثبيت:**
   ```bash
   # انسخ الملف المحمل إلى مجلد الخطوط
   cp ~/Downloads/UthmanicHafs1Ver18.ttf \
      assets/fonts/UthmanicHafs1Ver18.ttf
   
   # أعد بناء التطبيق
   flutter clean
   flutter pub get
   flutter run
   ```

### الطريقة الثانية: استخدام Scheherazade New كبديل

إذا لم تتمكن من الحصول على الخط الأصلي، يمكنك استخدام Scheherazade New:

```dart
// في font_provider.dart
// غيّر الافتراضي من uthmanic إلى scheherazade
QuranicFont _selectedFont = QuranicFont.scheherazade;
```

---

## 🚀 اختبار الخطوط

### 1. تشغيل التطبيق

```bash
cd /Users/ZahraahIT/Documents/MQ/Noor_Ayah_app/noor_ayah
flutter clean
flutter pub get
flutter run
```

### 2. اختبار الخطوط القرآنية

1. افتح التطبيق
2. اذهب إلى **الإعدادات** ⚙️
3. اختر **المظهر**
4. اختر **خط الآيات**
5. جرّب كل خط:
   - الرسم العثماني
   - شهرزاد
   - لطيف
   - أميري (الافتراضي)

### 3. اختبار اللغات المختلفة

#### العربية (الافتراضية)
```
الإعدادات > اللغة > العربية
```
- يجب أن يظهر النص بخط Cairo العصري
- الآيات بخط Amiri (أو الخط المختار)

#### الأردية
```
Settings > Language > اردو
```
- يجب أن يظهر النص بخط Noto Nastaliq Urdu النستعليق
- الآيات بالخط القرآني المختار

#### الإنجليزية/الفرنسية/الإندونيسية
```
Settings > Language > English/Français/Bahasa
```
- يجب أن يظهر النص بخط Roboto الاحترافي
- الآيات بالخط القرآني المختار

---

## 📱 الاستخدام في الكود

### مثال 1: استخدام خط الآية

```dart
import 'package:provider/provider.dart';

class VerseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);
    
    return Text(
      verseText,
      style: TextStyle(
        fontFamily: fontProvider.fontFamily, // خط الآية المختار
        fontSize: 28,
        height: 2.0,
      ),
    );
  }
}
```

### مثال 2: استخدام خط الواجهة حسب اللغة

```dart
import 'package:provider/provider.dart';

class CustomText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);
    
    return Text(
      localizedText,
      style: TextStyle(
        fontFamily: fontProvider.uiFontFamily, // يختار تلقائياً
        fontSize: 16,
      ),
    );
  }
}
```

### مثال 3: تحديث اللغة

```dart
// في LocaleProvider أو حيث تدير اللغة
class LocaleProvider extends ChangeNotifier {
  void setLocale(Locale locale) {
    _locale = locale;
    
    // تحديث FontProvider بالغة الجديدة
    final fontProvider = Provider.of<FontProvider>(context, listen: false);
    fontProvider.setLocale(locale.languageCode);
    
    notifyListeners();
  }
}
```

---

## 🎨 التخصيص المتقدم

### إضافة خط جديد

1. **تحميل الخط:**
   ```bash
   curl -L -o assets/fonts/NewFont-Regular.ttf "URL"
   ```

2. **تعديل `pubspec.yaml`:**
   ```yaml
   fonts:
     - family: NewFont
       fonts:
         - asset: assets/fonts/NewFont-Regular.ttf
         - asset: assets/fonts/NewFont-Bold.ttf
           weight: 700
   ```

3. **تعديل `font_provider.dart`:**
   ```dart
   enum QuranicFont {
     // ... الخطوط الموجودة
     newFont, // الخط الجديد
   }
   
   extension QuranicFontExtension on QuranicFont {
     String get fontFamily {
       // ... الحالات الموجودة
       case QuranicFont.newFont:
         return 'NewFont';
     }
   }
   ```

---

## 🔍 استكشاف الأخطاء

### المشكلة: الخط لا يظهر

**الحل:**
```bash
flutter clean
flutter pub get
flutter run
```

### المشكلة: الخط يظهر بشكل خاطئ

**التحقق:**
1. تأكد من اسم عائلة الخط في `pubspec.yaml`
2. تأكد من مسار الملف صحيح
3. تأكد من أن الملف ليس تالفاً:
   ```bash
   file assets/fonts/FontName.ttf
   # يجب أن يظهر: TrueType Font data
   ```

### المشكلة: حجم التطبيق كبير

**الحلول:**
1. احذف الخطوط غير المستخدمة
2. استخدم خطوط متغيرة (Variable Fonts) بدلاً من ملفات متعددة
3. ضغط الخطوط باستخدام أدوات مثل `fonttools`

---

## 📊 إحصائيات الخطوط

### الحجم الإجمالي
```
إجمالي الخطوط: ~7.7 MB
├── العربية: ~3.0 MB (5 عائلات)
├── الأردية: ~0.6 MB (1 عائلة)
└── اللاتينية: ~4.6 MB (2 عائلة)
```

### عدد الملفات
```
إجمالي الملفات: 15 ملف
├── Regular: 8 ملفات
└── Bold: 7 ملفات
```

---

## 📚 المراجع

### مصادر الخطوط
- Google Fonts: https://fonts.google.com/
- مجمع الملك فهد: https://fonts.qurancomplex.gov.sa/
- SIL International: https://software.sil.org/

### التوثيق
- Flutter Fonts: https://docs.flutter.dev/cookbook/design/fonts
- Google Fonts Package: https://pub.dev/packages/google_fonts
- Font Provider: `lib/providers/font_provider.dart`

---

## ✅ قائمة المراجعة

قبل الإصدار النهائي، تأكد من:

- [ ] جميع الخطوط محملة بشكل صحيح
- [ ] خط Uthmanic Hafs الأصلي مثبت (أو استخدام بديل موثق)
- [ ] اختبار جميع اللغات المدعومة
- [ ] اختبار تبديل الخطوط في الإعدادات
- [ ] التحقق من حجم التطبيق النهائي
- [ ] اختبار على أجهزة مختلفة (iOS & Android)
- [ ] التحقق من الأداء والسرعة
- [ ] توثيق أي تغييرات إضافية

---

## 🤝 المساهمة

إذا وجدت مشكلة في الخطوط أو لديك اقتراح لتحسينها:

1. افتح Issue في المستودع
2. قدم Pull Request مع التحسينات
3. شارك خبرتك في تحسين الخطوط

---

## 📄 الترخيص

جميع الخطوط المستخدمة مرخصة للاستخدام المجاني:
- **Google Fonts:** SIL OFL 1.1 / Apache 2.0
- **Uthmanic Hafs:** مجاني للاستخدام الإسلامي

---

**آخر تحديث:** أكتوبر 2025  
**الإصدار:** 1.0.0  
**الحالة:** ✅ جاهز للاستخدام (مع ملاحظة بخصوص Uthmanic Hafs)

**نور آية** - من كل آية.. نور وهداية 🌙

