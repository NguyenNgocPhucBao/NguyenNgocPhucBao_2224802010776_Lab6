import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../services/audio_player_service.dart';
import '../utils/constants.dart';
import '../widgets/player_controls.dart';
import '../widgets/progress_bar.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<AudioProvider>(
        builder: (context, provider, child) {
          final song = provider.currentSong;
          if (song == null) {
            return const Center(
              child: Text('Không có bài hát nào',
                  style: TextStyle(color: AppColors.white)),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Album art
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.cardBackground,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: song.albumArt != null
                                ? Image.file(File(song.albumArt!),
                                    fit: BoxFit.cover)
                                : const Icon(Icons.music_note,
                                    size: 100, color: AppColors.grey),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Song info
                        Text(
                          song.title,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          song.artist,
                          style: const TextStyle(
                              color: AppColors.grey, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        if (song.album != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            song.album!,
                            style: const TextStyle(
                                color: AppColors.grey, fontSize: 13),
                          ),
                        ],

                        const SizedBox(height: 40),

                        // Progress bar
                        StreamBuilder<PlaybackState>(
                          stream: provider.playbackStateStream,
                          builder: (context, snapshot) {
                            final state = snapshot.data;
                            return ProgressBar(
                              position: state?.position ?? Duration.zero,
                              duration: state?.duration ?? Duration.zero,
                              onSeek: (pos) => provider.seek(pos),
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        // Controls
                        PlayerControls(provider: provider),

                        const SizedBox(height: 24),

                        // Volume
                        Row(
                          children: [
                            const Icon(Icons.volume_down,
                                color: AppColors.grey),
                            Expanded(
                              child: SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 2,
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 5),
                                  activeTrackColor: AppColors.grey,
                                  inactiveTrackColor: Colors.grey[800],
                                  thumbColor: AppColors.white,
                                  overlayColor:
                                      Colors.white.withOpacity(0.1),
                                ),
                                child: Slider(
                                  value: 1.0,
                                  min: 0.0,
                                  max: 1.0,
                                  onChanged: (v) => provider.setVolume(v),
                                ),
                              ),
                            ),
                            const Icon(Icons.volume_up,
                                color: AppColors.grey),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down,
                color: AppColors.white, size: 32),
            onPressed: () => Navigator.pop(context),
          ),
          const Text('Đang phát',
              style: TextStyle(color: AppColors.white, fontSize: 16)),
          IconButton(
            icon:
                const Icon(Icons.more_vert, color: AppColors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}