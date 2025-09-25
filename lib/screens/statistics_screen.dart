import 'package:flutter/material.dart';
import '../services/food_data_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final FoodDataService _foodDataService = FoodDataService.instance;
  Map<String, int> _regionStats = {};
  Map<String, int> _categoryStats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      await _foodDataService.loadFoodData();
      
      setState(() {
        _regionStats = _foodDataService.getFoodStatsByRegion();
        _categoryStats = _foodDataService.getFoodStatsByCategory();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải thống kê: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStatistics,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overview Cards
                    _buildOverviewCards(),
                    
                    const SizedBox(height: 24),
                    
                    // Category Statistics
                    _buildSectionHeader('Thống kê theo danh mục', Icons.category),
                    const SizedBox(height: 12),
                    _buildCategoryStats(),
                    
                    const SizedBox(height: 24),
                    
                    // Region Statistics
                    _buildSectionHeader('Thống kê theo vùng miền', Icons.map),
                    const SizedBox(height: 12),
                    _buildRegionStats(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildOverviewCards() {
    final totalFoods = _regionStats.values.fold(0, (sum, count) => sum + count);
    final totalProvinces = _regionStats.length;
    final avgFoodsPerProvince = totalProvinces > 0 ? (totalFoods / totalProvinces).round() : 0;
    
    return Row(
      children: [
        Expanded(
          child: _buildOverviewCard(
            'Tổng món ăn',
            totalFoods.toString(),
            Icons.restaurant_menu,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOverviewCard(
            'Tỉnh/Thành phố',
            totalProvinces.toString(),
            Icons.location_city,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOverviewCard(
            'TB/Tỉnh',
            avgFoodsPerProvince.toString(),
            Icons.analytics,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
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
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryStats() {
    final sortedCategories = _categoryStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: sortedCategories.map((entry) {
            final percentage = _categoryStats.values.fold(0, (sum, count) => sum + count) > 0
                ? (entry.value / _categoryStats.values.fold(0, (sum, count) => sum + count) * 100)
                : 0.0;
            
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _buildStatBar(
                entry.key,
                entry.value,
                percentage,
                _getCategoryColor(entry.key),
                _getCategoryIcon(entry.key),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRegionStats() {
    final sortedRegions = _regionStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top 10 regions
            ...sortedRegions.take(10).map((entry) {
              final maxValue = sortedRegions.first.value;
              final percentage = maxValue > 0 ? (entry.value / maxValue * 100) : 0.0;
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: _buildStatBar(
                  entry.key,
                  entry.value,
                  percentage,
                  _getRegionColor(entry.key),
                  Icons.location_on,
                ),
              );
            }).toList(),
            
            if (sortedRegions.length > 10) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => _showAllRegions(sortedRegions),
                child: Text('Xem tất cả ${sortedRegions.length} tỉnh/thành phố'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatBar(String label, int value, double percentage, Color color, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              value.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
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

  Color _getRegionColor(String region) {
    // Tạo màu dựa trên hash của tên tỉnh
    final hash = region.hashCode;
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[hash.abs() % colors.length];
  }

  void _showAllRegions(List<MapEntry<String, int>> regions) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Tất cả tỉnh/thành phố',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: regions.length,
                  itemBuilder: (context, index) {
                    final entry = regions[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getRegionColor(entry.key),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(entry.key),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getRegionColor(entry.key).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${entry.value}',
                          style: TextStyle(
                            color: _getRegionColor(entry.key),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
