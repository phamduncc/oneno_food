import 'package:json_annotation/json_annotation.dart';
import 'food_item.dart';

part 'province_food.g.dart';

@JsonSerializable()
class ProvinceFood {
  @JsonKey(name: 'Món chính')
  final List<FoodItem> mainDishes;
  
  @JsonKey(name: 'Ăn vặt')
  final List<FoodItem> snacks;
  
  @JsonKey(name: 'Đồ uống')
  final List<FoodItem> drinks;
  
  @JsonKey(name: 'Quà mang về')
  final List<FoodItem> souvenirs;

  const ProvinceFood({
    required this.mainDishes,
    required this.snacks,
    required this.drinks,
    required this.souvenirs,
  });

  factory ProvinceFood.fromJson(Map<String, dynamic> json) =>
      _$ProvinceFoodFromJson(json);

  Map<String, dynamic> toJson() => _$ProvinceFoodToJson(this);

  List<FoodItem> getAllFoods() {
    return [...mainDishes, ...snacks, ...drinks, ...souvenirs];
  }

  Map<String, List<FoodItem>> getFoodsByCategory() {
    return {
      'Món chính': mainDishes,
      'Ăn vặt': snacks,
      'Đồ uống': drinks,
      'Quà mang về': souvenirs,
    };
  }
}
