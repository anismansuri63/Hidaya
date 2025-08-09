import 'package:com_quranicayah/models/ayah.dart';
import 'package:com_quranicayah/providers/font_provider.dart';
import 'package:com_quranicayah/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widget/ayah_widget.dart';

import '../theme/app_colors.dart';

class AyahDetailView extends StatefulWidget {
  final AyahDetail ayah;
  final AppTheme theme;
  const AyahDetailView({super.key, required this.ayah,  required this.theme});

  @override
  State<AyahDetailView> createState() => _AyahDetailViewState();
}

class _AyahDetailViewState extends State<AyahDetailView> {
  @override
  Widget build(BuildContext context) {
    final font = Provider.of<FontProvider>(context);
    var theme = widget.theme;
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
          child: AyahWidget(
            ayah: widget.ayah,
            font: font.fontFamily,
            theme: theme,
          ),
        ),
      ),
    );
  }
}
