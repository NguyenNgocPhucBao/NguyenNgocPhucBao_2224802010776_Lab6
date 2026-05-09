import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final Function(Duration) onSeek;

  const ProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    final double maxVal =
        duration.inMilliseconds > 0 ? duration.inMilliseconds.toDouble() : 1.0;
    final double curVal =
        position.inMilliseconds.clamp(0, maxVal.toInt()).toDouble();

    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 3,
            thumbShape:
                const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape:
                const RoundSliderOverlayShape(overlayRadius: 16),
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: Colors.grey[800],
            thumbColor: AppColors.white,
            overlayColor: AppColors.primary.withOpacity(0.3),
          ),
          child: Slider(
            value: curVal,
            min: 0.0,
            max: maxVal,
            onChanged: (value) {
              onSeek(Duration(milliseconds: value.toInt()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(position),
                  style: const TextStyle(
                      color: AppColors.grey, fontSize: 12)),
              Text(_formatDuration(duration),
                  style: const TextStyle(
                      color: AppColors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}