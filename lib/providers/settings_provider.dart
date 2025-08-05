import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsProvider1 with ChangeNotifier {
  String _selectedFont = 'AlQuranIndoPak';
  double _playbackSpeed = 1.0;

  String get selectedFont => _selectedFont;
  double get playbackSpeed => _playbackSpeed;

  SettingsProvider1() {
    _loadSettings();
  }
  /// Used in DropdownButton
  List<String>  fontOptions() {
    return ['AlQuranIndoPak - يَسْمَعُونَ', 'AlMajeedQuran - يَسْمَعُونَ', 'PDMS_Saleem - يَسْمَعُونَ'];
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFont = prefs.getString('selectedFont') ?? fontOptions().first;
    _playbackSpeed = prefs.getDouble('playbackSpeed') ?? 1.0;
    notifyListeners();
  }

  Future<void> setSelectedFont(String font) async {
    _selectedFont = font.split(' - ').first;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedFont', font);
    notifyListeners();
  }

  Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed = speed;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('playbackSpeed', speed);
    notifyListeners();
  }
}

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
