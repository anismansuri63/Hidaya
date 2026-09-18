import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audio_session/audio_session.dart';

import '../theme/app_colors.dart';

class AudioPlayButton extends StatefulWidget {
  final String audioUrl;
  const AudioPlayButton({super.key, required this.audioUrl});

  @override
  State<AudioPlayButton> createState() => _AudioPlayButtonState();
}

class _AudioPlayButtonState extends State<AudioPlayButton> {
  static final AudioPlayer _player = AudioPlayer(); // ✅ shared

  static String? currentUrl; // track currently playing

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    _player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = currentUrl == widget.audioUrl &&
              state.playing &&
              state.processingState != ProcessingState.completed;
        });
      }
    });
  }

  void _togglePlayback() async {
    if (currentUrl == widget.audioUrl && _player.playing) {
      await _player.stop();
      currentUrl = null;
    } else {
      currentUrl = widget.audioUrl;

      await _player.stop(); // ✅ stop previous audio
      await _player.setUrl(widget.audioUrl);

      final prefs = await SharedPreferences.getInstance();
      var speed = prefs.getDouble('playbackSpeed') ?? 1.0;

      await _player.setSpeed(speed);
      await _player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);

    return IconButton(
      icon: Icon(
        isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
        size: 30,
      ),
      onPressed: _togglePlayback,
      color: theme.primary,
    );
  }
}
