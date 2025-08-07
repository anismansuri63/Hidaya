import 'package:com_quranicayah/theme/app_colors.dart';
import 'package:com_quranicayah/widget/tappable_ayah.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';


class WordByWordScrollGrid extends StatefulWidget {
  final Map<String, String> wordPairs;
  final String font;


  const WordByWordScrollGrid({
    super.key,
    required this.wordPairs,
    required this.font,
  });

  @override
  State<WordByWordScrollGrid> createState() => _WordByWordScrollGridState();
}

class _WordByWordScrollGridState extends State<WordByWordScrollGrid> {
  final FlutterTts flutterTts = FlutterTts();
  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Directionality(
      textDirection: TextDirection.rtl, // RTL for Arabic + scroll
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: widget.wordPairs.entries.map((entry) {
            final arabic = entry.key;
            final translation = entry.value;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TappableAyahWord(
                    onTapConfirmed: null,
                    child: Text(
                      arabic,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: widget.font,
                        color: theme.textBlack
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    translation,
                    style: TextStyle(fontSize: 14,
                        color: theme.textBlack),
                    textAlign: TextAlign.center,

                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
  Future<void> speakArabic(String word) async {
    final FlutterTts flutterTts = FlutterTts();

    await flutterTts.setLanguage("ar"); // Arabic language
       // optional
    await flutterTts.speak(word);
  }

}
