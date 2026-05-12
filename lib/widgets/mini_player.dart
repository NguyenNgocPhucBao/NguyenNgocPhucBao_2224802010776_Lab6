import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../screens/now_playing_screen.dart';
import '../services/audio_player_service.dart';
import '../utils/constants.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, provider, child) {
        final song = provider.currentSong;
        if (song == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NowPlayingScreen()),
          ),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Progress line
                StreamBuilder<PlaybackState>(
                  stream: provider.playbackStateStream,
                  builder: (context, snapshot) {
                    final progress = snapshot.data?.progress ?? 0.0;
                    return LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[800],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary),
                      minHeight: 2,
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // Album art
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey[800],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: song.albumArt != null
                                ? Image.asset(
                                    song.albumArt!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                        Icons.music_note,
                                        color: AppColors.grey),
                                  )
                                : const Icon(Icons.music_note,
                                    color: AppColors.grey),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Song info
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song.title,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                song.artist,
                                style: const TextStyle(
                                    color: AppColors.grey, fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Controls
                        StreamBuilder<bool>(
                          stream: provider.playingStream,
                          builder: (context, snapshot) {
                            final isPlaying = snapshot.data ?? false;
                            return IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: AppColors.white,
                                size: 32,
                              ),
                              onPressed: () => provider.playPause(),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next,
                              color: AppColors.white),
                          onPressed: () => provider.next(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}