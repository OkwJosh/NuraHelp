import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/services/audio_recorder_service.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';

class VoiceNotePlayer extends StatefulWidget {
  final String audioUrl;
  final String messageId;
  final bool isMe;
  final String? duration; // Optional duration from message
  final bool isUploading;

  const VoiceNotePlayer({
    super.key,
    required this.audioUrl,
    required this.messageId,
    required this.isMe,
    this.duration,
    this.isUploading = false,
  });

  @override
  State<VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<VoiceNotePlayer>
    with SingleTickerProviderStateMixin {
  final audioService = Get.find<AudioRecorderService>();
  final RxBool isPlaying = false.obs;
  final RxDouble playProgress = 0.0.obs;
  final RxInt currentDurationMs = 0.obs; // milliseconds
  final RxInt totalDurationMs = 0.obs; // milliseconds

  late AnimationController _animController;
  double _animFrom = 0.0;
  double _animTo = 0.0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), // smooth interpolation
    );
    _initializeDuration();
    // Listen to playback state for this specific audio
    ever(audioService.playingAudios, (_) {
      if (mounted) {
        isPlaying.value = audioService.playingAudios[widget.audioUrl] ?? false;
        if (!isPlaying.value) {
          _animController.stop();
        }
      }
    });

    // Listen to position changes (now in milliseconds)
    ever(audioService.audioPositions, (_) {
      if (mounted && isPlaying.value) {
        final positionMs = audioService.audioPositions[widget.audioUrl] ?? 0.0;
        currentDurationMs.value = positionMs.toInt();
        if (totalDurationMs.value > 0) {
          final newProgress = (positionMs / totalDurationMs.value).clamp(
            0.0,
            1.0,
          );
          // Animate smoothly from current value to new value
          _animFrom = playProgress.value;
          _animTo = newProgress;
          _animController.forward(from: 0.0);
          playProgress.value = newProgress;
        }
      }
    });
  }

  void _initializeDuration() {
    // Parse duration from message if available (format: "mm:ss|size")
    if (widget.duration != null && widget.duration!.contains('|')) {
      final parts = widget.duration!.split('|');
      if (parts.isNotEmpty) {
        final timeParts = parts[0].split(':');
        if (timeParts.length == 2) {
          final minutes = int.tryParse(timeParts[0]) ?? 0;
          final seconds = int.tryParse(timeParts[1]) ?? 0;
          totalDurationMs.value = (minutes * 60 + seconds) * 1000;
        }
      }
    }
  }

  Future<void> _togglePlayPause() async {
    if (widget.isUploading) return;

    if (isPlaying.value) {
      await audioService.pauseAudio();
    } else {
      // Stop any other playing audio and play this one
      await audioService.playAudio(widget.audioUrl);
      // Update total duration after starting playback
      if (totalDurationMs.value == 0) {
        await Future.delayed(const Duration(milliseconds: 100));
        totalDurationMs.value = audioService.playbackDuration.value * 1000;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isMe
            ? Colors.white.withOpacity(0.2)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Play/Pause button
          if (widget.isUploading)
            SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.isMe ? Colors.white : AppColors.secondaryColor,
                ),
              ),
            )
          else
            Obx(() {
              final playing = isPlaying.value;
              return GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: widget.isMe
                        ? Colors.white.withOpacity(0.3)
                        : AppColors.secondaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    playing ? Icons.pause : Icons.play_arrow,
                    color: widget.isMe
                        ? Colors.white
                        : AppColors.secondaryColor,
                    size: 24,
                  ),
                ),
              );
            }),

          const SizedBox(width: 12),

          // Waveform visualization and duration
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Smoothly animated linear progress bar
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    final smoothProgress =
                        _animFrom +
                        (_animTo - _animFrom) * _animController.value;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: smoothProgress.clamp(0.0, 1.0),
                        minHeight: 4,
                        backgroundColor: widget.isMe
                            ? Colors.white.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.isMe ? Colors.white : AppColors.secondaryColor,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 4),

                // Duration display
                Obx(() {
                  final playing = isPlaying.value;
                  final currentMs = currentDurationMs.value;
                  final totalMs = totalDurationMs.value;
                  final currentSec = (currentMs / 1000).round();
                  final totalSec = (totalMs / 1000).round();

                  final displayDuration = playing && currentSec > 0
                      ? audioService.formatDuration(currentSec)
                      : (totalSec > 0
                            ? audioService.formatDuration(totalSec)
                            : widget.duration?.split('|').first ?? '0:00');

                  return Text(
                    displayDuration,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Poppins-Regular',
                      color: widget.isMe
                          ? Colors.white.withOpacity(0.8)
                          : Colors.grey[600],
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Voice icon
          Icon(
            Icons.mic,
            size: 18,
            color: widget.isMe ? Colors.white.withOpacity(0.7) : Colors.grey,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    // Stop playback if this widget is disposed while playing
    if (isPlaying.value) {
      audioService.stopAudio();
    }
    super.dispose();
  }
}
