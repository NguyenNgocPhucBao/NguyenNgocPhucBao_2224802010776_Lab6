import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/playlist_provider.dart';
import '../utils/constants.dart';

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
      body: Consumer<PlaylistProvider>(
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
                      style: TextStyle(color: AppColors.white, fontSize: 18)),
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
              );
            },
          );
        },
      ),
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