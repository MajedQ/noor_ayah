# إصدارات نور آية (APK)

| الملف | المعمارية | الإصدار | الحجم |
|---|---|---|---|
| `noor-ayah-1.0.0-arm64-v8a.apk` | arm64-v8a (معالجات ARMv8 / 64-bit) | 1.0.0 | ~16 MB |

## كيفية البناء

```bash
flutter pub get
flutter gen-l10n
flutter build apk --release --target-platform android-arm64
# الناتج: build/app/outputs/flutter-apk/app-release.apk
```

## ملاحظات مهمة

- **المعمارية:** هذا الـ APK مخصص لمعالجات **arm64-v8a** فقط (أغلب أجهزة أندرويد الحديثة).
  للأجهزة القديمة (armeabi-v7a) ابنِ بـ `--target-platform android-arm`.
- **التوقيع:** هذا الإصدار موقّع بمفتاح **التصحيح (debug)** الافتراضي من قالب Flutter
  (كما هو معرّف في `android/app/build.gradle.kts`). وهو مناسب للتجربة والتثبيت المباشر،
  لكنه **غير صالح للنشر على Google Play**؛ للنشر يجب إنشاء keystore خاص وإعداد
  `signingConfig` للإصدار.
- للتحقق من سلامة الملف: قارن قيمة SHA-256.
  - `noor-ayah-1.0.0-arm64-v8a.apk`: `17b003acb938c178541dc05b928e59fa40d1d590c3cdd390e026c648b67af763`
- لتثبيت الملف على الجهاز فعّل «تثبيت من مصادر غير معروفة» ثم افتح الـ APK.

> بديل موصى به مستقبلًا: رفع الـ APK كـ **GitHub Release asset** بدلًا من الالتزام به داخل المستودع،
> لتفادي تضخّم تاريخ Git بالملفات الثنائية.
