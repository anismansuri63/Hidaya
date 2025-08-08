import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsProvider with ChangeNotifier {
  double _playbackSpeed = 1.0;

  double get playbackSpeed => _playbackSpeed;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _playbackSpeed = prefs.getDouble('playbackSpeed') ?? 1.0;
    notifyListeners();
  }

  Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed = speed;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('playbackSpeed', speed);
    notifyListeners();
  }
}
