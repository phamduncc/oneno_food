# Oneno Food - Đặc sản vùng miền Việt Nam 🍲

Ứng dụng di động giới thiệu đặc sản vùng miền Việt Nam, hoạt động hoàn toàn offline.

## ✨ Tính năng chính

- 🗺️ **Khám phá đặc sản 34 đơn vị hành chính cấp tỉnh** - Tìm hiểu món ăn đặc trưng của từng vùng miền
- 🍽️ **Phân loại rõ ràng** - Món chính, Ăn vặt, Đồ uống, Quà mang về
- ❤️ **Danh sách yêu thích** - Lưu những món ăn bạn quan tâm
- 📱 **Giao diện thân thiện** - Thiết kế hiện đại, dễ sử dụng
- 🔌 **Hoạt động offline** - Không cần kết nối internet

## 🚀 Cách sử dụng

1. **Chọn tỉnh/thành phố** từ dropdown menu
2. **Duyệt qua các danh mục** món ăn
3. **Xem chi tiết** món ăn bạn quan tâm
4. **Thêm vào yêu thích** để lưu lại

## 🛠️ Công nghệ sử dụng

- **Flutter** - Framework phát triển ứng dụng
- **Dart** - Ngôn ngữ lập trình
- **JSON** - Lưu trữ dữ liệu offline
- **SharedPreferences** - Lưu danh sách yêu thích
- **Material Design 3** - Thiết kế giao diện

## 📁 Cấu trúc dự án

```
lib/
├── models/           # Data models
├── screens/          # UI screens
├── services/         # Business logic
├── widgets/          # Reusable widgets
└── main.dart        # Entry point

assets/
├── data/            # JSON data files
└── images/          # Image assets
```

## 🔧 Cài đặt và chạy

1. **Clone repository**
```bash
git clone <repository-url>
cd oneno_food
```

2. **Cài đặt dependencies**
```bash
flutter pub get
```

3. **Generate code**
```bash
flutter packages pub run build_runner build
```

4. **Chạy ứng dụng**
```bash
flutter run
```

## 📊 Dữ liệu

Ứng dụng chứa thông tin về:
- **Hà Nội**: Phở bò, Bún chả, Bánh cuốn Thanh Trì, Chả cá Lã Vọng...
- **Huế**: Bún bò Huế, Cơm hến, Bánh khoái, Chè Huế...
- **TP. Hồ Chí Minh**: Hủ tiếu Nam Vang, Bánh mì Sài Gòn, Bánh tráng nướng...
- **Đà Nẵng**: Mì Quảng, Cao lầu Hội An, Bánh xèo miền Trung...

## 🎯 Tính năng tương lai

- 🗺️ Tích hợp bản đồ offline
- 🎯 Gợi ý tour ẩm thực
- 📷 Scan QR code tại điểm du lịch
- 🌐 Hỗ trợ đa ngôn ngữ (Tiếng Anh)
- 📤 Chia sẻ lên mạng xã hội

## 📝 License

MIT License - Xem file [LICENSE](LICENSE) để biết thêm chi tiết.

## 👥 Đóng góp

Mọi đóng góp đều được chào đón! Hãy tạo issue hoặc pull request.

---

**Made with ❤️ in Vietnam**
