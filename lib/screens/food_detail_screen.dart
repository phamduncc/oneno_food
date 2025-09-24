import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../services/favorites_service.dart';
import '../services/share_service.dart';
import '../services/image_service.dart';
import '../l10n/app_localizations.dart';

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
      
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus 
                ? l10n.addedToFavorites
                : l10n.removedFromFavorites,
          ),
          backgroundColor: newStatus ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.error}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _shareFood() async {
    try {
      await ShareService.instance.shareFood(widget.food, widget.province);
    } catch (e) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.error}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showShareOptions() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.share,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  icon: Icons.share,
                  label: 'Chia sẻ',
                  onTap: () {
                    Navigator.pop(context);
                    _shareFood();
                  },
                ),
                _buildShareOption(
                  icon: Icons.facebook,
                  label: 'Facebook',
                  onTap: () {
                    Navigator.pop(context);
                    ShareService.instance.shareToSocialMedia('facebook', widget.food, widget.province);
                  },
                ),
                _buildShareOption(
                  icon: Icons.alternate_email,
                  label: 'Twitter',
                  onTap: () {
                    Navigator.pop(context);
                    ShareService.instance.shareToSocialMedia('twitter', widget.food, widget.province);
                  },
                ),
                _buildShareOption(
                  icon: Icons.qr_code,
                  label: 'QR Code',
                  onTap: () {
                    Navigator.pop(context);
                    ShareService.instance.shareQRCode(widget.food, widget.province);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.red[700],
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
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
                  // Ảnh món ăn với ImageService
                  ImageService.instance.buildFoodImage(
                    imagePath: widget.food.image,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
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
                    title: l10n.description,
                    icon: Icons.description,
                    content: widget.food.description,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Địa điểm nổi tiếng
                  _buildSection(
                    title: l10n.famousLocation,
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
                            isFavorite ? l10n.removeFromFavorites : l10n.addToFavorites,
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
                        onPressed: _showShareOptions,
                        icon: const Icon(Icons.share),
                        label: Text(l10n.share),
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
