import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../services/audio_player_service.dart';
import '../theme/app_colors.dart';

/// مشغل صوت مصغر للآيات القرآنية
class AudioPlayerWidget extends StatelessWidget {
  final int surahNumber;
  final int verseNumber;
  final bool isCompact;

  const AudioPlayerWidget({
    super.key,
    required this.surahNumber,
    required this.verseNumber,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final isPlaying = audioProvider.isPlayingVerse(surahNumber, verseNumber);

    if (!audioProvider.isInitialized) {
      return const SizedBox.shrink();
    }

    return isCompact
        ? _buildCompactPlayer(context, audioProvider, isPlaying)
        : _buildFullPlayer(context, audioProvider, isPlaying);
  }

  Widget _buildCompactPlayer(
    BuildContext context,
    AudioProvider audioProvider,
    bool isPlaying,
  ) {
    return IconButton(
      icon: Icon(
        isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
        size: 40,
      ),
      color: AppColors.brandPrimary,
      onPressed: () async {
        if (isPlaying) {
          await audioProvider.pause();
        } else {
          final success =
              await audioProvider.playVerse(surahNumber, verseNumber);
          if (!success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('حدث خطأ في تشغيل التلاوة'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      tooltip: isPlaying ? 'إيقاف' : 'تشغيل التلاوة',
    );
  }

  Widget _buildFullPlayer(
    BuildContext context,
    AudioProvider audioProvider,
    bool isPlaying,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.cardDark
            : AppColors.brandPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.brandPrimary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // معلومات القارئ
          Row(
            children: [
              Icon(
                Icons.record_voice_over,
                color: AppColors.brandPrimary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  audioProvider.currentReciter.displayName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () => _showReciterDialog(context, audioProvider),
                child: Text(
                  'تغيير',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.brandPrimary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // أزرار التحكم
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // زر التشغيل/الإيقاف الرئيسي
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.brandPrimary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brandPrimary.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () async {
                    if (isPlaying) {
                      await audioProvider.pause();
                    } else {
                      final success = await audioProvider.playVerse(
                        surahNumber,
                        verseNumber,
                      );
                      if (!success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('حدث خطأ في تشغيل التلاوة'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
              ),

              const SizedBox(width: 16),

              // زر الإيقاف
              IconButton(
                icon: const Icon(Icons.stop),
                color: isDark ? Colors.white70 : AppColors.textSecondary,
                onPressed: isPlaying
                    ? () async {
                        await audioProvider.stop();
                      }
                    : null,
              ),
            ],
          ),

          // شريط التقدم (إذا كان يتم التشغيل)
          if (isPlaying) ...[
            const SizedBox(height: 12),
            StreamBuilder<Duration>(
              stream: audioProvider.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration?>(
                  stream: audioProvider.durationStream,
                  builder: (context, durationSnapshot) {
                    final duration = durationSnapshot.data ?? Duration.zero;
                    return Column(
                      children: [
                        LinearProgressIndicator(
                          value: duration.inMilliseconds > 0
                              ? position.inMilliseconds /
                                  duration.inMilliseconds
                              : 0.0,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.brandPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? Colors.white70
                                    : AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              _formatDuration(duration),
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? Colors.white70
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  void _showReciterDialog(BuildContext context, AudioProvider audioProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر القارئ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Reciter.values.map((reciter) {
            final isSelected = audioProvider.currentReciter == reciter;
            return ListTile(
              leading: Icon(
                Icons.record_voice_over,
                color: isSelected ? AppColors.brandPrimary : Colors.grey,
              ),
              title: Text(
                reciter.displayName,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.brandPrimary : null,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check, color: AppColors.brandPrimary)
                  : null,
              onTap: () {
                audioProvider.setReciter(reciter);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
