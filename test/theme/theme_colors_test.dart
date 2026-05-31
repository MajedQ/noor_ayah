import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor_ayah/providers/theme_provider.dart';
import 'package:noor_ayah/theme/theme_colors.dart';

void main() {
  group('AppThemeColor enum', () {
    test('يحتوي على ستة ثيمات بالترتيب الصحيح (توافق مع التفضيلات المحفوظة)', () {
      expect(AppThemeColor.values.length, 6);
      // الترتيب مهم لأن الـ index يُحفظ في SharedPreferences
      expect(AppThemeColor.values[0], AppThemeColor.classic);
      expect(AppThemeColor.values[1], AppThemeColor.night);
      expect(AppThemeColor.values[2], AppThemeColor.rose);
      expect(AppThemeColor.values[3], AppThemeColor.sage);
      expect(AppThemeColor.values[4], AppThemeColor.golden);
      expect(AppThemeColor.values[5], AppThemeColor.beige);
    });

    test('كل ثيم له اسم ووصف غير فارغين', () {
      for (final theme in AppThemeColor.values) {
        expect(theme.displayName.trim(), isNotEmpty,
            reason: 'displayName فارغ لـ $theme');
        expect(theme.description.trim(), isNotEmpty,
            reason: 'description فارغ لـ $theme');
      }
    });

    test('أسماء الثيمات فريدة', () {
      final names = AppThemeColor.values.map((t) => t.displayName).toSet();
      expect(names.length, AppThemeColor.values.length);
    });
  });

  group('ThemeColors palette', () {
    test('كل ثيم يوفّر لوحة ألوان كاملة واللون الأساسي مختلف عن الثانوي', () {
      for (final theme in AppThemeColor.values) {
        final colors = ThemeColors(theme);
        expect(colors.primary, isA<Color>());
        expect(colors.secondary, isA<Color>());
        expect(colors.light, isA<Color>());
        expect(colors.medium, isA<Color>());
        expect(colors.veryLight, isA<Color>());
        expect(colors.primary, isNot(equals(colors.secondary)),
            reason: 'primary == secondary في $theme');
      }
    });

    test('التدرج الأساسي يتكوّن من ثلاثة ألوان', () {
      for (final theme in AppThemeColor.values) {
        final gradient = ThemeColors(theme).primaryGradient;
        expect(gradient.colors.length, 3);
      }
    });

    test('الألوان الأساسية متمايزة بين الثيمات', () {
      final primaries =
          AppThemeColor.values.map((t) => ThemeColors(t).primary).toSet();
      expect(primaries.length, AppThemeColor.values.length,
          reason: 'يوجد ثيمان يتشاركان نفس اللون الأساسي');
    });

    test('الثيمات الجديدة لها الألوان المتوقعة', () {
      expect(ThemeColors(AppThemeColor.sage).primary,
          const Color(0xFF4A7C59));
      expect(ThemeColors(AppThemeColor.golden).primary,
          const Color(0xFFB8860B));
      expect(ThemeColors(AppThemeColor.beige).primary,
          const Color(0xFF8C7B5B));
    });
  });
}
