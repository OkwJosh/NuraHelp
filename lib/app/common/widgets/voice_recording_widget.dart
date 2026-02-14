import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/services/audio_recorder_service.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';

class VoiceRecordingWidget extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSend;

  const VoiceRecordingWidget({
    super.key,
    required this.onCancel,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final audioService = Get.find<AudioRecorderService>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Cancel button
          IconButton(
            onPressed: onCancel,
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 28),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),

          const SizedBox(width: 16),

          // Recording animation
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Duration display
          Expanded(
            child: Obx(() {
              final duration = audioService.recordingDuration.value;
              return Text(
                audioService.formatDuration(duration),
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins-Medium',
                  color: Colors.black87,
                ),
              );
            }),
          ),

          const SizedBox(width: 12),

          // Waveform animation (simplified)
          Row(
            children: List.generate(5, (index) {
              return Obx(() {
                // Animate bars based on recording duration
                final duration = audioService.recordingDuration.value;
                final height = 8.0 + (duration % (index + 1)) * 2.0;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 3,
                  height: height.clamp(8.0, 24.0),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              });
            }),
          ),

          const SizedBox(width: 16),

          // Send button
          GestureDetector(
            onTap: onSend,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.secondaryColor,
                shape: BoxShape.circle,
              ),
              child: SvgIcon(AppIcons.send, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
