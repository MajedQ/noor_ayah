import 'package:flutter_test/flutter_test.dart';
import 'package:noor_ayah/models/verse_model.dart';

void main() {
  group('VerseModel.fromJson', () {
    test('يقرأ قائمة categories عند توفرها', () {
      final verse = VerseModel.fromJson({
        'id': 1,
        'surah': 'البقرة',
        'verseText': 'نص الآية',
        'reflection': 'تدبر',
        'dua': 'دعاء',
        'categories': ['صبر', 'يقين'],
      });

      expect(verse.id, 1);
      expect(verse.surah, 'البقرة');
      expect(verse.categories, ['صبر', 'يقين']);
      expect(verse.mainCategory, 'صبر');
    });

    test('يتعامل مع الحقل المفرد category (توافق رجعي)', () {
      final verse = VerseModel.fromJson({
        'id': 2,
        'surah': 'الفاتحة',
        'verseText': 'نص',
        'reflection': 'تدبر',
        'dua': 'دعاء',
        'category': 'هداية',
      });

      expect(verse.categories, ['هداية']);
      expect(verse.mainCategory, 'هداية');
    });

    test('يستخدم "عام" عند غياب أي تصنيف', () {
      final verse = VerseModel.fromJson({
        'id': 3,
        'surah': 'الإخلاص',
        'verseText': 'نص',
        'reflection': 'تدبر',
        'dua': 'دعاء',
      });

      expect(verse.categories, ['عام']);
    });
  });

  group('VerseModel serialization', () {
    test('toJson ثم fromJson يحافظ على البيانات', () {
      final original = VerseModel(
        id: 10,
        surah: 'النور',
        surahNumber: 24,
        verseNumber: 35,
        verseText: 'الله نور السماوات والأرض',
        reflection: 'تدبر',
        dua: 'دعاء',
        categories: const ['تدبر'],
      );

      final restored = VerseModel.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.surah, original.surah);
      expect(restored.surahNumber, original.surahNumber);
      expect(restored.verseNumber, original.verseNumber);
      expect(restored.verseText, original.verseText);
      expect(restored.categories, original.categories);
    });

    test('copyWith يحدّث الحقول المحددة فقط', () {
      final verse = VerseModel(
        id: 1,
        surah: 'البقرة',
        verseText: 'نص',
        reflection: 'تدبر',
        dua: 'دعاء',
        categories: const ['صبر'],
      );

      final updated = verse.copyWith(surah: 'آل عمران');
      expect(updated.surah, 'آل عمران');
      expect(updated.id, verse.id);
      expect(updated.verseText, verse.verseText);
    });

    test('getFormattedText يتضمن النص والتدبر والدعاء واسم السورة', () {
      final verse = VerseModel(
        id: 1,
        surah: 'البقرة',
        verseText: 'نص الآية',
        reflection: 'التدبر هنا',
        dua: 'الدعاء هنا',
        categories: const ['عام'],
      );

      final formatted = verse.getFormattedText();
      expect(formatted, contains('نص الآية'));
      expect(formatted, contains('التدبر هنا'));
      expect(formatted, contains('الدعاء هنا'));
      expect(formatted, contains('البقرة'));
    });
  });
}
