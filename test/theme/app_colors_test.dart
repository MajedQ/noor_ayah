import 'package:flutter_test/flutter_test.dart';
import 'package:noor_ayah/theme/app_colors.dart';
import 'package:noor_ayah/providers/theme_provider.dart';

void main() {
  group('AppColors.getPrimaryColor', () {
    test('يعيد اللون الصحيح لكل مفتاح ثيم', () {
      expect(AppColors.getPrimaryColor('classic'), AppColors.primaryGreen);
      expect(AppColors.getPrimaryColor('night'), AppColors.nightPrimary);
      expect(AppColors.getPrimaryColor('rose'), AppColors.rosePrimary);
      expect(AppColors.getPrimaryColor('sage'), AppColors.sagePrimary);
      expect(AppColors.getPrimaryColor('golden'), AppColors.goldenPrimary);
      expect(AppColors.getPrimaryColor('beige'), AppColors.beigePrimary);
    });

    test('يعيد اللون الافتراضي (أخضر) لمفتاح غير معروف', () {
      expect(AppColors.getPrimaryColor('unknown'), AppColors.primaryGreen);
    });
  });

  group('AppColors.getSecondaryColor', () {
    test('يعيد اللون الثانوي الصحيح لكل مفتاح ثيم', () {
      expect(AppColors.getSecondaryColor('classic'), AppColors.primaryGold);
      expect(AppColors.getSecondaryColor('night'), AppColors.nightSecondary);
      expect(AppColors.getSecondaryColor('rose'), AppColors.roseSecondary);
      expect(AppColors.getSecondaryColor('sage'), AppColors.sageSecondary);
      expect(AppColors.getSecondaryColor('golden'), AppColors.goldenSecondary);
      expect(AppColors.getSecondaryColor('beige'), AppColors.beigeSecondary);
    });

    test('يعيد الذهبي افتراضياً لمفتاح غير معروف', () {
      expect(AppColors.getSecondaryColor('unknown'), AppColors.primaryGold);
    });
  });

  group('AppColors.getCategoryColor', () {
    test('يعيد لوناً معرّفاً للفئات المعروفة', () {
      expect(AppColors.getCategoryColor('صبر'),
          AppColors.categoryColors['صبر']);
    });

    test('يعيد لون "عام" للفئة غير المعروفة', () {
      expect(AppColors.getCategoryColor('فئة-غير-موجودة'),
          AppColors.categoryColors['عام']);
    });
  });

  group('AppColors brand (الثيم النشط)', () {
    tearDown(() => AppColors.activeTheme = AppThemeColor.classic);

    test('brandPrimary/brandSecondary يتبعان الثيم النشط', () {
      AppColors.activeTheme = AppThemeColor.golden;
      expect(AppColors.brandPrimary, AppColors.goldenPrimary);
      expect(AppColors.brandSecondary, AppColors.goldenSecondary);

      AppColors.activeTheme = AppThemeColor.beige;
      expect(AppColors.brandPrimary, AppColors.beigePrimary);
      expect(AppColors.brandSecondary, AppColors.beigeSecondary);

      AppColors.activeTheme = AppThemeColor.classic;
      expect(AppColors.brandPrimary, AppColors.primaryGreen);
      expect(AppColors.brandSecondary, AppColors.primaryGold);
    });
  });
}
