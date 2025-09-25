import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/food_item.dart';

class ShareService {
  static ShareService? _instance;
  static ShareService get instance => _instance ??= ShareService._();
  
  ShareService._();

  /// Share food item details
  Future<void> shareFood(FoodItem food, String province) async {
    final text = '''
🍲 ${food.name} - Đặc sản $province

📝 Mô tả: ${food.description}

📍 Địa điểm nổi tiếng: ${food.location}

---
Khám phá thêm đặc sản Việt Nam với ứng dụng Oneno Food!
#OnenoFood #ĐặcsảnViệtNam #$province
''';

    try {
      await Share.share(
        text,
        subject: '${food.name} - Đặc sản $province',
      );
    } catch (e) {
      throw Exception('Không thể chia sẻ: $e');
    }
  }

  /// Share app download link
  Future<void> shareApp() async {
    const text = '''
🍲 Oneno Food - Đặc sản vùng miền Việt Nam

Khám phá đặc sản 63 tỉnh thành Việt Nam ngay trên điện thoại!

✨ Tính năng:
• Thông tin chi tiết về món ăn truyền thống
• Phân loại rõ ràng theo danh mục
• Lưu danh sách yêu thích
• Hoạt động offline 100%

Tải ngay để khám phá ẩm thực Việt Nam!
#OnenoFood #ĐặcsảnViệtNam #ẨmthựcViệt
''';

    try {
      await Share.share(text, subject: 'Oneno Food - Đặc sản vùng miền Việt Nam');
    } catch (e) {
      throw Exception('Không thể chia sẻ ứng dụng: $e');
    }
  }

  /// Share to specific social media platform
  Future<void> shareToSocialMedia(
    String platform,
    FoodItem food,
    String province,
  ) async {
    final text = '${food.name} - Đặc sản $province. ${food.description}';
    final hashtags = '#OnenoFood #ĐặcsảnViệtNam #$province';
    
    String url;
    
    switch (platform.toLowerCase()) {
      case 'facebook':
        url = 'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent('https://onenofood.com')}&quote=${Uri.encodeComponent('$text $hashtags')}';
        break;
      case 'twitter':
        url = 'https://twitter.com/intent/tweet?text=${Uri.encodeComponent('$text $hashtags')}';
        break;
      case 'instagram':
        // Instagram doesn't support direct sharing via URL, so we'll copy to clipboard
        await Share.share('$text $hashtags');
        return;
      default:
        await Share.share('$text $hashtags');
        return;
    }

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to regular share
        await Share.share('$text $hashtags');
      }
    } catch (e) {
      throw Exception('Không thể chia sẻ lên $platform: $e');
    }
  }

  /// Generate QR code data for food item
  String generateQRData(FoodItem food, String province) {
    return 'oneno_food:$province:${food.name}';
  }

  /// Share QR code for food item
  Future<void> shareQRCode(FoodItem food, String province) async {
    final qrData = generateQRData(food, province);
    final text = '''
📱 Quét mã QR để xem chi tiết món ăn:

${food.name} - $province

Mã QR: $qrData

Sử dụng ứng dụng Oneno Food để quét mã này!
''';

    try {
      await Share.share(text, subject: 'QR Code - ${food.name}');
    } catch (e) {
      throw Exception('Không thể chia sẻ mã QR: $e');
    }
  }

  /// Open app store for rating
  Future<void> openAppStore() async {
    // For demo purposes, we'll open a placeholder URL
    const url = 'https://play.google.com/store/apps/details?id=com.app.oneno_food';
    
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Không thể mở cửa hàng ứng dụng');
      }
    } catch (e) {
      throw Exception('Lỗi khi mở cửa hàng ứng dụng: $e');
    }
  }

  /// Open email client for support
  Future<void> sendSupportEmail() async {
    const email = 'support@onenofood.com';
    const subject = 'Hỗ trợ Oneno Food';
    const body = 'Xin chào,\n\nTôi cần hỗ trợ về ứng dụng Oneno Food.\n\nChi tiết vấn đề:\n';
    
    final url = 'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
    
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception('Không thể mở ứng dụng email');
      }
    } catch (e) {
      throw Exception('Lỗi khi mở email: $e');
    }
  }

  /// Open website
  Future<void> openWebsite() async {
    const url = 'https://www.onenofood.com';
    
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Không thể mở website');
      }
    } catch (e) {
      throw Exception('Lỗi khi mở website: $e');
    }
  }
}
