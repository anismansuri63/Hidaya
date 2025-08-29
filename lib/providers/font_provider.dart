import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontProvider with ChangeNotifier {
  final List<String> _fontOptions = [
    'AlQuranIndoPak',
    'AlMajeedQuran',
    'Kitab',
    'MesQuran',
    'PDMS_Saleem',
  ];

  String _fontFamily = 'AlQuranIndoPak';

  String get fontFamily => _fontFamily;

  List<String> get fontOptions => _fontOptions;

  FontProvider() {
    loadFont();
  }
  double _fontSize = 30;

  double get fontSize => _fontSize;

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  void setFontFamily(String family) {
    _fontFamily = family;
    notifyListeners();
  }

  Future<void> loadFont() async {
    final prefs = await SharedPreferences.getInstance();
    _fontFamily = prefs.getString('selectedFont') ?? _fontOptions.first;
    notifyListeners();
  }

  Future<void> setFont(String font) async {
    String finalFont = font.split(' - ').first;
    _fontFamily = finalFont;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedFont', finalFont);
    notifyListeners();
  }
}
