import 'package:flutter/material.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';
import '../services/storage_service.dart';

class PlaylistProvider extends ChangeNotifier {
  final StorageService _storageService;
  List<PlaylistModel> _playlists = [];

  PlaylistProvider(this._storageService) {
    _loadPlaylists();
  }

  List<PlaylistModel> get playlists => _playlists;

  Future<void> _loadPlaylists() async {
    _playlists = await _storageService.getPlaylists();

    // Tạo playlist mẫu nếu chưa có
    if (_playlists.isEmpty) {
      final defaultPlaylist = PlaylistModel(
        id: 'default',
        name: 'Yêu thích',
        songIds: ['1', '2'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _playlists.add(defaultPlaylist);
      await _storageService.savePlaylists(_playlists);
    }

    notifyListeners();
  }

  Future<void> createPlaylist(String name) async {
    final playlist = PlaylistModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      songIds: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _playlists.add(playlist);
    await _storageService.savePlaylists(_playlists);
    notifyListeners();
  }

  Future<void> deletePlaylist(String playlistId) async {
    _playlists.removeWhere((p) => p.id == playlistId);
    await _storageService.savePlaylists(_playlists);
    notifyListeners();
  }

  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    final index = _playlists.indexWhere((p) => p.id == playlistId);
    if (index != -1) {
      final playlist = _playlists[index];
      if (!playlist.songIds.contains(songId)) {
        _playlists[index] = playlist.copyWith(
          songIds: [...playlist.songIds, songId],
        );
        await _storageService.savePlaylists(_playlists);
        notifyListeners();
      }
    }
  }

  Future<void> removeSongFromPlaylist(
      String playlistId, String songId) async {
    final index = _playlists.indexWhere((p) => p.id == playlistId);
    if (index != -1) {
      final playlist = _playlists[index];
      _playlists[index] = playlist.copyWith(
        songIds: playlist.songIds.where((id) => id != songId).toList(),
      );
      await _storageService.savePlaylists(_playlists);
      notifyListeners();
    }
  }

  List<SongModel> getSongsInPlaylist(
      PlaylistModel playlist, List<SongModel> allSongs) {
    return allSongs
        .where((s) => playlist.songIds.contains(s.id))
        .toList();
  }
}