import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông tin ứng dụng',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo và tên ứng dụng
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.restaurant_menu,
                size: 60,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'Oneno Food',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            
            Text(
              'Đặc sản vùng miền Việt Nam',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 32),
            
            // Thông tin ứng dụng
            _buildInfoSection(
              title: 'Giới thiệu',
              icon: Icons.info_outline,
              content: 'Oneno Food là ứng dụng giới thiệu đặc sản vùng miền Việt Nam, '
                      'giúp bạn khám phá những món ăn truyền thống đặc trưng của từng tỉnh thành. '
                      'Ứng dụng hoạt động hoàn toàn offline, không cần kết nối internet.',
            ),
            
            const SizedBox(height: 20),
            
            _buildInfoSection(
              title: 'Tính năng',
              icon: Icons.star_outline,
              content: '• Khám phá đặc sản 63 tỉnh thành Việt Nam\n'
                      '• Phân loại theo: Món chính, Ăn vặt, Đồ uống, Quà mang về\n'
                      '• Lưu danh sách món ăn yêu thích\n'
                      '• Thông tin chi tiết về từng món ăn\n'
                      '• Giao diện thân thiện, dễ sử dụng\n'
                      '• Hoạt động offline 100%',
            ),
            
            const SizedBox(height: 20),
            
            _buildInfoSection(
              title: 'Phiên bản',
              icon: Icons.update,
              content: 'Phiên bản 1.0.0\nCập nhật lần cuối: Tháng 9, 2024',
            ),
            
            const SizedBox(height: 32),
            
            // Nút hành động
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _shareApp(context),
                    icon: const Icon(Icons.share),
                    label: const Text('Chia sẻ ứng dụng'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _rateApp(context),
                    icon: const Icon(Icons.star),
                    label: const Text('Đánh giá'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Liên hệ và hỗ trợ
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.support_agent,
                          color: Colors.red[700],
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Hỗ trợ & Liên hệ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildContactItem(
                      icon: Icons.email,
                      title: 'Email',
                      subtitle: 'support@onenofood.com',
                      onTap: () => _copyToClipboard(context, 'support@onenofood.com'),
                    ),
                    _buildContactItem(
                      icon: Icons.phone,
                      title: 'Hotline',
                      subtitle: '1900 1234',
                      onTap: () => _copyToClipboard(context, '1900 1234'),
                    ),
                    _buildContactItem(
                      icon: Icons.web,
                      title: 'Website',
                      subtitle: 'www.onenofood.com',
                      onTap: () => _copyToClipboard(context, 'www.onenofood.com'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Footer
            Text(
              '© 2024 Oneno Food\nMade with ❤️ in Vietnam',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.red[700],
                ),
                const SizedBox(width: 12),
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
            Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.copy,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _shareApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng chia sẻ sẽ được cập nhật sớm!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _rateApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cảm ơn bạn! Tính năng đánh giá sẽ được cập nhật sớm!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép: $text'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
