import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor_ayah/providers/theme_provider.dart';
import 'package:noor_ayah/theme/app_theme.dart';
import 'package:noor_ayah/theme/theme_colors.dart';

void main() {
  group('AppTheme', () {
    test('يبني السمة الفاتحة لكل ثيم ويطابق اللون الأساسي', () {
      for (final theme in AppThemeColor.values) {
        final data = AppTheme.getLightTheme(theme);
        expect(data.brightness, Brightness.light);
        expect(data.useMaterial3, true);
        expect(data.colorScheme.primary, ThemeColors(theme).primary);
        expect(data.colorScheme.secondary, ThemeColors(theme).secondary);
      }
    });

    test('يبني السمة الداكنة لكل ثيم', () {
      for (final theme in AppThemeColor.values) {
        final data = AppTheme.getDarkTheme(theme);
        expect(data.brightness, Brightness.dark);
        expect(data.colorScheme.primary, ThemeColors(theme).primary);
      }
    });

    testWidgets('MaterialApp يُبنى بنجاح مع كل ثيم لوني', (tester) async {
      for (final theme in AppThemeColor.values) {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.getLightTheme(theme),
            darkTheme: AppTheme.getDarkTheme(theme),
            home: const Scaffold(body: Text('نور آية')),
          ),
        );
        expect(find.text('نور آية'), findsOneWidget);
      }
    });
  });
}
