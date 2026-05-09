import 'dart:io';
import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../utils/constants.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final VoidCallback onTap;
  final bool isPlaying;

  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: _buildAlbumArt(),
      title: Text(
        song.title,
        style: TextStyle(
          color: isPlaying ? AppColors.primary : AppColors.white,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        song.artist,
        style: const TextStyle(color: AppColors.grey),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert, color: AppColors.grey),
        onPressed: () => _showOptionsMenu(context),
      ),
      onTap: onTap,
    );
  }

  Widget _buildAlbumArt() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.cardBackground,
      ),
      child: song.albumArt != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.file(File(song.albumArt!), fit: BoxFit.cover),
            )
          : const Icon(Icons.music_note, color: AppColors.grey),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.playlist_add,
                  color: AppColors.white),
              title: const Text('Thêm vào playlist',
                  style: TextStyle(color: AppColors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading:
                  const Icon(Icons.info_outline, color: AppColors.white),
              title: const Text('Thông tin bài hát',
                  style: TextStyle(color: AppColors.white)),
              onTap: () {
                Navigator.pop(context);
                _showSongInfo(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  void _showSongInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Thông tin bài hát',
            style: TextStyle(color: AppColors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow('Tên', song.title),
            _infoRow('Nghệ sĩ', song.artist),
            _infoRow('Album', song.album ?? 'Không rõ'),
            _infoRow(
                'Thời lượng',
                song.duration != null
                    ? '${song.duration!.inMinutes}:${(song.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
                    : 'Không rõ'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: '$label: ',
                style: const TextStyle(
                    color: AppColors.grey, fontSize: 14)),
            TextSpan(
                text: value,
                style: const TextStyle(
                    color: AppColors.white, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}