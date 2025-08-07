import 'dart:convert';

import 'package:com_quranicayah/screens/surah_full_screen.dart';
import 'package:com_quranicayah/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../models/quran_detail.dart';
import '../providers/font_provider.dart';
import '../theme/app_colors.dart';



class SurahListScreen extends StatefulWidget {
  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  late TextEditingController controller;
  List<SurahReference> all = [];
  List<SurahReference> filteredSurahs = [];

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.addListener(_onSearchChanged);
    _init();
  }
  Future<void> _init() async {
    await surahReference();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }
  void _onSearchChanged() {
    // setState(() {
    //   String search = controller.text.trim().toLowerCase();
    //   if (search.isEmpty) {
    //     filteredSurahs = List.from(surahs);
    //   } else {
    //     filteredSurahs = surahs.where((s) =>
    //     s.englishName.toLowerCase().contains(search) ||
    //         s.name.contains(search) ||
    //         s.type.toLowerCase().contains(search)).toList();
    //   }
    // });
  }
  Future surahReference() async {
    QuranDetail detail = await loadQuranDetail();
    all = detail.data.surahs.references;
    filteredSurahs = detail.data.surahs.references;
    setState(() {

    });
  }
  Future<QuranDetail> loadQuranDetail() async {
    final jsonString = await rootBundle.loadString('assets/quran.json');
    final jsonMap = jsonDecode(jsonString);
    return QuranDetail.fromJson(jsonMap);
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    final font = Provider.of<FontProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primary,
        iconTheme: IconThemeData(
          color: theme.textWhite, // ← Set your desired color here
        ),
        title: Text("Surahs",
          style: TextStyle(color: theme.textWhite),),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: theme.grey),
                  hintText: 'Search',
                  filled: true,
                  fillColor: theme.textWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.cardBorder),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: filteredSurahs.length,
                itemBuilder: (context, index) {
                  final surah = filteredSurahs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SurahFullScreen(surahRef: surah),
                        ),
                      );
                    },
                    child: SurahTile(surah: surah, theme: theme, font: font.fontFamily,),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurahTile extends StatelessWidget {
  final SurahReference surah;
  final AppTheme theme;
  final String font;
  SurahTile({required this.surah, required this.theme, required this.font});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: StarNumberWidget(number: surah.number, borderColor: theme.primary,),
          title: Text(surah.englishName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textBlack)),
          subtitle: Text('${surah.revelationType} - ${surah.numberOfAyahs} Verses', style: TextStyle(color: theme.grey)),
          trailing: Text(surah.name, style: TextStyle(fontSize: 22, fontFamily: font,fontWeight: FontWeight.w600 ,color: theme.secondary)),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(color: theme.grey.withOpacity(0.5),)
        )
      ],
    );
  }
}



class StarNumberWidget extends StatelessWidget {
  final int number;
  final double size;
  final Color borderColor;
  final Color fillColor;
  final TextStyle? textStyle;

  const StarNumberWidget({
    super.key,
    required this.number,
    this.size = 40.0,
    this.borderColor = Colors.teal,
    this.fillColor = Colors.white,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StarPainter(borderColor, fillColor),
      child: SizedBox(
        height: size,
        width: size,
        child: Center(
          child: Text(
            number.toString(),
            style: textStyle ??
                TextStyle(
                  color: borderColor,
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  final Color borderColor;
  final Color fillColor;

  _StarPainter(this.borderColor, this.fillColor);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    final int points = 8; // 8-pointed star
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);

    for (int i = 0; i < points * 2; i++) {
      final double angle = pi / points * i;
      final double r = i.isEven ? radius : radius * 0.6;
      final Offset point = Offset(
        center.dx + r * cos(angle),
        center.dy + r * sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
