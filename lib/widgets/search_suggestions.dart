import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/search_service.dart';
import '../models/food_item.dart';

class SearchSuggestions extends StatefulWidget {
  final Function(String) onSuggestionTap;
  
  const SearchSuggestions({
    super.key,
    required this.onSuggestionTap,
  });

  @override
  State<SearchSuggestions> createState() => _SearchSuggestionsState();
}

class _SearchSuggestionsState extends State<SearchSuggestions> {
  List<FoodItem> _randomSuggestions = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadRandomSuggestions();
  }
  
  Future<void> _loadRandomSuggestions() async {
    final searchService = context.read<SearchService>();
    final suggestions = await searchService.getRandomSuggestions(count: 8);
    
    if (mounted) {
      setState(() {
        _randomSuggestions = suggestions;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular Search Terms
          _buildSectionHeader(
            context,
            'Tìm kiếm phổ biến',
            Icons.trending_up,
          ),
          const SizedBox(height: 12),
          _buildPopularSearches(context),
          
          const SizedBox(height: 24),
          
          // Random Suggestions
          _buildSectionHeader(
            context,
            'Gợi ý cho bạn',
            Icons.recommend,
            onRefresh: _loadRandomSuggestions,
          ),
          const SizedBox(height: 12),
          _buildRandomSuggestions(context),
          
          const SizedBox(height: 24),
          
          // Quick Categories
          _buildSectionHeader(
            context,
            'Danh mục nhanh',
            Icons.category,
          ),
          const SizedBox(height: 12),
          _buildQuickCategories(context),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon, {
    VoidCallback? onRefresh,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        if (onRefresh != null) ...[
          const Spacer(),
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh, size: 20),
            tooltip: 'Làm mới',
          ),
        ],
      ],
    );
  }
  
  Widget _buildPopularSearches(BuildContext context) {
    final popularSearches = [
      'Phở',
      'Bánh mì',
      'Bún bò Huế',
      'Cao lầu',
      'Mì Quảng',
      'Bánh xèo',
      'Cà phê',
      'Chè',
    ];
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: popularSearches.map((search) => ActionChip(
        label: Text(search),
        onPressed: () => widget.onSuggestionTap(search),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        side: BorderSide.none,
      )).toList(),
    );
  }
  
  Widget _buildRandomSuggestions(BuildContext context) {
    if (_randomSuggestions.isEmpty) {
      return const Center(
        child: Text('Không có gợi ý nào'),
      );
    }
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _randomSuggestions.length,
      itemBuilder: (context, index) {
        final food = _randomSuggestions[index];
        return InkWell(
          onTap: () => widget.onSuggestionTap(food.name),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
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
                Text(
                  food.province ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildQuickCategories(BuildContext context) {
    final categories = [
      {'name': 'Món chính', 'icon': Icons.dinner_dining, 'color': Colors.orange},
      {'name': 'Ăn vặt', 'icon': Icons.fastfood, 'color': Colors.green},
      {'name': 'Đồ uống', 'icon': Icons.local_drink, 'color': Colors.blue},
      {'name': 'Quà mang về', 'icon': Icons.card_giftcard, 'color': Colors.purple},
    ];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return InkWell(
          onTap: () {
            context.read<SearchService>().searchByCategory(category['name'] as String);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (category['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (category['color'] as Color).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  category['icon'] as IconData,
                  color: category['color'] as Color,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    category['name'] as String,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: category['color'] as Color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
