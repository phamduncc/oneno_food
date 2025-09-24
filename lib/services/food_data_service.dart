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

  /// Tìm kiếm món ăn theo tên
  List<MapEntry<String, FoodItem>> searchFoods(String query) {
    if (_foodData == null) {
      throw StateError('Dữ liệu chưa được load. Hãy gọi loadFoodData() trước.');
    }

    final List<MapEntry<String, FoodItem>> results = [];
    final String lowerQuery = query.toLowerCase();

    _foodData!.forEach((province, provinceFood) {
      for (final food in provinceFood.getAllFoods()) {
        if (food.name.toLowerCase().contains(lowerQuery) ||
            food.description.toLowerCase().contains(lowerQuery)) {
          results.add(MapEntry(province, food));
        }
      }
    });

    return results;
  }

  /// Lấy tất cả món ăn từ tất cả các tỉnh
  Map<String, List<FoodItem>> getAllFoods() {
    if (_foodData == null) {
      throw StateError('Dữ liệu chưa được load. Hãy gọi loadFoodData() trước.');
    }

    final Map<String, List<FoodItem>> allFoods = {};
    _foodData!.forEach((province, provinceFood) {
      allFoods[province] = provinceFood.getAllFoods();
    });

    return allFoods;
  }

  /// Kiểm tra xem dữ liệu đã được load chưa
  bool get isDataLoaded => _foodData != null;
}
