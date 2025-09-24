import 'package:json_annotation/json_annotation.dart';

part 'food_item.g.dart';

@JsonSerializable()
class FoodItem {
  final String name;
  final String image;
  final String description;
  final String location;

  const FoodItem({
    required this.name,
    required this.image,
    required this.description,
    required this.location,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);

  Map<String, dynamic> toJson() => _$FoodItemToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          image == other.image;

  @override
  int get hashCode => name.hashCode ^ image.hashCode;

  @override
  String toString() {
    return 'FoodItem{name: $name, image: $image, description: $description, location: $location}';
  }
}
