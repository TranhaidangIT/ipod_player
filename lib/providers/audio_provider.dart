import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

/// AudioProvider quản lý toàn bộ vòng đời phát nhạc.
/// Dùng Provider để các màn hình lắng nghe cập nhật theo thời gian thực.
class AudioProvider with ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  List<SongModel> _queue = List.from(songLibrary);
  int _currentIndex = 0;
  bool _isLoading = false;
  bool _isShuffle = false;
  LoopMode _loopMode = LoopMode.off;

  AudioProvider() {
    _initListeners();
    _buildQueue();
  }

  // ── Getters ──
  List<SongModel> get queue => _queue;
  int get currentIndex => _currentIndex;
  SongModel get currentSong => _queue[_currentIndex];
  bool get isPlaying => _player.playing;
  bool get isLoading => _isLoading;
  bool get isShuffle => _isShuffle;
  LoopMode get loopMode => _loopMode;
  Duration get position => _player.position;
  Duration get duration => _player.duration ?? Duration.zero;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  // ── Init ──
  void _initListeners() {
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _handleSongCompletion();
      }
      notifyListeners();
    });

    _player.currentIndexStream.listen((idx) {
      if (idx != null && idx != _currentIndex) {
        _currentIndex = idx;
        notifyListeners();
      }
    });

    _player.positionStream.listen((_) {
      notifyListeners();
    });
  }

  Future<void> _buildQueue() async {
    try {
      final sources = ConcatenatingAudioSource(
        useLazyPreparation: true, // Tối ưu: chỉ load khi cần
        children: _queue
            .map((s) => AudioSource.uri(Uri.parse(s.uri)))
            .toList(),
      );
      await _player.setAudioSource(sources, initialIndex: _currentIndex);
      await _player.setLoopMode(_loopMode);
      await _player.setShuffleModeEnabled(_isShuffle);
    } catch (e) {
      if (kDebugMode) print('AudioProvider._buildQueue error: $e');
    }
  }

  void _handleSongCompletion() {
    switch (_loopMode) {
      case LoopMode.one:
        _player.seek(Duration.zero);
        _player.play();
        break;
      case LoopMode.all:
        next();
        break;
      case LoopMode.off:
        if (_currentIndex < _queue.length - 1) {
          next();
        }
        break;
    }
  }

  // ── Controls ──

  Future<void> playSong(int index) async {
    if (index < 0 || index >= _queue.length) return;
    try {
      _isLoading = true;
      notifyListeners();
      await _player.seek(Duration.zero, index: index);
      await _player.play();
    } catch (e) {
      if (kDebugMode) print('playSong error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> togglePlay() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
    notifyListeners();
  }

  Future<void> next() async {
    if (_currentIndex < _queue.length - 1) {
      await playSong(_currentIndex + 1);
    } else if (_loopMode == LoopMode.all) {
      await playSong(0);
    }
  }

  Future<void> previous() async {
    if (_player.position.inSeconds > 3) {
      await _player.seek(Duration.zero);
    } else if (_currentIndex > 0) {
      await playSong(_currentIndex - 1);
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
    notifyListeners();
  }

  Future<void> toggleShuffle() async {
    _isShuffle = !_isShuffle;
    await _player.setShuffleModeEnabled(_isShuffle);
    notifyListeners();
  }

  Future<void> toggleLoop() async {
    switch (_loopMode) {
      case LoopMode.off:
        _loopMode = LoopMode.all;
        break;
      case LoopMode.all:
        _loopMode = LoopMode.one;
        break;
      case LoopMode.one:
        _loopMode = LoopMode.off;
        break;
    }
    await _player.setLoopMode(_loopMode);
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
