import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_item.dart';

class FavoritesService {
  static FavoritesService? _instance;
  static FavoritesService get instance => _instance ??= FavoritesService._();
  
  FavoritesService._();

  static const String _favoritesKey = 'favorite_foods';
  List<FoodItem>? _favorites;

  /// Load danh sách yêu thích từ SharedPreferences
  Future<void> loadFavorites() async {
    if (_favorites != null) return; // Đã load rồi

    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_favoritesKey);
    
    if (favoritesJson != null) {
      final List<dynamic> favoritesList = json.decode(favoritesJson);
      _favorites = favoritesList
          .map((item) => FoodItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      _favorites = [];
    }
  }

  /// Lưu danh sách yêu thích vào SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String favoritesJson = json.encode(
      _favorites!.map((item) => item.toJson()).toList(),
    );
    await prefs.setString(_favoritesKey, favoritesJson);
  }

  /// Lấy danh sách món ăn yêu thích
  List<FoodItem> get favorites {
    if (_favorites == null) {
      throw StateError('Danh sách yêu thích chưa được load. Hãy gọi loadFavorites() trước.');
    }
    return List.unmodifiable(_favorites!);
  }

  /// Kiểm tra món ăn có trong danh sách yêu thích không
  bool isFavorite(FoodItem food) {
    if (_favorites == null) {
      throw StateError('Danh sách yêu thích chưa được load. Hãy gọi loadFavorites() trước.');
    }
    return _favorites!.contains(food);
  }

  /// Thêm món ăn vào danh sách yêu thích
  Future<void> addToFavorites(FoodItem food) async {
    if (_favorites == null) {
      throw StateError('Danh sách yêu thích chưa được load. Hãy gọi loadFavorites() trước.');
    }
    
    if (!_favorites!.contains(food)) {
      _favorites!.add(food);
      await _saveFavorites();
    }
  }

  /// Xóa món ăn khỏi danh sách yêu thích
  Future<void> removeFromFavorites(FoodItem food) async {
    if (_favorites == null) {
      throw StateError('Danh sách yêu thích chưa được load. Hãy gọi loadFavorites() trước.');
    }
    
    if (_favorites!.contains(food)) {
      _favorites!.remove(food);
      await _saveFavorites();
    }
  }

  /// Toggle trạng thái yêu thích của món ăn
  Future<bool> toggleFavorite(FoodItem food) async {
    if (isFavorite(food)) {
      await removeFromFavorites(food);
      return false;
    } else {
      await addToFavorites(food);
      return true;
    }
  }

  /// Xóa tất cả món ăn yêu thích
  Future<void> clearFavorites() async {
    if (_favorites == null) {
      throw StateError('Danh sách yêu thích chưa được load. Hãy gọi loadFavorites() trước.');
    }
    
    _favorites!.clear();
    await _saveFavorites();
  }

  /// Kiểm tra xem danh sách yêu thích đã được load chưa
  bool get isLoaded => _favorites != null;

  /// Số lượng món ăn yêu thích
  int get favoritesCount {
    if (_favorites == null) return 0;
    return _favorites!.length;
  }
}
