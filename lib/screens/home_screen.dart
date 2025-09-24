import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../models/province_food.dart';
import '../services/food_data_service.dart';
import '../services/favorites_service.dart';
import '../widgets/food_category_card.dart';
import 'food_detail_screen.dart';
import 'favorites_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedProvince;
  ProvinceFood? selectedProvinceFood;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await Future.wait([
        FoodDataService.instance.loadFoodData(),
        FavoritesService.instance.loadFavorites(),
      ]);
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _onProvinceChanged(String? province) {
    setState(() {
      selectedProvince = province;
      selectedProvinceFood = province != null 
          ? FoodDataService.instance.getFoodsByProvince(province)
          : null;
    });
  }

  void _onFoodTap(FoodItem food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailScreen(
          food: food,
          province: selectedProvince!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Đang tải dữ liệu...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Lỗi: $error',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    error = null;
                  });
                  _loadData();
                },
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đặc sản vùng miền Việt Nam',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red[700],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header với gradient
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.red[700]!,
                  Colors.red[500]!,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chọn tỉnh/thành phố',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedProvince,
                        hint: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red[700],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Chọn tỉnh/thành phố...',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        isExpanded: true,
                        items: FoodDataService.instance.provinces
                            .map((province) => DropdownMenuItem(
                                  value: province,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.red[700],
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        province,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: _onProvinceChanged,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Nội dung chính
          Expanded(
            child: selectedProvinceFood == null
                ? _buildWelcomeContent()
                : _buildFoodContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 80,
              color: Colors.red[300],
            ),
            const SizedBox(height: 24),
            Text(
              'Chào mừng đến với\nOneno Food',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Khám phá đặc sản vùng miền Việt Nam\nHãy chọn một tỉnh/thành phố để bắt đầu!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodContent() {
    final foodsByCategory = selectedProvinceFood!.getFoodsByCategory();
    final categoryIcons = {
      'Món chính': Icons.restaurant,
      'Ăn vặt': Icons.local_dining,
      'Đồ uống': Icons.local_cafe,
      'Quà mang về': Icons.card_giftcard,
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Đặc sản $selectedProvince',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.red[700],
          ),
        ),
        const SizedBox(height: 16),
        ...foodsByCategory.entries.map((entry) {
          final category = entry.key;
          final foods = entry.value;
          
          if (foods.isEmpty) return const SizedBox.shrink();
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FoodCategoryCard(
              title: category,
              icon: categoryIcons[category] ?? Icons.restaurant,
              foods: foods,
              onFoodTap: _onFoodTap,
            ),
          );
        }).toList(),
      ],
    );
  }
}
