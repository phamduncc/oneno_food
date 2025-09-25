# Oneno Food - Đặc sản vùng miền Việt Nam 🍲

Ứng dụng di động giới thiệu đặc sản vùng miền Việt Nam, hoạt động hoàn toàn offline.

## ✨ Tính năng chính

### 🎯 **Core Features (v2.0)**
- 🗺️ **Khám phá đặc sản 34 đơn vị hành chính cấp tỉnh** - Tìm hiểu món ăn đặc trưng của từng vùng miền
- 🍽️ **Phân loại rõ ràng** - Món chính, Ăn vặt, Đồ uống, Quà mang về
- 🖼️ **Hình ảnh thực tế** - Hệ thống ImageService với 170+ ảnh món ăn authentic
- ❤️ **Danh sách yêu thích** - Lưu những món ăn bạn quan tâm
- 📱 **Giao diện thân thiện** - Thiết kế hiện đại, dễ sử dụng
- 🔌 **Hoạt động offline** - Không cần kết nối internet

### 🚀 **Advanced Features (v2.1 - NEW!)**
- 🔍 **Tìm kiếm thông minh** - Fuzzy search với loại bỏ dấu tiếng Việt
- 🏷️ **Lọc theo danh mục** - Filter chips hiện đại cho từng loại món ăn
- 🎲 **Gợi ý ngẫu nhiên** - Khám phá món ăn mới mỗi ngày
- 📊 **Thống kê chi tiết** - Phân tích số lượng món ăn theo vùng miền và danh mục
- 🎯 **Tìm kiếm đa tiêu chí** - Tìm theo tên, mô tả, địa điểm
- 📈 **Biểu đồ trực quan** - Progress bars và charts cho thống kê

## 🚀 Cách sử dụng

### 📱 **Khám phá cơ bản**
1. **Chọn tỉnh/thành phố** từ dropdown menu
2. **Duyệt qua các danh mục** món ăn
3. **Xem chi tiết** món ăn bạn quan tâm
4. **Thêm vào yêu thích** để lưu lại

### 🔍 **Tìm kiếm nâng cao**
1. **Tap vào icon Search** trên thanh navigation
2. **Nhập từ khóa** (tên món, mô tả, địa điểm)
3. **Sử dụng filter chips** để lọc theo danh mục
4. **Tap "Ngẫu nhiên"** để khám phá món ăn mới

### 📊 **Xem thống kê**
1. **Vào menu Statistics** để xem phân tích
2. **Khám phá top provinces** với nhiều món ăn nhất
3. **So sánh danh mục** món ăn khác nhau
4. **Xem biểu đồ trực quan** về dữ liệu ẩm thực

## 🛠️ Công nghệ sử dụng

### 🎯 **Core Technologies**
- **Flutter** - Framework phát triển ứng dụng
- **Dart** - Ngôn ngữ lập trình
- **JSON** - Lưu trữ dữ liệu offline
- **SharedPreferences** - Lưu danh sách yêu thích
- **Material Design 3** - Thiết kế giao diện

### 🚀 **Advanced Technologies (v2.1)**
- **Provider** - State management cho search và data
- **ImageService** - Smart image loading với caching
- **SearchService** - Fuzzy search với diacritics removal
- **Custom Widgets** - FoodCard, CategoryFilterChips, SearchSuggestions
- **Statistics Engine** - Real-time data analysis và visualization

## 📁 Cấu trúc dự án

```
lib/
├── models/           # Data models (FoodItem, ProvinceFood)
├── screens/          # UI screens
│   ├── home_screen.dart
│   ├── search_screen.dart      # NEW: Advanced search
│   ├── statistics_screen.dart  # NEW: Data analytics
│   ├── food_detail_screen.dart
│   ├── favorites_screen.dart
│   ├── settings_screen.dart
│   └── about_screen.dart
├── services/         # Business logic
│   ├── food_data_service.dart
│   ├── search_service.dart     # NEW: Smart search
│   ├── image_service.dart
│   ├── favorites_service.dart
│   └── language_service.dart
├── widgets/          # Reusable widgets
│   ├── food_card.dart          # NEW: Enhanced card
│   ├── category_filter_chips.dart  # NEW: Filter UI
│   ├── search_suggestions.dart     # NEW: Smart suggestions
│   └── food_category_card.dart
└── main.dart        # Entry point with Provider

assets/
├── data/            # JSON data files (34 provinces)
└── images/          # 170+ authentic food images
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

### 🏆 **Complete Coverage (v2.0)**
Ứng dụng chứa **170+ món ăn đặc sản** từ **34/34 đơn vị hành chính**:

#### **6 Thành phố Trực thuộc Trung ương**
- **Hà Nội**: Phở bò, Bún chả, Bánh cuốn Thanh Trì, Chả cá Lã Vọng
- **TP. Hồ Chí Minh**: Hủ tiếu Nam Vang, Bánh mì Sài Gòn, Bánh tráng nướng
- **Đà Nẵng**: Mì Quảng, Cao lầu Hội An, Bánh xèo miền Trung
- **Hải Phòng**: Bánh đa cua, Nem cua bể, Bánh mì que
- **Cần Thơ**: Bánh xèo miền Tây, Bánh cống, Lẩu mắm
- **Huế**: Bún bò Huế, Cơm hến, Bánh khoái, Chè Huế

#### **28 Tỉnh với đặc sản độc đáo**
- **Miền Bắc**: Lào Cai, Thái Nguyên, Phú Thọ, Bắc Ninh, Hưng Yên, Ninh Bình...
- **Miền Trung**: Nghệ An, Thanh Hóa, Quảng Trị, Quảng Ngãi, Khánh Hòa, Lâm Đồng...
- **Miền Nam**: Đồng Nai, Tây Ninh, Vĩnh Long, Đồng Tháp, Cà Mau, An Giang...

## 🎯 Roadmap v2.2

### 🔮 **Upcoming Features**
- 🌙 **Dark Mode** - Giao diện tối hiện đại
- ⭐ **Rating System** - Đánh giá và review món ăn
- 📄 **PDF Export** - Xuất danh sách yêu thích ra PDF
- 🗺️ **Map Integration** - Tích hợp bản đồ offline
- 🎯 **Food Tours** - Gợi ý tour ẩm thực theo tuyến đường
- 🔔 **Push Notifications** - Thông báo món ăn mới

### ✅ **Already Implemented (v1.1 & v2.0)**
- ✅ 📷 Scan QR code tại điểm du lịch
- ✅ 🌐 Hỗ trợ đa ngôn ngữ (Tiếng Anh)
- ✅ 📤 Chia sẻ lên mạng xã hội
- ✅ 🖼️ Real food images với ImageService
- ✅ 🔍 Advanced search với fuzzy matching
- ✅ 📊 Statistics và data analytics

## 📝 License

MIT License - Xem file [LICENSE](LICENSE) để biết thêm chi tiết.

## 👥 Đóng góp

Mọi đóng góp đều được chào đón! Hãy tạo issue hoặc pull request.

---

**Made with ❤️ in Vietnam**
