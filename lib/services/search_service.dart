import 'package:flutter/foundation.dart';
import '../models/food_item.dart';
import 'food_data_service.dart';

class SearchService extends ChangeNotifier {
  final FoodDataService _foodDataService;
  
  List<FoodItem> _searchResults = [];
  String _currentQuery = '';
  bool _isSearching = false;
  
  SearchService(this._foodDataService);
  
  List<FoodItem> get searchResults => _searchResults;
  String get currentQuery => _currentQuery;
  bool get isSearching => _isSearching;
  
  /// Tìm kiếm món ăn theo tên với fuzzy matching
  Future<void> searchFoods(String query) async {
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }
    
    _isSearching = true;
    _currentQuery = query;
    notifyListeners();
    
    try {
      final allFoods = await _foodDataService.getAllFoods();
      
      // Fuzzy search với multiple criteria
      _searchResults = allFoods.where((food) {
        final foodName = _removeDiacritics(food.name.toLowerCase());
        final searchQuery = _removeDiacritics(query.toLowerCase());
        final description = _removeDiacritics(food.description.toLowerCase());
        final location = _removeDiacritics(food.location.toLowerCase());
        
        return foodName.contains(searchQuery) ||
               description.contains(searchQuery) ||
               location.contains(searchQuery) ||
               _fuzzyMatch(foodName, searchQuery);
      }).toList();
      
      // Sắp xếp theo độ liên quan
      _searchResults.sort((a, b) {
        final aName = _removeDiacritics(a.name.toLowerCase());
        final bName = _removeDiacritics(b.name.toLowerCase());
        final searchQuery = _removeDiacritics(query.toLowerCase());
        
        // Ưu tiên exact match
        if (aName.startsWith(searchQuery) && !bName.startsWith(searchQuery)) {
          return -1;
        }
        if (!aName.startsWith(searchQuery) && bName.startsWith(searchQuery)) {
          return 1;
        }
        
        // Sau đó theo độ dài tên
        return aName.length.compareTo(bName.length);
      });
      
    } catch (e) {
      debugPrint('Search error: $e');
      _searchResults = [];
    }
    
    _isSearching = false;
    notifyListeners();
  }
  
  /// Tìm kiếm theo danh mục
  Future<void> searchByCategory(String category) async {
    _isSearching = true;
    notifyListeners();
    
    try {
      final allFoods = await _foodDataService.getAllFoods();
      _searchResults = allFoods.where((food) => food.category != null && food.category == category).toList();
    } catch (e) {
      debugPrint('Category search error: $e');
      _searchResults = [];
    }
    
    _isSearching = false;
    notifyListeners();
  }
  
  /// Tìm kiếm theo tỉnh/thành phố
  Future<void> searchByProvince(String province) async {
    _isSearching = true;
    notifyListeners();
    
    try {
      final allFoods = await _foodDataService.getAllFoods();
      _searchResults = allFoods.where((food) => food.province != null && food.province == province).toList();
    } catch (e) {
      debugPrint('Province search error: $e');
      _searchResults = [];
    }
    
    _isSearching = false;
    notifyListeners();
  }
  
  /// Gợi ý món ăn ngẫu nhiên
  Future<List<FoodItem>> getRandomSuggestions({int count = 5}) async {
    try {
      final allFoods = await _foodDataService.getAllFoods();
      final shuffled = List<FoodItem>.from(allFoods)..shuffle();
      return shuffled.take(count).toList();
    } catch (e) {
      debugPrint('Random suggestions error: $e');
      return [];
    }
  }
  
  /// Xóa kết quả tìm kiếm
  void clearSearch() {
    _searchResults = [];
    _currentQuery = '';
    _isSearching = false;
    notifyListeners();
  }
  
  /// Loại bỏ dấu tiếng Việt để tìm kiếm dễ dàng hơn
  String _removeDiacritics(String text) {
    const vietnamese = 'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ';
    const english = 'aaaaaaaaaaaaaaaeeeeeeeeeeeiiiiioooooooooooooooouuuuuuuuuuuyyyyyd';
    
    String result = text;
    for (int i = 0; i < vietnamese.length; i++) {
      result = result.replaceAll(vietnamese[i], english[i]);
    }
    return result;
  }
  
  /// Fuzzy matching đơn giản
  bool _fuzzyMatch(String text, String pattern) {
    if (pattern.length > text.length) return false;
    
    int patternIndex = 0;
    for (int i = 0; i < text.length && patternIndex < pattern.length; i++) {
      if (text[i] == pattern[patternIndex]) {
        patternIndex++;
      }
    }
    
    return patternIndex == pattern.length;
  }
  
  /// Lấy thống kê tìm kiếm
  Map<String, int> getSearchStats() {
    final stats = <String, int>{};
    
    for (final food in _searchResults) {
      if (food.province != null) {
        stats[food.province!] = (stats[food.province!] ?? 0) + 1;
      }
    }
    
    return Map.fromEntries(
      stats.entries.toList()..sort((a, b) => b.value.compareTo(a.value))
    );
  }
}
