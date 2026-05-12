import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../providers/playlist_provider.dart';
import '../services/playlist_service.dart';
import '../utils/constants.dart';
import '../widgets/mini_player.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Playlist',
            style: TextStyle(color: AppColors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.white),
            onPressed: () => _showCreatePlaylist(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<PlaylistProvider>(
              builder: (context, provider, child) {
                if (provider.playlists.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.queue_music,
                            size: 80, color: AppColors.grey),
                        const SizedBox(height: 16),
                        const Text('Chưa có playlist nào',
                            style: TextStyle(
                                color: AppColors.white, fontSize: 18)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary),
                          onPressed: () => _showCreatePlaylist(context),
                          child: const Text('Tạo playlist',
                              style: TextStyle(color: AppColors.white)),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: provider.playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = provider.playlists[index];
                    return ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.queue_music,
                            color: AppColors.primary),
                      ),
                      title: Text(playlist.name,
                          style: const TextStyle(color: AppColors.white)),
                      subtitle: Text('${playlist.songIds.length} bài hát',
                          style: const TextStyle(color: AppColors.grey)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: AppColors.grey),
                        onPressed: () => provider.deletePlaylist(playlist.id),
                      ),
                      onTap: () =>
                          _showPlaylistDetail(context, provider, index),
                    );
                  },
                );
              },
            ),
          ),
          const MiniPlayer(),
        ],
      ),
    );
  }

  void _showPlaylistDetail(
      BuildContext context, PlaylistProvider provider, int index) async {
    final playlist = provider.playlists[index];
    final audioProvider = context.read<AudioProvider>();

    final playlistService = PlaylistService();
    final List<SongModel> allSongs = await playlistService.getAllSongs();

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final songs = allSongs
            .where((s) => playlist.songIds.contains(s.id))
            .toList();

        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  playlist.name,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${songs.length} bài hát',
                  style: const TextStyle(color: AppColors.grey),
                ),
                const SizedBox(height: 8),
                const Divider(color: AppColors.grey),
                Expanded(
                  child: songs.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'Chưa có bài hát nào\nThêm nhạc từ tab Nhạc',
                              style: TextStyle(color: AppColors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: songs.length,
                          itemBuilder: (ctx, i) {
                            final song = songs[i];
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: song.albumArt != null
                                    ? Image.asset(
                                        song.albumArt!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.music_note,
                                                color: AppColors.primary),
                                      )
                                    : const Icon(Icons.music_note,
                                        color: AppColors.primary),
                              ),
                              title: Text(song.title,
                                  style: const TextStyle(
                                      color: AppColors.white)),
                              subtitle: Text(song.artist,
                                  style: const TextStyle(
                                      color: AppColors.grey)),
                              trailing: IconButton(
                                icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: AppColors.grey),
                                onPressed: () {
                                  provider.removeSongFromPlaylist(
                                      playlist.id, song.id);
                                  Navigator.pop(ctx);
                                },
                              ),
                              onTap: () {
                                audioProvider.setPlaylist(
                                    allSongs, allSongs.indexOf(song));
                                Navigator.pop(ctx);
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCreatePlaylist(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Tạo playlist mới',
            style: TextStyle(color: AppColors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: AppColors.white),
          decoration: const InputDecoration(
            hintText: 'Tên playlist',
            hintStyle: TextStyle(color: AppColors.grey),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.grey)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huỷ',
                style: TextStyle(color: AppColors.grey)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context
                    .read<PlaylistProvider>()
                    .createPlaylist(controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Tạo',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}