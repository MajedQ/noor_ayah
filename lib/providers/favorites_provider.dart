import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/verse_model.dart';
import '../models/dua_model.dart';
import 'achievements_provider.dart';

/// Provider لإدارة الآيات والأدعية المفضلة
class FavoritesProvider extends ChangeNotifier {
  AchievementsProvider? _achievementsProvider;

  void setAchievementsProvider(AchievementsProvider provider) {
    _achievementsProvider = provider;
  }

  static const String _favoritesBoxName = 'favorites';
  static const String _duaFavoritesBoxName = 'dua_favorites';
  late Box<int> _favoritesBox;
  late Box<int> _duaFavoritesBox;
  Set<int> _favoriteIds = {};
  Set<int> _favoriteDuaIds = {};

  Set<int> get favoriteIds => _favoriteIds;
  Set<int> get favoriteDuaIds => _favoriteDuaIds;
  int get favoritesCount => _favoriteIds.length;
  int get favoriteDuasCount => _favoriteDuaIds.length;

  /// تهيئة Hive وتحميل المفضلة
  Future<void> init() async {
    try {
      await Hive.initFlutter();
      _favoritesBox = await Hive.openBox<int>(_favoritesBoxName);
      _duaFavoritesBox = await Hive.openBox<int>(_duaFavoritesBoxName);
      _loadFavorites();
    } catch (e) {
      debugPrint('Error initializing FavoritesProvider: $e');
    }
  }

  /// تحميل المفضلة من التخزين المحلي
  void _loadFavorites() {
    _favoriteIds = _favoritesBox.values.toSet();
    _favoriteDuaIds = _duaFavoritesBox.values.toSet();
    notifyListeners();
  }

  /// التحقق من وجود آية في المفضلة
  bool isFavorite(int verseId) {
    return _favoriteIds.contains(verseId);
  }

  /// التبديل بين إضافة وإزالة آية من المفضلة
  Future<void> toggleFavorite(VerseModel verse) async {
    if (isFavorite(verse.id)) {
      await removeFavorite(verse.id);
    } else {
      await addFavorite(verse.id);
    }
  }

  /// إضافة آية للمفضلة
  Future<void> addFavorite(int verseId) async {
    try {
      if (!_favoriteIds.contains(verseId)) {
        await _favoritesBox.add(verseId);
        _favoriteIds.add(verseId);

        // تسجيل الإنجاز
        await _achievementsProvider?.recordFavorite();

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error adding favorite: $e');
    }
  }

  /// إزالة آية من المفضلة
  Future<void> removeFavorite(int verseId) async {
    try {
      if (_favoriteIds.contains(verseId)) {
        // البحث عن مفتاح العنصر في Hive
        final key = _favoritesBox.keys.firstWhere(
          (k) => _favoritesBox.get(k) == verseId,
          orElse: () => -1,
        );

        if (key != -1) {
          await _favoritesBox.delete(key);
        }

        _favoriteIds.remove(verseId);

        // تسجيل إزالة المفضلة
        await _achievementsProvider?.removeFavorite();

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
  }

  /// مسح جميع المفضلة
  Future<void> clearAllFavorites() async {
    try {
      await _favoritesBox.clear();
      _favoriteIds.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
    }
  }

  /// الحصول على قائمة الآيات المفضلة من قائمة الآيات
  List<VerseModel> getFavoriteVerses(List<VerseModel> allVerses) {
    return allVerses.where((verse) => isFavorite(verse.id)).toList();
  }

  // ========== دوال الأدعية المفضلة ==========

  /// التحقق من وجود دعاء في المفضلة
  bool isDuaFavorite(int duaId) {
    return _favoriteDuaIds.contains(duaId);
  }

  /// التبديل بين إضافة وإزالة دعاء من المفضلة
  Future<void> toggleDuaFavorite(DuaModel dua) async {
    if (isDuaFavorite(dua.id)) {
      await removeDuaFavorite(dua.id);
    } else {
      await addDuaFavorite(dua.id);
    }
  }

  /// إضافة دعاء للمفضلة
  Future<void> addDuaFavorite(int duaId) async {
    try {
      if (!_favoriteDuaIds.contains(duaId)) {
        await _duaFavoritesBox.add(duaId);
        _favoriteDuaIds.add(duaId);

        // تسجيل الإنجاز
        await _achievementsProvider?.recordFavorite();

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error adding dua favorite: $e');
    }
  }

  /// إزالة دعاء من المفضلة
  Future<void> removeDuaFavorite(int duaId) async {
    try {
      if (_favoriteDuaIds.contains(duaId)) {
        // البحث عن مفتاح العنصر في Hive
        final key = _duaFavoritesBox.keys.firstWhere(
          (k) => _duaFavoritesBox.get(k) == duaId,
          orElse: () => -1,
        );

        if (key != -1) {
          await _duaFavoritesBox.delete(key);
        }

        _favoriteDuaIds.remove(duaId);

        // تسجيل إزالة المفضلة
        await _achievementsProvider?.removeFavorite();

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error removing dua favorite: $e');
    }
  }

  /// مسح جميع الأدعية المفضلة
  Future<void> clearAllDuaFavorites() async {
    try {
      await _duaFavoritesBox.clear();
      _favoriteDuaIds.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing dua favorites: $e');
    }
  }

  /// الحصول على قائمة الأدعية المفضلة من قائمة الأدعية
  List<DuaModel> getFavoriteDuas(List<DuaModel> allDuas) {
    return allDuas.where((dua) => isDuaFavorite(dua.id)).toList();
  }
}
