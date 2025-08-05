import 'package:com_quranicayah/models/ayah.dart';
import 'package:flutter/material.dart';
import '../screens/ayah_screen.dart';
import '../widget/word_by_word_grid.dart';

class AyahWidget extends StatelessWidget {
  final AyahDetail ayah;
  final String font;
  final Widget? widgetValue;
  const AyahWidget({super.key, required this.ayah, required this.font, this.widgetValue});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        HeaderSection(ayah: ayah),
        if (widgetValue != null)
            widgetValue!,
        AyahSection(ayah: ayah, font: font),
        WordByWordScrollGrid(
          wordPairs: ayah.wordsToLearn,
          font: font,
        ),
        TafsirPreviewSection(detail: ayah),
      ],
    );
  }
}
