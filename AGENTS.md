# Agent instructions — نور آية (Flutter APK)

## إعدادات مكتشفة (Flutter APK)

| المتغير | القيمة |
|---------|--------|
| Flutter root | `.` (جذر الريبو) |
| `applicationId` | `com.noorayah.app` |
| App name | نور آية |
| `pubspec` name | `noor_ayah` |
| pubspec version | `1.0.0` |
| Release tag prefix | `noor-ayah-v` |
| APK pattern | `noor-ayah-v{X.Y.Z}-arm64-v8a.apk` |

---

## بناء ورفع APK (بدون GitHub Actions)

**متى:** عند طلب «ابنِ APK»، «release apk»، «v8»، «ارفع للتحميل».

**ممنوع:**

- استخدام GitHub Actions لبناء أو نشر APK.
- توقيع إصدار release بمفتاح debug.

**خطوات (يدويًا أو عبر السكربت):**

1. أعد الاكتشاف من `pubspec.yaml` و `android/app/build.gradle.kts` إن تغيّر المشروع.
2. `cd` إلى جذر Flutter (هنا: جذر الريبو).
3. **إصدار تراكمي (افتراضي):** زِد رقم البناء `+BUILD` في `pubspec.yaml`؛ زِد `Z` (patch) في `X.Y.Z`؛ commit إن تغيّر pubspec.
4. `flutter pub get` ثم `flutter gen-l10n` (إن لزم) ثم `flutter test`.
5. `flutter build apk --release --target-platform android-arm64`
6. انسخ المخرجات إلى `{pubspec-name-lower}-v{X.Y.Z}-arm64-v8a.apk` في جذر الريبو:
   - المصدر: `build/app/outputs/flutter-apk/app-release.apk`
7. أنشئ GitHub Release:
   - Tag: `noor-ayah-v{X.Y.Z}` (استبدل `_` في اسم pubspec بـ `-`)
   - ملف: APK أعلاه
   - ملاحظات: arm64-v8a فقط، `applicationId` ثابت، توقيع `release.keystore`.
8. **أرسل للمستخدم:** رابط صفحة Release + **رابط التحميل المباشر** للأصل + النسخة `X.Y.Z+BUILD`.

**تحديث التطبيق دون حذف:** نفس `applicationId` (`com.noorayah.app`) + نفس `android/app/release.keystore`.

**بديل:** من جذر الريبو:

```bash
./scripts/release-apk-v8.sh
```

---

## GitHub Actions

- **محذوف:** `release-apk.yml` (بناء ونشر APK).
- **متبقي:** `ci.yml` — `flutter analyze` و `flutter test` على `main` / PR (لا يبني APK).

بناء APK: **Cursor Cloud Agent** فقط — هذا الملف و `scripts/release-apk-v8.sh`.
