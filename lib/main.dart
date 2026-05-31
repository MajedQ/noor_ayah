import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';
import 'screens/language_selection_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/verse_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/font_provider.dart';
import 'providers/calendar_provider.dart';
import 'providers/achievements_provider.dart';
import 'providers/dua_provider.dart';
import 'providers/audio_provider.dart';
import 'providers/wird_provider.dart';
import 'services/local_storage_service.dart';
import 'services/notification_service.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الخدمات
  await LocalStorageService.init();

  // تهيئة خدمة الإشعارات
  await NotificationService.init();

  // تهيئة المفضلة
  final favoritesProvider = FavoritesProvider();
  await favoritesProvider.init();

  // ضبط اتجاه الشاشة
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FontProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
        ChangeNotifierProvider(create: (_) => AchievementsProvider()..init()),
        ChangeNotifierProxyProvider<AchievementsProvider, FavoritesProvider>(
          create: (_) => FavoritesProvider()..init(),
          update: (_, achievements, favorites) {
            favorites?.setAchievementsProvider(achievements);
            return favorites!;
          },
        ),
        ChangeNotifierProvider(create: (_) => VerseProvider()..loadVerses()),
        ChangeNotifierProvider(create: (_) => DuaProvider()..loadDuas()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => WirdProvider()..init()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,

            // إعادة بناء التطبيق عند تغيير اللغة وحجم الخط
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(themeProvider.fontSizeMultiplier),
                ),
                child: child!,
              );
            },

            // السمات - ديناميكية حسب الثيم المختار
            theme: AppTheme.getLightTheme(themeProvider.colorTheme),
            darkTheme: AppTheme.getDarkTheme(themeProvider.colorTheme),
            themeMode: themeProvider.themeMode,

            // دعم اللغات المتعددة
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocaleProvider.supportedLocales,
            locale: localeProvider.locale,

            // الشاشة الرئيسية مع Splash
            home: SplashScreen(
              child: const AppInitializer(),
            ),
          );
        },
      ),
    );
  }
}

/// Widget للتحقق من اختيار اللغة وإظهار الشاشة المناسبة
class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: LocaleProvider.hasUserSelectedLanguage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final hasSelectedLanguage = snapshot.data ?? false;

        if (hasSelectedLanguage) {
          return const MainScreen();
        } else {
          return const LanguageSelectionScreen();
        }
      },
    );
  }
}
