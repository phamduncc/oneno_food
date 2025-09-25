import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageService {
  static ImageService? _instance;
  static ImageService get instance => _instance ??= ImageService._();
  
  ImageService._();

  /// Cache for loaded images to improve performance
  final Map<String, ImageProvider> _imageCache = {};

  /// Get image provider with fallback to placeholder
  ImageProvider getImageProvider(String imagePath) {
    // Check cache first
    if (_imageCache.containsKey(imagePath)) {
      return _imageCache[imagePath]!;
    }

    ImageProvider provider;
    
    // Try to load from assets
    if (imagePath.startsWith('assets/')) {
      provider = AssetImage(imagePath);
    } else {
      // Fallback for old format - add assets/ prefix
      provider = AssetImage('assets/images/$imagePath');
    }

    // Cache the provider
    _imageCache[imagePath] = provider;
    return provider;
  }

  /// Get image widget with error handling and loading states
  Widget buildFoodImage({
    required String imagePath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image(
          image: getImageProvider(imagePath),
          width: width,
          height: height,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            
            return Container(
              width: width,
              height: height,
              color: Colors.grey[100],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red[700]!),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderImage(width, height, imagePath);
          },
        ),
      ),
    );
  }

  /// Build placeholder image when real image fails to load
  Widget _buildPlaceholderImage(double? width, double? height, String imagePath) {
    // Determine icon based on image name
    IconData icon = _getIconForImagePath(imagePath);
    
    return Container(
      width: width,
      height: height,
      color: Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: (width != null && width < 100) ? 24 : 48,
            color: Colors.red[300],
          ),
          if (width == null || width >= 100) ...[
            const SizedBox(height: 8),
            Text(
              'Ảnh đang cập nhật',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Get appropriate icon based on image path/name
  IconData _getIconForImagePath(String imagePath) {
    final fileName = imagePath.toLowerCase();
    
    // Main dishes
    if (fileName.contains('pho') || 
        fileName.contains('bun') || 
        fileName.contains('com') ||
        fileName.contains('chao') ||
        fileName.contains('lau')) {
      return Icons.restaurant;
    }
    
    // Snacks
    if (fileName.contains('banh') || 
        fileName.contains('nem') || 
        fileName.contains('cha')) {
      return Icons.local_dining;
    }
    
    // Drinks
    if (fileName.contains('che') || 
        fileName.contains('nuoc') || 
        fileName.contains('ca_phe') ||
        fileName.contains('tra') ||
        fileName.contains('ruou')) {
      return Icons.local_cafe;
    }
    
    // Souvenirs
    if (fileName.contains('keo') || 
        fileName.contains('banh_pia') || 
        fileName.contains('me_xung') ||
        fileName.contains('muoi') ||
        fileName.contains('mam') ||
        fileName.contains('gao') ||
        fileName.contains('mat_ong')) {
      return Icons.card_giftcard;
    }
    
    // Default
    return Icons.fastfood;
  }

  /// Preload images for better performance
  Future<void> preloadImages(BuildContext context, List<String> imagePaths) async {
    for (final path in imagePaths) {
      try {
        final provider = getImageProvider(path);
        await precacheImage(provider, context);
      } catch (e) {
        // Ignore preload errors - will show placeholder when needed
        debugPrint('Failed to preload image: $path');
      }
    }
  }

  /// Clear image cache to free memory
  void clearCache() {
    _imageCache.clear();
  }

  /// Get cache size for debugging
  int get cacheSize => _imageCache.length;

  /// Check if image exists in assets
  Future<bool> imageExists(String imagePath) async {
    try {
      await rootBundle.load(imagePath);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get all image paths from a food data structure
  List<String> extractImagePaths(Map<String, dynamic> foodData) {
    final List<String> imagePaths = [];
    
    for (final province in foodData.values) {
      if (province is Map<String, dynamic>) {
        for (final category in province.values) {
          if (category is List) {
            for (final food in category) {
              if (food is Map<String, dynamic> && food['image'] != null) {
                imagePaths.add(food['image'].toString());
              }
            }
          }
        }
      }
    }
    
    return imagePaths;
  }

  /// Generate placeholder images for development
  static const List<String> sampleFoodImages = [
    'assets/images/pho_bo.jpg',
    'assets/images/bun_cha.jpg',
    'assets/images/banh_mi.jpg',
    'assets/images/com_tam.jpg',
    'assets/images/cao_lau.jpg',
    'assets/images/mi_quang.jpg',
    'assets/images/banh_xeo.jpg',
    'assets/images/nem_nuong.jpg',
    'assets/images/ca_phe_sua_da.jpg',
    'assets/images/che_ba_mau.jpg',
  ];

  /// Get a sample image for development/demo purposes
  String getSampleImage(String category) {
    switch (category.toLowerCase()) {
      case 'món chính':
        return sampleFoodImages[0]; // Pho
      case 'ăn vặt':
        return sampleFoodImages[6]; // Banh xeo
      case 'đồ uống':
        return sampleFoodImages[8]; // Ca phe
      case 'quà mang về':
        return sampleFoodImages[9]; // Che
      default:
        return sampleFoodImages[0];
    }
  }
}
