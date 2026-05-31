# إصدارات نور آية (APK)

## التحميل من GitHub Releases

يتم بناء ونشر ملف **arm64-v8a** (معالجات ARMv8 / 64-bit) تلقائيًا عبر GitHub Actions عند إنشاء وسم إصدار:

```bash
git tag v1.0.0
git push origin v1.0.0
```

أو من واجهة GitHub: **Actions → Release APK (arm64-v8a) → Run workflow**.

| الحقل | القيمة |
|---|---|
| اسم الملف | `noor-ayah-<version>-arm64-v8a.apk` |
| المعمارية | arm64-v8a (ARMv8 / 64-bit) |
| الإصدار الحالي | 1.0.0 |

رابط الإصدارات: [GitHub Releases](https://github.com/MajedQ/noor_ayah/releases)

## البناء المحلي

```bash
flutter pub get
flutter gen-l10n
flutter build apk --release --target-platform android-arm64
# الناتج: build/app/outputs/flutter-apk/app-release.apk
```

## ملاحظات مهمة

- **المعمارية:** هذا الـ APK مخصص لمعالجات **arm64-v8a** فقط (أغلب أجهزة أندرويد الحديثة).
  للأجهزة القديمة (armeabi-v7a) ابنِ بـ `--target-platform android-arm`.
- **التوقيع:** الإصدار موقّع بمفتاح **التصحيح (debug)** الافتراضي من قالب Flutter
  (كما هو معرّف في `android/app/build.gradle.kts`). وهو مناسب للتجربة والتثبيت المباشر،
  لكنه **غير صالح للنشر على Google Play**؛ للنشر يجب إنشاء keystore خاص وإعداد
  `signingConfig` للإصدار.
- للتحقق من سلامة الملف: قارن قيمة SHA-256 المذكورة في وصف الإصدار على GitHub.
- لتثبيت الملف على الجهاز فعّل «تثبيت من مصادر غير معروفة» ثم افتح الـ APK.

> الـ APK **لا يُخزَّن داخل المستودع**؛ يُرفع فقط كملف مرفق في GitHub Release لتجنب تضخّم تاريخ Git.
