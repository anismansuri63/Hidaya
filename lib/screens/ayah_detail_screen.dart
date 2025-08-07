import 'package:com_quranicayah/models/ayah.dart';
import 'package:com_quranicayah/providers/font_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/ayah_widget.dart';

import '../theme/app_colors.dart';

class AyahDetailView extends StatelessWidget {
  final AyahDetail ayah;

  const AyahDetailView({super.key, required this.ayah});

  @override
  Widget build(BuildContext context) {
    final font = Provider.of<FontProvider>(context);
    final theme = AppColors.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Ayah Detail")),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [theme.primary, theme.primary2],
            ),
          ),
          child: AyahWidget(ayah: ayah, font: font.fontFamily),
        ),
      ),
    );
  }
}
