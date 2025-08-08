import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class ThemeProvider with ChangeNotifier {
  static const _themeKey = 'selectedThemeIndex';

  AppTheme _currentTheme = appThemes[0]; // Temporary default

  AppTheme get theme => _currentTheme;

  ThemeProvider() {
    _loadSavedTheme(); // Load on initialization
  }

  void setTheme(AppTheme theme) async {
    _currentTheme = theme;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final index = appThemes.indexOf(theme);
    await prefs.setInt(_themeKey, index); // Save theme index
  }

  void _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt(_themeKey);

    if (savedIndex != null && savedIndex >= 0 && savedIndex < appThemes.length) {
      _currentTheme = appThemes[savedIndex];
      notifyListeners(); // Notify after loading saved theme
    }
  }
}
