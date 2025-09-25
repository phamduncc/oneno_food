import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../services/image_service.dart';

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback? onTap;
  final bool showProvince;
  final bool showCategory;
  final bool compact;
  
  const FoodCard({
    super.key,
    required this.food,
    this.onTap,
    this.showProvince = false,
    this.showCategory = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: compact ? _buildCompactLayout(context) : _buildFullLayout(context),
      ),
    );
  }
  
  Widget _buildFullLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 80,
              height: 80,
              child: ImageService.instance.buildFoodImage(
                imagePath: food.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Food Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food Name
                Text(
                  food.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                // Province and Category Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (showProvince && food.province != null) _buildTag(
                      context,
                      food.province!,
                      Icons.location_on,
                      Theme.of(context).colorScheme.primary,
                    ),
                    if (showCategory && food.category != null) _buildTag(
                      context,
                      food.category!,
                      _getCategoryIcon(food.category!),
                      _getCategoryColor(context, food.category!),
                    ),
                  ],
                ),
                
                const SizedBox(height: 6),
                
                // Description
                Text(
                  food.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 6),
                
                // Location
                Row(
                  children: [
                    Icon(
                      Icons.place,
                      size: 14,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        food.location,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Arrow Icon
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Theme.of(context).colorScheme.outline,
          ),
        ],
      ),
    );
  }
  
  Widget _buildCompactLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          // Small Food Image
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 50,
              height: 50,
              child: ImageService.instance.buildFoodImage(
                imagePath: food.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Compact Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  food.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                if (showProvince || showCategory)
                  Row(
                    children: [
                      if (showProvince && food.province != null) ...[
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          food.province!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                      if (showProvince && showCategory && food.province != null && food.category != null) const Text(' • '),
                      if (showCategory && food.category != null) ...[
                        Icon(
                          _getCategoryIcon(food.category!),
                          size: 12,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          food.category!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTag(BuildContext context, String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Món chính':
        return Icons.dinner_dining;
      case 'Ăn vặt':
        return Icons.fastfood;
      case 'Đồ uống':
        return Icons.local_drink;
      case 'Quà mang về':
        return Icons.card_giftcard;
      default:
        return Icons.restaurant_menu;
    }
  }
  
  Color _getCategoryColor(BuildContext context, String category) {
    switch (category) {
      case 'Món chính':
        return Colors.orange;
      case 'Ăn vặt':
        return Colors.green;
      case 'Đồ uống':
        return Colors.blue;
      case 'Quà mang về':
        return Colors.purple;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
