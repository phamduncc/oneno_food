import 'package:flutter/material.dart';

class CategoryFilterChips extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;
  
  const CategoryFilterChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });
  
  static const List<Map<String, dynamic>> categories = [
    {'name': 'Tất cả', 'value': '', 'icon': Icons.restaurant_menu},
    {'name': 'Món chính', 'value': 'Món chính', 'icon': Icons.dinner_dining},
    {'name': 'Ăn vặt', 'value': 'Ăn vặt', 'icon': Icons.fastfood},
    {'name': 'Đồ uống', 'value': 'Đồ uống', 'icon': Icons.local_drink},
    {'name': 'Quà mang về', 'value': 'Quà mang về', 'icon': Icons.card_giftcard},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category['value'];
          
          return FilterChip(
            selected: isSelected,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  category['icon'] as IconData,
                  size: 16,
                  color: isSelected 
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  category['name'] as String,
                  style: TextStyle(
                    color: isSelected 
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
            onSelected: (selected) {
              onCategorySelected(category['value'] as String);
            },
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
            selectedColor: Theme.of(context).colorScheme.primary,
            checkmarkColor: Theme.of(context).colorScheme.onPrimary,
            side: BorderSide(
              color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
              width: 1,
            ),
          );
        },
      ),
    );
  }
}
