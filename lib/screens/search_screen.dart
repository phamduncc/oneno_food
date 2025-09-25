import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../services/search_service.dart';
import '../widgets/food_card.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/search_suggestions.dart';
import 'food_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _selectedCategory = '';
  
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm món ăn'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search TextField
                TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm món ăn, địa điểm...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Consumer<SearchService>(
                      builder: (context, searchService, child) {
                        if (searchService.currentQuery.isNotEmpty) {
                          return IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              searchService.clearSearch();
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  ),
                  onChanged: (query) {
                    context.read<SearchService>().searchFoods(query);
                  },
                ),
                const SizedBox(height: 12),
                
                // Category Filter Chips
                CategoryFilterChips(
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                    if (category.isNotEmpty) {
                      context.read<SearchService>().searchByCategory(category);
                    } else {
                      // Nếu bỏ chọn category, tìm lại theo query hiện tại
                      context.read<SearchService>().searchFoods(_searchController.text);
                    }
                  },
                ),
              ],
            ),
          ),
          
          // Search Results
          Expanded(
            child: Consumer<SearchService>(
              builder: (context, searchService, child) {
                if (searchService.isSearching) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (searchService.currentQuery.isEmpty && _selectedCategory.isEmpty) {
                  return SearchSuggestions(
                    onSuggestionTap: (suggestion) {
                      _searchController.text = suggestion;
                      searchService.searchFoods(suggestion);
                    },
                  );
                }
                
                if (searchService.searchResults.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Không tìm thấy kết quả',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Thử tìm kiếm với từ khóa khác',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return Column(
                  children: [
                    // Results Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            'Tìm thấy ${searchService.searchResults.length} kết quả',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () => _showSearchStats(context, searchService),
                            icon: const Icon(Icons.analytics_outlined, size: 18),
                            label: const Text('Thống kê'),
                          ),
                        ],
                      ),
                    ),
                    
                    // Results List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: searchService.searchResults.length,
                        itemBuilder: (context, index) {
                          final food = searchService.searchResults[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: FoodCard(
                              food: food,
                              onTap: () => _navigateToFoodDetail(context, food),
                              showProvince: true, // Hiển thị tỉnh/thành trong kết quả tìm kiếm
                              showCategory: true,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      
      // Floating Action Button for Random Suggestion
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _getRandomSuggestion(context),
        icon: const Icon(Icons.shuffle),
        label: const Text('Ngẫu nhiên'),
      ),
    );
  }
  
  void _navigateToFoodDetail(BuildContext context, FoodItem food) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FoodDetailScreen(
          food: food,
          province: food.province ?? '',
        ),
      ),
    );
  }
  
  void _getRandomSuggestion(BuildContext context) async {
    final searchService = context.read<SearchService>();
    final suggestions = await searchService.getRandomSuggestions(count: 1);
    
    if (suggestions.isNotEmpty && mounted) {
      final food = suggestions.first;
      _navigateToFoodDetail(context, food);
    }
  }
  
  void _showSearchStats(BuildContext context, SearchService searchService) {
    final stats = searchService.getSearchStats();
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thống kê kết quả tìm kiếm',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (stats.isEmpty)
              const Text('Chưa có dữ liệu thống kê')
            else
              ...stats.entries.map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(child: Text(entry.key)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${entry.value}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
