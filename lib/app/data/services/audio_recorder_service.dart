import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioRecorderService extends GetxService {
  static AudioRecorderService get instance => Get.find();

  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();

  final RxBool isRecording = false.obs;
  final RxBool isPlaying = false.obs;
  final RxString recordingPath = ''.obs;
  final RxInt recordingDuration = 0.obs; // in seconds
  final RxDouble playbackPosition = 0.0.obs; // 0.0 to 1.0
  final RxInt playbackDuration = 0.obs; // Total duration in seconds

  Timer? _recordingTimer;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playerStateSubscription;

  // Map to track playback state for multiple audio files
  final RxMap<String, bool> playingAudios = <String, bool>{}.obs;
  final RxMap<String, double> audioPositions = <String, double>{}.obs;
  final RxMap<String, int> audioDurations = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializePlayer();
  }

  void _initializePlayer() {
    // Listen to player state changes
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((
      state,
    ) {
      if (state == PlayerState.completed) {
        isPlaying.value = false;
        playbackPosition.value = 0.0;
        // Update specific audio playing state
        _updatePlayingState(false);
      }
    });

    // Listen to position changes
    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      if (playbackDuration.value > 0) {
        playbackPosition.value =
            position.inMilliseconds / (playbackDuration.value * 1000);
      }
      // Update specific audio position (in milliseconds for smooth progress)
      _updateAudioPosition(position.inMilliseconds.toDouble());
    });

    // Listen to duration changes
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      playbackDuration.value = duration.inSeconds;
    });
  }

  void _updatePlayingState(bool playing) {
    final currentUrl = recordingPath.value;
    if (currentUrl.isNotEmpty) {
      playingAudios[currentUrl] = playing;
    }
  }

  void _updateAudioPosition(double position) {
    final currentUrl = recordingPath.value;
    if (currentUrl.isNotEmpty) {
      audioPositions[currentUrl] = position;
    }
  }

  /// Check and request microphone permission
  Future<bool> checkPermission() async {
    try {
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        debugPrint('❌ [AudioRecorder] Microphone permission denied');
        Get.snackbar(
          'Permission Required',
          'Please grant microphone permission to record voice notes',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return hasPermission;
    } catch (e) {
      debugPrint('❌ [AudioRecorder] Permission check error: $e');
      return false;
    }
  }

  /// Start recording audio
  Future<void> startRecording() async {
    try {
      // Check permission first
      if (!await checkPermission()) {
        return;
      }

      // Get temporary directory for the audio file
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '${directory.path}/voice_note_$timestamp.m4a';

      // Configure recording
      const config = RecordConfig(
        encoder:
            AudioEncoder.aacLc, // AAC format for good quality and compatibility
        bitRate: 128000,
        sampleRate: 44100,
      );

      // Start recording
      await _audioRecorder.start(config, path: path);

      isRecording.value = true;
      recordingPath.value = path;
      recordingDuration.value = 0;

      // Start timer to track recording duration
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        recordingDuration.value++;

        // Auto-stop after 5 minutes (300 seconds)
        if (recordingDuration.value >= 300) {
          stopRecording();
          Get.snackbar(
            'Recording Stopped',
            'Maximum recording duration reached (5 minutes)',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      });

      debugPrint('🎤 [AudioRecorder] Recording started: $path');
    } catch (e) {
      debugPrint('❌ [AudioRecorder] Start recording error: $e');
      Get.snackbar(
        'Recording Error',
        'Failed to start recording: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Stop recording audio
  Future<String?> stopRecording() async {
    try {
      if (!isRecording.value) return null;

      final path = await _audioRecorder.stop();
      _recordingTimer?.cancel();
      isRecording.value = false;

      if (path != null && path.isNotEmpty) {
        final file = File(path);
        if (await file.exists()) {
          debugPrint('✅ [AudioRecorder] Recording stopped: $path');
          debugPrint(
            '📊 [AudioRecorder] Duration: ${recordingDuration.value}s',
          );
          return path;
        }
      }

      debugPrint('⚠️ [AudioRecorder] Recording stopped but file not found');
      return null;
    } catch (e) {
      debugPrint('❌ [AudioRecorder] Stop recording error: $e');
      isRecording.value = false;
      _recordingTimer?.cancel();
      return null;
    }
  }

  /// Cancel recording (delete the file)
  Future<void> cancelRecording() async {
    try {
      final path = recordingPath.value;
      await _audioRecorder.stop();
      _recordingTimer?.cancel();
      isRecording.value = false;
      recordingDuration.value = 0;

      // Delete the recorded file
      if (path.isNotEmpty) {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
          debugPrint('🗑️ [AudioRecorder] Recording cancelled and deleted');
        }
      }

      recordingPath.value = '';
    } catch (e) {
      debugPrint('❌ [AudioRecorder] Cancel recording error: $e');
    }
  }

  /// Play audio from file path or URL
  Future<void> playAudio(String audioPath) async {
    try {
      // Stop any currently playing audio
      await stopAudio();

      recordingPath.value = audioPath;
      playingAudios[audioPath] = true;
      audioPositions[audioPath] = 0.0;

      final source = audioPath.startsWith('http')
          ? UrlSource(audioPath)
          : DeviceFileSource(audioPath);

      await _audioPlayer.play(source);
      isPlaying.value = true;

      debugPrint('▶️ [AudioRecorder] Playing audio: $audioPath');
    } catch (e) {
      debugPrint('❌ [AudioRecorder] Play audio error: $e');
      Get.snackbar(
        'Playback Error',
        'Failed to play audio: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Pause audio playback
  Future<void> pauseAudio() async {
    try {
      await _audioPlayer.pause();
      isPlaying.value = false;
      _updatePlayingState(false);
      debugPrint('⏸️ [AudioRecorder] Audio paused');
    } catch (e) {
      debugPrint('❌ [AudioRecorder] Pause audio error: $e');
    }
  }

  /// Resume audio playback
  Future<void> resumeAudio() async {
    try {
      await _audioPlayer.resume();
      isPlaying.value = true;
      _updatePlayingState(true);
      debugPrint('▶️ [AudioRecorder] Audio resumed');
    } catch (e) {
      debugPrint('❌ [AudioRecorder] Resume audio error: $e');
    }
  }

  /// Stop audio playback
  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
      isPlaying.value = false;
      playbackPosition.value = 0.0;
      _updatePlayingState(false);
      debugPrint('⏹️ [AudioRecorder] Audio stopped');
    } catch (e) {
      debugPrint('❌ [AudioRecorder] Stop audio error: $e');
    }
  }

  /// Seek to specific position (0.0 to 1.0)
  Future<void> seekTo(double position) async {
    try {
      if (playbackDuration.value > 0) {
        final seekPosition = (position * playbackDuration.value).round();
        await _audioPlayer.seek(Duration(seconds: seekPosition));
        playbackPosition.value = position;
        debugPrint('⏩ [AudioRecorder] Seeked to: ${seekPosition}s');
      }
    } catch (e) {
      debugPrint('❌ [AudioRecorder] Seek error: $e');
    }
  }

  /// Get file size
  Future<int> getAudioFileSize(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      debugPrint('❌ [AudioRecorder] Get file size error: $e');
      return 0;
    }
  }

  /// Format duration for display (mm:ss)
  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    _recordingTimer?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.onClose();
  }
}
