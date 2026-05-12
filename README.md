# 🎵 Offline Music Player

## 📱 Mô tả dự án
Ứng dụng nghe nhạc offline được xây dựng bằng Flutter, cho phép người dùng nghe nhạc từ thiết bị hoặc file có sẵn mà không cần kết nối internet.

## 🚀 Các tính năng chính
- Phát nhạc offline từ assets và thiết bị
- Hiển thị danh sách bài hát với ảnh bìa
- Màn hình Now Playing với album art
- Điều khiển phát nhạc (play/pause, next, previous)
- Thanh tiến trình tua nhạc
- Điều chỉnh âm lượng
- Bật/tắt chế độ shuffle
- Chế độ lặp (off / lặp tất cả / lặp 1 bài)
- Mini player hiển thị ở màn hình chính
- Tìm kiếm bài hát theo tên hoặc nghệ sĩ
- Tự động chuyển bài khi kết thúc

---

## 🖼️ Giao diện ứng dụng

<table align="center" cellpadding="10">
  <tr>
    <td align="center">
      <b>Trang chủ</b><br/>
      <img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/cdd105a5-a22a-473d-90e3-586d2024deac" />
    </td>
    <td align="center">
      <b>Đang phát</b><br/>
      <img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/69ecbde1-cfd3-40da-8f6f-982c82551b98" />
    </td>
    <td align="center">
      <b>Tìm kiếm</b><br/>
      <img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/91e7686e-92ce-4a4e-9af3-6f6cc71d70b3" />
    </td>
  </tr>
</table>

---

## 🛠️ Công nghệ sử dụng
- Flutter
- Provider (State Management)
- just_audio (phát nhạc)
- rxdart (stream management)
- shared_preferences (lưu cài đặt)
- path_provider

## 📂 Cấu trúc dự án
\```bash
lib/
├── models/
│   └── song_model.dart
├── providers/
│   ├── audio_provider.dart
│   ├── playlist_provider.dart
│   └── theme_provider.dart
├── screens/
│   ├── home_screen.dart
│   └── now_playing_screen.dart
├── services/
│   ├── audio_player_service.dart
│   ├── playlist_service.dart
│   ├── permission_service.dart
│   └── storage_service.dart
├── widgets/
│   ├── mini_player.dart
│   ├── song_tile.dart
│   ├── player_controls.dart
│   └── progress_bar.dart
└── main.dart
\```

---

## 🚀 Hướng dẫn chạy dự án

Clone project
\```bash
git clone https://github.com/NguyenNgocPhucBao/NguyenNgocPhucBao_2224802010776_Lab6
cd offline_music_player
\```

Cài đặt dependencies và chạy ứng dụng
\```bash
flutter pub get
flutter run
\```

---

## ⚠️ Hạn chế
- Chưa hỗ trợ playlist tùy chỉnh
- Chưa có equalizer
- Chưa hỗ trợ streaming online

## 🔮 Hướng phát triển
- Thêm tính năng tạo playlist
- Hỗ trợ equalizer
- Đồng bộ lên cloud
- Thêm widget ngoài màn hình khóa
