import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class PlaybackState {
  final Duration position;
  final Duration duration;
  final bool isPlaying;

  PlaybackState({
    required this.position,
    required this.duration,
    required this.isPlaying,
  });

  double get progress {
    if (duration.inMilliseconds > 0) {
      return position.inMilliseconds / duration.inMilliseconds;
    }
    return 0.0;
  }
}

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Thêm stream cho volume
  double _volume = 1.0;
  final _volumeController = StreamController<double>.broadcast();

  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<bool> get playingStream => _audioPlayer.playingStream;
  Stream<double> get volumeStream => _volumeController.stream;

  Duration get currentPosition => _audioPlayer.position;
  Duration? get currentDuration => _audioPlayer.duration;
  bool get isPlaying => _audioPlayer.playing;
  double get currentVolume => _volume;

  Stream<PlaybackState> get playbackStateStream {
    return Rx.combineLatest3<Duration, Duration?, bool, PlaybackState>(
      positionStream,
      durationStream,
      playingStream,
      (position, duration, isPlaying) => PlaybackState(
        position: position,
        duration: duration ?? Duration.zero,
        isPlaying: isPlaying,
      ),
    );
  }

  Future<void> loadAudio(String filePath) async {
    try {
      if (filePath.startsWith('assets/')) {
        await _audioPlayer.setAsset(filePath);
      } else {
        await _audioPlayer.setFilePath(filePath);
      }
    } catch (e) {
      throw Exception('Error loading audio: $e');
    }
  }

  Future<void> play() async => await _audioPlayer.play();
  Future<void> pause() async => await _audioPlayer.pause();
  Future<void> stop() async => await _audioPlayer.stop();

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> setVolume(double volume) async {
    _volume = volume;
    await _audioPlayer.setVolume(volume);
    _volumeController.add(volume); // Thông báo UI cập nhật
  }

  Future<void> setSpeed(double speed) async {
    await _audioPlayer.setSpeed(speed);
  }

  Future<void> setLoopMode(LoopMode loopMode) async {
    await _audioPlayer.setLoopMode(loopMode);
  }

  void dispose() {
    _volumeController.close();
    _audioPlayer.dispose();
  }
}