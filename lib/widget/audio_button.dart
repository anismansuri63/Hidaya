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
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;
  late Stream<PlayerState> _playerStateStream;

  @override
  void initState() {
    super.initState();
    _initAudioSession();
    _playerStateStream = _player.playerStateStream;
    _playerStateStream.listen((playerState) {
      if (mounted) {
        if (playerState.processingState == ProcessingState.completed) {
          setState(() {
            isPlaying = false;
          });
        }
      }
    });
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlayback() async {
    if (isPlaying) {
      setState(() => isPlaying = false);
      await _player.stop();

    } else {
      setState(() => isPlaying = true);
      try {
        await _player.setUrl(widget.audioUrl);
        final prefs = await SharedPreferences.getInstance();
        var speed = prefs.getDouble('playbackSpeed') ?? 1.0;
        await _player.setSpeed(speed);
        await _player.play();
      } catch (e) {
        debugPrint('Audio error: $e');
      }
    }


  }

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return IconButton(
      icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, size: 30),
      onPressed: _togglePlayback,
      color: theme.primary,
    );
  }
}
