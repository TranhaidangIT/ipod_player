# Classical Music Player - Flutter/Dart

Ứng dụng nghe nhạc cổ điển với giao diện lấy cảm hứng từ Apple iPod Classic và iTunes/iOS 5-6.

## Tính năng

- ✅ **Thư viện Album** - Danh sách album với kinetic scrolling
- ✅ **Cover Flow** - Hiệu ứng 3D carousel dọc với page view
- ✅ **Now Playing** - Màn hình phát nhạc với breathing animation
- ✅ **Queue** - Danh sách phát với drag & reorder
- ✅ **Library Hub** - Khám phá thư viện (Album, Nghệ Sĩ, Bài Hát, Playlist)
- ✅ **Search** - Tìm kiếm với real-time filtering
- ✅ **Dark/Light Mode** - Chế độ tối/sáng tự động

## Thiết kế

- **Palette**: Graphite, Silver, Aluminum (iPod Classic colors)
- **Animations**: Spring animations, kinetic momentum, breathing effects
- **Typography**: Material Design với custom sizing
- **UI Elements**: Brushed aluminum textures, soft shadows, glass effects

## Yêu cầu

- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Android Studio / VS Code
- Android SDK (cho Android)

## Cài đặt

1. **Clone repository hoặc copy Flutter code**

2. **Cài đặt dependencies:**
```bash
cd flutter_music_player
flutter pub get
```

3. **Chạy app:**
```bash
# Chạy trên emulator/device
flutter run

# Chạy ở chế độ release
flutter run --release
```

4. **Build APK cho Android:**
```bash
# Debug APK
flutter build apk

# Release APK
flutter build apk --release

# APK split per ABI (nhỏ hơn)
flutter build apk --split-per-abi
```

## Cấu trúc dự án

```
lib/
├── main.dart                 # Entry point
├── models/
│   └── album.dart           # Data models & sample data
├── providers/
│   └── theme_provider.dart  # Theme management
├── router/
│   └── app_router.dart      # GoRouter configuration
└── screens/
    ├── root_screen.dart          # Main layout với bottom nav
    ├── library_screen.dart       # Album library
    ├── coverflow_screen.dart     # 3D carousel
    ├── now_playing_screen.dart   # Full screen player
    ├── queue_screen.dart         # Play queue
    ├── library_hub_screen.dart   # Library categories
    └── search_screen.dart        # Search interface
```

## Dependencies chính

- **go_router**: Navigation & routing
- **provider**: State management
- **cached_network_image**: Image caching
- **flutter_animate**: Animations (optional)

## Custom Theme

App sử dụng custom theme với màu sắc iPod Classic:

### Light Mode
- Background: `#D8DCE3` → `#C5C9D0`
- Surface: `#E8EAED`
- Primary: `#5E6772` (Graphite)
- Secondary: `#9BA3AD` (Silver)

### Dark Mode
- Background: `#1A1D23` → `#0F1115`
- Surface: `#2A2D33`
- Primary: `#9BA3AD`
- Secondary: `#5E6772`

## Tips phát triển

1. **Hot Reload**: Sử dụng `r` trong terminal để hot reload
2. **Debugging**: Sử dụng Flutter DevTools
3. **Performance**: Profile với `flutter run --profile`
4. **Icons**: Thêm icons tùy chỉnh trong `pubspec.yaml`

## Build cho Production

```bash
# Android APK
flutter build apk --release --split-per-abi

# Android App Bundle (khuyến nghị cho Play Store)
flutter build appbundle --release

# iOS (cần macOS)
flutter build ios --release
```

## Tùy chỉnh

- Thay đổi màu sắc trong `lib/providers/theme_provider.dart`
- Thêm dữ liệu mẫu trong `lib/models/album.dart`
- Tùy chỉnh animations trong từng screen

## License

MIT License - Tự do sử dụng cho mục đích cá nhân và thương mại.
