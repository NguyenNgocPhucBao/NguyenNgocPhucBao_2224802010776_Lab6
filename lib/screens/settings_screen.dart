import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Cài đặt',
            style: TextStyle(color: AppColors.white)),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Consumer<AudioProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              _buildSection('Phát nhạc'),
              SwitchListTile(
                title: const Text('Shuffle',
                    style: TextStyle(color: AppColors.white)),
                subtitle: const Text('Phát ngẫu nhiên',
                    style: TextStyle(color: AppColors.grey)),
                value: provider.isShuffleEnabled,
                activeColor: AppColors.primary,
                onChanged: (_) => provider.toggleShuffle(),
              ),
              ListTile(
                title: const Text('Chế độ lặp',
                    style: TextStyle(color: AppColors.white)),
                subtitle: Text(
                  _repeatLabel(provider),
                  style: const TextStyle(color: AppColors.grey),
                ),
                trailing: const Icon(Icons.chevron_right,
                    color: AppColors.grey),
                onTap: () => provider.toggleRepeat(),
              ),
              const Divider(color: AppColors.cardBackground),
              _buildSection('Âm lượng'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.volume_down, color: AppColors.grey),
                    Expanded(
                      child: Slider(
                        value: 1.0,
                        min: 0.0,
                        max: 1.0,
                        activeColor: AppColors.primary,
                        inactiveColor: AppColors.cardBackground,
                        onChanged: (v) => provider.setVolume(v),
                      ),
                    ),
                    const Icon(Icons.volume_up, color: AppColors.grey),
                  ],
                ),
              ),
              const Divider(color: AppColors.cardBackground),
              _buildSection('Thông tin'),
              const ListTile(
                title: Text('Phiên bản',
                    style: TextStyle(color: AppColors.white)),
                trailing: Text('1.0.0',
                    style: TextStyle(color: AppColors.grey)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title,
          style: const TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.bold)),
    );
  }

  String _repeatLabel(AudioProvider provider) {
    switch (provider.loopMode.index) {
      case 0: return 'Tắt';
      case 1: return 'Lặp tất cả';
      case 2: return 'Lặp một bài';
      default: return 'Tắt';
    }
  }
}