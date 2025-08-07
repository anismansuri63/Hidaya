import 'package:com_quranicayah/models/ayah.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
class FullTafsirView extends StatefulWidget {
  final AyahDetail detail;
  const FullTafsirView({
    super.key,
    required this.detail,
  });

  @override
  State<FullTafsirView> createState() => _FullTafsirViewState();
}

class _FullTafsirViewState extends State<FullTafsirView> {
  String _selectedFont = 'AlQuranIndoPak';
  double _baseFontSize = 16;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedFont = prefs.getString('selectedFont') ?? 'AlQuranIndoPak';
      _baseFontSize = prefs.getDouble('tafsirFontSize') ?? 16.0;
    });
  }

  Future<void> _updateFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('tafsirFontSize', size);
    setState(() => _baseFontSize = size);
  }

  bool _containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: theme.textWhite),
        title: Text(widget.detail.surahNameArabic, style: TextStyle(color: theme.textWhite),),
        backgroundColor: theme.primary,
      ),
      body: Column(
        children: [
          // Slider to adjust font size
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text("Font Size: "),
                Expanded(
                  child: Slider(
                    activeColor: theme.primary,
                    value: _baseFontSize,
                    min: 14,
                    max: 22,
                    divisions: 8,
                    label: _baseFontSize.toInt().toString(),
                    onChanged: (value) => _updateFontSize(value),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Row(
            children: [
              Icon(Icons.book, color: theme.primary, size: 32),
              const SizedBox(width: 10),
              Text(
                'Tafsir of Ayah ${widget.detail.numberDetail()}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:  theme.primary,
                ),
              ),
            ],
          ),

          // HTML content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Html(
                data: widget.detail.tafsir,
                extensions: [
                  TagExtension(
                    tagsToExtend: {"p", "P"},
                    builder: (context) {
                      final text = context.innerHtml.trim();
                      final isArabic = _containsArabic(text);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          text,
                          textAlign: isArabic ? TextAlign.right : TextAlign.left,
                          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                          style: TextStyle(
                            fontSize: isArabic ? _baseFontSize + 8 : _baseFontSize,
                            fontFamily: _selectedFont,
                            height: 1.6,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}