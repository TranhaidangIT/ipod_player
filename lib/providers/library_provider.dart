import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart' hide SongModel;
import 'package:permission_handler/permission_handler.dart';
import '../models/song.dart';

class LibraryProvider with ChangeNotifier {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _songs = [];
  bool _isLoading = false;

  List<SongModel> get songs => _songs;
  bool get isLoading => _isLoading;

  Future<void> requestPermissionAndLoadSongs() async {
    _isLoading = true;
    notifyListeners();

    if (kIsWeb) {
      // Web doesn't support local audio querying via on_audio_query
      _songs = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    bool permissionStatus = false;
    
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (await Permission.audio.request().isGranted) {
        permissionStatus = true;
      } else if (await Permission.storage.request().isGranted) {
        permissionStatus = true;
      }
    } else {
      try {
        permissionStatus = await _audioQuery.permissionsStatus();
        if (!permissionStatus) {
          permissionStatus = await _audioQuery.permissionsRequest();
        }
      } catch (e) {
        if (kDebugMode) print("Permission check failed: \$e");
      }
    }

    if (permissionStatus) {
      await loadSongs();
    } else {
      if (kDebugMode) {
        print("Permission denied to read audio files.");
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSongs() async {
    try {
      List<SongModel> queriedSongs = await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      ).then((value) => value.map((q) => SongModel.fromAudioQuery(q)).toList());

      _songs = queriedSongs;
    } catch (e) {
       if (kDebugMode) {
        print("Error loading songs: \$e");
      }
    }
    _isLoading = false;
    notifyListeners();
  }
}
