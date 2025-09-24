import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../services/favorites_service.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodItem food;
  final String province;

  const FoodDetailScreen({
    super.key,
    required this.food,
    required this.province,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() {
    setState(() {
      isFavorite = FavoritesService.instance.isFavorite(widget.food);
    });
  }

  Future<void> _toggleFavorite() async {
    try {
      final newStatus = await FavoritesService.instance.toggleFavorite(widget.food);
      setState(() {
        isFavorite = newStatus;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus 
                ? 'Đã thêm vào danh sách yêu thích' 
                : 'Đã xóa khỏi danh sách yêu thích',
          ),
          backgroundColor: newStatus ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar với ảnh món ăn
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.red[700],
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Placeholder cho ảnh món ăn
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.red[300]!,
                          Colors.red[600]!,
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.restaurant_menu,
                      size: 120,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red[300] : Colors.white,
                ),
                onPressed: _toggleFavorite,
              ),
            ],
          ),
          // Nội dung chi tiết
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên món ăn và tỉnh
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.food.name,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.red[200]!,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.red[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.province,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Mô tả món ăn
                  _buildSection(
                    title: 'Mô tả',
                    icon: Icons.description,
                    content: widget.food.description,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Địa điểm nổi tiếng
                  _buildSection(
                    title: 'Địa điểm nổi tiếng',
                    icon: Icons.place,
                    content: widget.food.location,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Nút hành động
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _toggleFavorite,
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                          ),
                          label: Text(
                            isFavorite ? 'Bỏ yêu thích' : 'Yêu thích',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFavorite ? Colors.red[100] : Colors.red[700],
                            foregroundColor: isFavorite ? Colors.red[700] : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implement share functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tính năng chia sẻ sẽ được cập nhật sớm!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Chia sẻ'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.grey[700],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.red[700],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
