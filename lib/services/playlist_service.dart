import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/song.dart';

/// PlaylistService - Tự động đồng bộ danh sách nhạc từ GitHub.
///
/// Cách hoạt động:
/// 1. Lần đầu mở app → tải playlist từ GitHub raw URL
/// 2. Lưu vào SharedPreferences (bộ nhớ local)
/// 3. Những lần sau → dùng bản local ngay lập tức + cập nhật nền
///
/// Để thêm bài mới: chỉ cần sửa file `music_playlist.json` trên GitHub
/// → app tự tải xuống lần mở tiếp theo (không cần rebuild app!)
class PlaylistService {
  /// URL tới file music_playlist.json trên GitHub của bạn
  static const String _playlistUrl =
      'https://raw.githubusercontent.com/TranhaidangIT/ipod_player/main/music_playlist.json';

  static const String _cacheKey = 'cached_playlist';
  static const String _versionKey = 'playlist_version';

  /// Lấy danh sách nhạc: ưu tiên cache local, cập nhật từ GitHub nền
  static Future<List<SongModel>> getPlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKey);

    List<SongModel> songs = songLibrary; // fallback mặc định

    if (cached != null) {
      try {
        songs = _parseSongs(jsonDecode(cached));
      } catch (_) {}
    }

    // Cập nhật từ GitHub nền (không chặn UI)
    _fetchAndCache().then((updated) {
      if (updated != null) {
        // Đã cập nhật vào cache, lần sau app restart sẽ dùng bản mới
        if (kDebugMode) print('✅ Playlist updated from GitHub');
      }
    });

    return songs;
  }

  /// Fetch từ GitHub và lưu cache, trả về list nếu thành công
  static Future<List<SongModel>?> _fetchAndCache() async {
    try {
      final response = await http.get(
        Uri.parse(_playlistUrl),
        headers: {'Cache-Control': 'no-cache'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final data = jsonDecode(response.body);
        
        // Chỉ cập nhật nếu version mới hơn
        final newVersion = data['version'] as String? ?? '0';
        final cachedVersion = prefs.getString(_versionKey) ?? '0';
        
        if (newVersion != cachedVersion) {
          await prefs.setString(_cacheKey, response.body);
          await prefs.setString(_versionKey, newVersion);
          return _parseSongs(data);
        }
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ Could not fetch playlist: $e');
    }
    return null;
  }

  static List<SongModel> _parseSongs(dynamic data) {
    final list = data['songs'] as List;
    return list.map((item) => SongModel(
      id: item['id'] as int,
      title: item['title'] as String,
      artist: item['artist'] as String,
      album: item['album'] as String,
      image: item['image'] as String,
      uri: item['uri'] as String,
      duration: item['duration'] as String,
    )).toList();
  }

  /// Xoá cache và tải lại từ GitHub
  static Future<List<SongModel>> forceRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_versionKey);
    return getPlaylist();
  }
}
