import 'package:com_quranicayah/models/ayah.dart';
import 'package:com_quranicayah/theme/app_colors.dart';
import 'package:com_quranicayah/theme/app_theme.dart';
import 'package:com_quranicayah/widget/tappable_ayah.dart';
import 'package:flutter/material.dart';
import '../screens/ayah_screen.dart';
import '../widget/word_by_word_grid.dart';

class AyahWidget extends StatefulWidget {
  final AyahDetail ayah;
  final String font;
  final AppTheme theme;
  final Widget? widgetValue;

  const AyahWidget({
    super.key,
    required this.ayah,
    required this.font,
    required this.theme,
    this.widgetValue,
  });

  @override
  State<AyahWidget> createState() => _AyahWidgetState();
}

class _AyahWidgetState extends State<AyahWidget> {
  void onTapConfirmed() {
    print("object");
  }

  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    return Column(
      children: [
        HeaderSection(ayah: widget.ayah),
        if (widget.widgetValue != null) ...[
          widget.widgetValue!,
          const SizedBox(height: 10),
        ],

        TappableAyahWord(
          child: AyahSection(
            ayah: widget.ayah,
            font: widget.font,
            theme: widget.theme
          ),
        ),
        WordByWordScrollGrid(
          wordPairs: widget.ayah.wordsToLearn,
          font: widget.font,
          theme: theme,
        ),
        TafsirPreviewSection(detail: widget.ayah),
      ],
    );
  }
}

