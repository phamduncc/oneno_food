// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodItem _$FoodItemFromJson(Map<String, dynamic> json) => FoodItem(
      name: json['name'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
    );

Map<String, dynamic> _$FoodItemToJson(FoodItem instance) => <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
      'location': instance.location,
    };
