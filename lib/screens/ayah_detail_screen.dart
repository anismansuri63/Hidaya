import 'package:com_quranicayah/models/ayah.dart';
import 'package:com_quranicayah/providers/font_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/ayah_widget.dart';
import '../widget/word_by_word_grid.dart';
import 'ayah_screen.dart';

class AyahDetailView extends StatelessWidget {
  final AyahDetail ayah;

  const AyahDetailView({super.key, required this.ayah});

  @override
  Widget build(BuildContext context) {
    final font = Provider.of<FontProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Ayah Detail")),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A5E2A), Color(0xFF1B7942)],
            ),
          ),
          child: AyahWidget(ayah: ayah, font: font.fontFamily),
        ),
      ),
    );
  }
}
