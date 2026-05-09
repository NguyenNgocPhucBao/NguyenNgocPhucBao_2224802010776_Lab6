import 'package:on_audio_query/on_audio_query.dart';
import '../models/song_model.dart' as app_model;

class PlaylistService {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<app_model.SongModel>> getAllSongs() async {
    try {
      final List<SongModel> audioList = await _audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      return audioList
          .map((a) => app_model.SongModel.fromAudioQuery(a))
          .toList();
    } catch (e) {
      throw Exception('Error loading songs: $e');
    }
  }

  Future<List<app_model.SongModel>> searchSongs(String query) async {
    final all = await getAllSongs();
    final lower = query.toLowerCase();
    return all.where((s) {
      return s.title.toLowerCase().contains(lower) ||
          s.artist.toLowerCase().contains(lower) ||
          (s.album?.toLowerCase().contains(lower) ?? false);
    }).toList();
  }

  Future<List<app_model.SongModel>> getSongsByArtist(String artist) async {
    final all = await getAllSongs();
    return all.where((s) => s.artist == artist).toList();
  }
}