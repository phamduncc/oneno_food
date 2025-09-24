// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'province_food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvinceFood _$ProvinceFoodFromJson(Map<String, dynamic> json) => ProvinceFood(
      mainDishes: (json['Món chính'] as List<dynamic>)
          .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      snacks: (json['Ăn vặt'] as List<dynamic>)
          .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      drinks: (json['Đồ uống'] as List<dynamic>)
          .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      souvenirs: (json['Quà mang về'] as List<dynamic>)
          .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProvinceFoodToJson(ProvinceFood instance) =>
    <String, dynamic>{
      'Món chính': instance.mainDishes,
      'Ăn vặt': instance.snacks,
      'Đồ uống': instance.drinks,
      'Quà mang về': instance.souvenirs,
    };
