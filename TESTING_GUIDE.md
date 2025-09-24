# 📱 Hướng dẫn Test Ứng dụng Oneno Food trên Thiết bị Di động

## 🔧 Chuẩn bị

### Yêu cầu hệ thống:
- **Android**: API level 21+ (Android 5.0+)
- **iOS**: iOS 12.0+
- **RAM**: Tối thiểu 2GB
- **Dung lượng**: ~50MB

### Thiết bị đã test:
- ✅ **SM N976N** (Android 12) - Đã build và chạy thành công

## 🚀 Các cách build và test

### 1. Debug Build (Development)
```bash
# Chạy trực tiếp trên thiết bị kết nối
flutter run -d <device_id>

# Ví dụ với thiết bị Android
flutter run -d R3CM808FX6J
```

### 2. Release Build (Production)
```bash
# Build APK cho Android
flutter build apk --release

# Build AAB cho Google Play Store
flutter build appbundle --release

# Build IPA cho iOS (cần macOS)
flutter build ios --release
```

### 3. Profile Build (Performance Testing)
```bash
# Test hiệu suất
flutter run --profile -d <device_id>
```

## 📋 Checklist Test

### ✅ Tính năng cơ bản
- [ ] Mở ứng dụng thành công
- [ ] Dropdown tỉnh/thành phố hoạt động
- [ ] Hiển thị danh sách món ăn theo danh mục
- [ ] Navigation giữa các màn hình
- [ ] Scroll mượt mà

### ✅ Tính năng yêu thích
- [ ] Thêm món ăn vào yêu thích
- [ ] Xóa món ăn khỏi yêu thích
- [ ] Lưu trữ offline (đóng mở app vẫn giữ dữ liệu)
- [ ] Xóa tất cả yêu thích

### ✅ Giao diện
- [ ] Responsive trên các kích thước màn hình
- [ ] Theme màu đỏ hiển thị đúng
- [ ] Icons và typography rõ ràng
- [ ] Animation mượt mà

### ✅ Hiệu suất
- [ ] Thời gian khởi động < 3 giây
- [ ] Không lag khi scroll
- [ ] Bộ nhớ sử dụng hợp lý
- [ ] Pin không tụt nhanh

### ✅ Offline
- [ ] Hoạt động khi không có internet
- [ ] Dữ liệu load từ JSON local
- [ ] Yêu thích lưu trong SharedPreferences

## 🐛 Test Cases

### Test Case 1: Khởi động ứng dụng
1. Mở ứng dụng lần đầu
2. Kiểm tra loading screen
3. Verify màn hình chính hiển thị đúng

### Test Case 2: Chọn tỉnh thành
1. Click dropdown tỉnh/thành phố
2. Chọn "Hà Nội"
3. Verify hiển thị đúng 4 danh mục món ăn

### Test Case 3: Xem chi tiết món ăn
1. Click vào "Phở bò"
2. Verify màn hình chi tiết hiển thị đầy đủ
3. Test nút yêu thích

### Test Case 4: Quản lý yêu thích
1. Thêm 3 món ăn vào yêu thích
2. Vào màn hình yêu thích
3. Xóa 1 món, verify cập nhật
4. Đóng mở app, verify dữ liệu vẫn còn

### Test Case 5: Navigation
1. Test back button
2. Test navigation drawer/tabs
3. Test deep linking (nếu có)

## 📊 Performance Metrics

### Thời gian phản hồi mong đợi:
- **App startup**: < 3s
- **Screen transition**: < 500ms
- **Data loading**: < 1s
- **Search**: < 300ms

### Memory usage:
- **Idle**: < 100MB
- **Active**: < 150MB
- **Peak**: < 200MB

## 🔍 Debug Tools

### Flutter Inspector
```bash
# Mở DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

### Performance Profiling
```bash
# Profile mode
flutter run --profile

# Analyze bundle size
flutter build apk --analyze-size
```

### Logs
```bash
# View device logs
flutter logs

# Specific device
flutter logs -d <device_id>
```

## 📱 Test trên nhiều thiết bị

### Android
- **Low-end**: RAM 2GB, API 21
- **Mid-range**: RAM 4GB, API 28
- **High-end**: RAM 8GB+, API 33+

### Screen sizes
- **Small**: 5" (480x854)
- **Medium**: 6" (720x1280)
- **Large**: 6.5"+ (1080x1920+)

### Orientations
- Portrait (chính)
- Landscape (nếu support)

## 🚨 Common Issues & Solutions

### Issue 1: Build failed
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk
```

### Issue 2: App crashes on startup
- Check Android API level compatibility
- Verify permissions in AndroidManifest.xml
- Check for missing dependencies

### Issue 3: Performance issues
- Use `flutter run --profile` to identify bottlenecks
- Optimize images and assets
- Check for memory leaks

### Issue 4: UI không responsive
- Test trên nhiều kích thước màn hình
- Sử dụng MediaQuery và LayoutBuilder
- Kiểm tra overflow issues

## ✅ Sign-off Criteria

Ứng dụng được coi là PASS khi:
- [ ] Tất cả test cases PASS
- [ ] Performance metrics đạt yêu cầu
- [ ] Không có crash hoặc ANR
- [ ] UI hiển thị đúng trên tất cả thiết bị test
- [ ] Offline functionality hoạt động 100%

---

**📝 Ghi chú**: Document này sẽ được cập nhật khi có thêm tính năng mới hoặc phát hiện issues trong quá trình test.
