import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/food_item.dart';
import '../models/province_food.dart';

class FoodDataService {
  static FoodDataService? _instance;
  static FoodDataService get instance => _instance ??= FoodDataService._();
  
  FoodDataService._();

  Map<String, ProvinceFood>? _foodData;
  List<String>? _provinces;

  /// Load dữ liệu từ file JSON
  Future<void> loadFoodData() async {
    if (_foodData != null) return; // Đã load rồi thì không load lại

    try {
      final String jsonString = await rootBundle.loadString('assets/data/foods.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      _foodData = {};
      _provinces = [];
      
      jsonData.forEach((province, data) {
        _provinces!.add(province);
        _foodData![province] = ProvinceFood.fromJson(data as Map<String, dynamic>);
      });
      
      // Sắp xếp danh sách tỉnh theo thứ tự alphabet
      _provinces!.sort();
    } catch (e) {
      throw Exception('Không thể load dữ liệu món ăn: $e');
    }
  }

  /// Lấy danh sách tất cả các tỉnh/thành phố
  List<String> get provinces {
    if (_provinces == null) {
      throw StateError('Dữ liệu chưa được load. Hãy gọi loadFoodData() trước.');
    }
    return List.unmodifiable(_provinces!);
  }

  /// Lấy dữ liệu món ăn của một tỉnh
  ProvinceFood? getFoodsByProvince(String province) {
    if (_foodData == null) {
      throw StateError('Dữ liệu chưa được load. Hãy gọi loadFoodData() trước.');
    }
    return _foodData![province];
  }

  /// Lấy tất cả món ăn từ tất cả tỉnh/thành phố
  Future<List<FoodItem>> getAllFoods() async {
    if (_foodData == null) {
      await loadFoodData();
    }

    final List<FoodItem> allFoods = [];
    
    for (final province in _foodData!.keys) {
      final provinceFood = _foodData![province]!;
      
      // Lấy món ăn từ từng category
      for (final category in provinceFood.toJson().keys) {
        final foods = provinceFood.toJson()[category] as List<dynamic>;
        for (final foodJson in foods) {
          final food = FoodItem.fromJson(foodJson as Map<String, dynamic>);
          allFoods.add(food.copyWith(
            province: province,
            category: category,
          ));
        }
      }
    }
    
    return allFoods;
  }

  /// Lấy tất cả món ăn yêu thích
  List<FoodItem> getAllFavoriteFoods(List<String> favoriteIds) {
    if (_foodData == null) {
      throw StateError('Dữ liệu chưa được load. Hãy gọi loadFoodData() trước.');
    }

    final List<FoodItem> favoriteFoods = [];
    
    for (final province in _foodData!.keys) {
      final provinceFood = _foodData![province]!;
      
      // Kiểm tra từng category
      for (final category in provinceFood.toJson().keys) {
        final foods = provinceFood.toJson()[category] as List<dynamic>;
        for (final foodJson in foods) {
          final food = FoodItem.fromJson(foodJson as Map<String, dynamic>);
          final foodId = '${province}_${category}_${food.name}';
          
          if (favoriteIds.contains(foodId)) {
            favoriteFoods.add(food.copyWith(
              province: province,
              category: category,
            ));
          }
        }
      }
    }
    
    return favoriteFoods;
  }
  
  /// Lấy thống kê số lượng món ăn theo vùng miền
  Map<String, int> getFoodStatsByRegion() {
    if (_foodData == null) {
      throw StateError('Dữ liệu chưa được load. Hãy gọi loadFoodData() trước.');
    }

    final stats = <String, int>{};
    
    for (final province in _foodData!.keys) {
      final provinceFood = _foodData![province]!;
      int count = 0;
      
      // Đếm món ăn trong từng category
      for (final category in provinceFood.toJson().keys) {
        final foods = provinceFood.toJson()[category] as List<dynamic>;
        count += foods.length;
      }
      
      stats[province] = count;
    }
    
    return stats;
  }
  
  /// Lấy thống kê số lượng món ăn theo danh mục
  Map<String, int> getFoodStatsByCategory() {
    if (_foodData == null) {
      throw StateError('Dữ liệu chưa được load. Hãy gọi loadFoodData() trước.');
    }

    final stats = <String, int>{};
    
    for (final province in _foodData!.keys) {
      final provinceFood = _foodData![province]!;
      
      // Đếm món ăn trong từng category
      for (final category in provinceFood.toJson().keys) {
        final foods = provinceFood.toJson()[category] as List<dynamic>;
        stats[category] = (stats[category] ?? 0) + foods.length;
      }
    }
    
    return stats;
  }

  /// Kiểm tra xem dữ liệu đã được load chưa
  bool get isDataLoaded => _foodData != null;
}
