import 'package:flutter/material.dart';
import '../models/dua_model.dart';
import '../services/dua_repository.dart';

/// Provider لإدارة الأدعية والبحث والفلترة
class DuaProvider extends ChangeNotifier {
  List<DuaModel> _allDuas = [];
  List<DuaModel> _searchResults = [];
  bool _isLoading = false;
  String _searchQuery = '';
  DuaCategory? _selectedCategory;
  DuaOccasion? _selectedOccasion;

  List<DuaModel> get allDuas => _allDuas;
  List<DuaModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  DuaCategory? get selectedCategory => _selectedCategory;
  DuaOccasion? get selectedOccasion => _selectedOccasion;

  /// تحميل جميع الأدعية
  Future<void> loadDuas() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allDuas = await DuaRepository.loadAllDuas();
    } catch (e) {
      debugPrint('Error loading duas: $e');
      _allDuas = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// الحصول على دعاء اليوم
  DuaModel? getTodayDua() {
    return DuaRepository.getTodayDua();
  }

  /// البحث في الأدعية
  void searchDuas(String query) {
    _searchQuery = query;

    if (query.isEmpty) {
      _searchResults = [];
    } else {
      _searchResults = DuaRepository.searchDuas(query);
    }

    notifyListeners();
  }

  /// مسح البحث
  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  /// الحصول على أدعية حسب الفئة
  List<DuaModel> getDuasByCategory(DuaCategory category) {
    return DuaRepository.getDuasByCategory(category);
  }

  /// الحصول على أدعية حسب المناسبة
  List<DuaModel> getDuasByOccasion(DuaOccasion occasion) {
    return DuaRepository.getDuasByOccasion(occasion);
  }

  /// تعيين الفئة المحددة
  void setSelectedCategory(DuaCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// تعيين المناسبة المحددة
  void setSelectedOccasion(DuaOccasion? occasion) {
    _selectedOccasion = occasion;
    notifyListeners();
  }

  /// الحصول على جميع الفئات
  List<DuaCategory> getAllCategories() {
    return DuaRepository.getAllCategories();
  }

  /// الحصول على جميع المناسبات
  List<DuaOccasion> getAllOccasions() {
    return DuaRepository.getAllOccasions();
  }

  /// الحصول على دعاء بـ ID
  DuaModel? getDuaById(int id) {
    try {
      return _allDuas.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  /// الحصول على الدعاء التالي
  DuaModel? getNextDua(int currentId) {
    final currentIndex = _allDuas.indexWhere((d) => d.id == currentId);
    if (currentIndex != -1 && currentIndex < _allDuas.length - 1) {
      return _allDuas[currentIndex + 1];
    }
    return null;
  }

  /// الحصول على الدعاء السابق
  DuaModel? getPreviousDua(int currentId) {
    final currentIndex = _allDuas.indexWhere((d) => d.id == currentId);
    if (currentIndex > 0) {
      return _allDuas[currentIndex - 1];
    }
    return null;
  }

  /// عدد الأدعية الكلي
  int get totalDuasCount => _allDuas.length;

  /// عدد الفئات
  int get categoriesCount => getAllCategories().length;

  /// عدد المناسبات
  int get occasionsCount => getAllOccasions().length;

  /// الحصول على أدعية عشوائية
  List<DuaModel> getRandomDuas(int count) {
    return DuaRepository.getRandomDuas(count);
  }
}
