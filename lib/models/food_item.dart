import 'package:json_annotation/json_annotation.dart';

part 'food_item.g.dart';

@JsonSerializable()
class FoodItem {
  final String name;
  final String image;
  final String description;
  final String location;
  final String? province;
  final String? category;

  const FoodItem({
    required this.name,
    required this.image,
    required this.description,
    required this.location,
    this.province,
    this.category,
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

  /// Tạo bản sao với các thuộc tính được cập nhật
  FoodItem copyWith({
    String? name,
    String? image,
    String? description,
    String? location,
    String? province,
    String? category,
  }) {
    return FoodItem(
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      location: location ?? this.location,
      province: province ?? this.province,
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'FoodItem{name: $name, image: $image, description: $description, location: $location, province: $province, category: $category}';
  }
}
