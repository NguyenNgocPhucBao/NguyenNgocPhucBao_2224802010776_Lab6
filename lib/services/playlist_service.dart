import 'dart:io';
import '../models/song_model.dart';

class PlaylistService {
  Future<List<SongModel>> getAllSongs() async {
    List<SongModel> songs = [];

    // Nhạc từ assets (chạy được trên web và Android)
    songs.addAll([
      SongModel(
        id: '1',
        title: 'Kept Promise',
        artist: 'Benjamin Lazzarus',
        album: 'Bensound',
        filePath: 'assets/audio/sample_songs/bensound-keptpromise.mp3',
        duration: const Duration(minutes: 3, seconds: 15),
        albumArt: 'assets/images/bai1.jpg',
      ),
      SongModel(
        id: '2',
        title: 'Watch The Sea',
        artist: 'Benjamin Lazzarus',
        album: 'Bensound',
        filePath: 'assets/audio/sample_songs/bensound-watchthesea.mp3',
        duration: const Duration(minutes: 4, seconds: 36),
        albumArt: 'assets/images/bai2.jpg',
      ),
    ]);

    // Đọc file từ thiết bị Android
    try {
      final directories = [
        '/sdcard/Music',
        '/sdcard/Download',
        '/sdcard/Downloads',
        '/storage/emulated/0/Music',
        '/storage/emulated/0/Download',
      ];

      for (final dirPath in directories) {
        final dir = Directory(dirPath);
        if (await dir.exists()) {
          final files = dir.listSync(recursive: true);
          for (final file in files) {
            if (file is File) {
              final path = file.path.toLowerCase();
              if (path.endsWith('.mp3') ||
                  path.endsWith('.m4a') ||
                  path.endsWith('.wav') ||
                  path.endsWith('.flac') ||
                  path.endsWith('.ogg')) {
                final name = file.path.split('/').last;
                final title = name.replaceAll(RegExp(r'\.[^.]+$'), '');
                songs.add(SongModel(
                  id: file.path.hashCode.toString(),
                  title: title,
                  artist: 'Unknown Artist',
                  filePath: file.path,
                  duration: Duration.zero,
                ));
              }
            }
          }
        }
      }
    } catch (e) {
      // ignore on web
    }

    return songs;
  }

  Future<List<SongModel>> searchSongs(String query) async {
    final all = await getAllSongs();
    final lower = query.toLowerCase();
    return all.where((s) {
      return s.title.toLowerCase().contains(lower) ||
          s.artist.toLowerCase().contains(lower) ||
          (s.album?.toLowerCase().contains(lower) ?? false);
    }).toList();
  }

  Future<List<SongModel>> getSongsByArtist(String artist) async {
    final all = await getAllSongs();
    return all.where((s) => s.artist == artist).toList();
  }
}