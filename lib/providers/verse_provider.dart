import 'package:flutter/material.dart';
import '../models/verse_model.dart';
import '../services/verse_repository.dart';

/// Provider لإدارة الآيات والبحث والفلترة
class VerseProvider extends ChangeNotifier {
  List<VerseModel> _allVerses = [];
  List<VerseModel> _searchResults = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _selectedCategory;

  List<VerseModel> get allVerses => _allVerses;
  List<VerseModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;

  /// تحميل جميع الآيات
  Future<void> loadVerses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allVerses = await VerseRepository.loadAllVerses();
    } catch (e) {
      debugPrint('Error loading verses: $e');
      _allVerses = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// الحصول على آية اليوم
  VerseModel? getTodayVerse() {
    return VerseRepository.getTodayVerse();
  }

  /// البحث في الآيات
  void searchVerses(String query) {
    _searchQuery = query;

    if (query.isEmpty) {
      _searchResults = [];
    } else {
      _searchResults = VerseRepository.searchVerses(query);
    }

    notifyListeners();
  }

  /// مسح البحث
  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  /// الحصول على آيات حسب الفئة
  List<VerseModel> getVersesByCategory(String category) {
    return VerseRepository.getVersesByCategory(category);
  }

  /// تعيين الفئة المحددة
  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// الحصول على جميع الفئات
  List<String> getAllCategories() {
    return VerseRepository.getAllCategories();
  }

  /// الحصول على آية بـ ID
  VerseModel? getVerseById(int id) {
    try {
      return _allVerses.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }

  /// الحصول على الآية التالية
  VerseModel? getNextVerse(int currentId) {
    final currentIndex = _allVerses.indexWhere((v) => v.id == currentId);
    if (currentIndex != -1 && currentIndex < _allVerses.length - 1) {
      return _allVerses[currentIndex + 1];
    }
    return null;
  }

  /// الحصول على الآية السابقة
  VerseModel? getPreviousVerse(int currentId) {
    final currentIndex = _allVerses.indexWhere((v) => v.id == currentId);
    if (currentIndex > 0) {
      return _allVerses[currentIndex - 1];
    }
    return null;
  }

  /// عدد الآيات الكلي
  int get totalVersesCount => _allVerses.length;

  /// عدد الفئات
  int get categoriesCount => getAllCategories().length;
}
