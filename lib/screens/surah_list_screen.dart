import 'dart:convert';

import 'package:com_quranicayah/screens/surah_full_screen.dart';
import 'package:com_quranicayah/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../core/app_imports.dart';
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
  List<SurahReference> recentSurahs = [];
  bool isSearching = false;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.addListener(_onSearchChanged);
    _init();
  }

  Future<void> _init() async {
    await surahReference();
    await _loadRecentSurahs(); // Load recent after surahs are loaded
  }

// Updated _loadRecentSurahs to handle async properly
  Future<void> _loadRecentSurahs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? savedSurahNumbers = prefs.getStringList('recent_surahs');

      if (savedSurahNumbers != null && savedSurahNumbers.isNotEmpty && all.isNotEmpty) {
        final List<SurahReference> loadedSurahs = [];

        for (String numberStr in savedSurahNumbers) {
          final int number = int.tryParse(numberStr) ?? 0;
          try {
            final surah = all.firstWhere((s) => s.number == number);
            loadedSurahs.add(surah);
          } catch (e) {
            // Surah not found, skip it
            continue;
          }
        }

        if (mounted) {
          setState(() {
            recentSurahs = loadedSurahs;
          });
        }
      }
    } catch (e) {
      print('Error loading recent surahs: $e');
      if (mounted) {
        setState(() {
          recentSurahs = [];
        });
      }
    }
  }

// Updated _addToRecent with proper async handling
  void _addToRecent(SurahReference surah) {
    setState(() {
      recentSurahs.removeWhere((s) => s.number == surah.number);
      recentSurahs.insert(0, surah);
      if (recentSurahs.length > 10) {
        recentSurahs = recentSurahs.sublist(0, 10);
      }
    });
    _saveRecentSurahs();
  }

// Updated _saveRecentSurahs with error handling
  Future<void> _saveRecentSurahs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> surahNumbers = recentSurahs.map((s) => s.number.toString()).toList();
      await prefs.setStringList('recent_surahs', surahNumbers);
    } catch (e) {
      print('Error saving recent surahs: $e');
    }
  }

  void _onSearchChanged() {
    setState(() {
      isSearching = controller.text.isNotEmpty;
      String search = controller.text.trim().toLowerCase();
      if (search.isEmpty) {
        filteredSurahs = List.from(all);
      } else {
        filteredSurahs = all.where((s) =>
        s.englishName.toLowerCase().contains(search) ||
            s.name.contains(search) ||
            s.revelationType.toLowerCase().contains(search)).toList();
      }
    });
  }

  Future surahReference() async {
    QuranDetail detail = await loadQuranDetail();
    all = detail.data.surahs.references;
    filteredSurahs = detail.data.surahs.references;
    setState(() {});
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
          color: theme.textWhite,
        ),
        title: Text("Surahs",
          style: TextStyle(color: theme.textWhite),),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
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
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear, color: theme.grey),
                    onPressed: () {
                      controller.clear();
                    },
                  )
                      : null,
                ),
              ),
            ),

            // Only show recent section if there are recent surahs and not searching
            if (recentSurahs.isNotEmpty && !isSearching)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 18,
                          color: theme.primary,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Recently Read',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.textBlack,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              recentSurahs.clear();
                            });
                            _saveRecentSurahs();
                          },
                          child: Text(
                            'Clear All',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 100,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recentSurahs.length,
                      itemBuilder: (context, index) {
                        final surah = recentSurahs[index];
                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _addToRecent(surah);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SurahFullScreen(surahRef: surah),
                                  ),
                                ).then((_) {
                                  _loadRecentSurahs();
                                });
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                margin: EdgeInsets.symmetric(horizontal: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: theme.grey.withOpacity(0.2),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Surah number with star background
                                    Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            theme.primary,
                                            theme.primary.withOpacity(0.7),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: theme.primary.withOpacity(0.3),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${surah.number}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    // Surah name
                                    Text(
                                      surah.englishName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: theme.textBlack,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          recentSurahs.removeAt(index);
                                        });
                                        _saveRecentSurahs();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          size: 14,
                                          color: theme.grey,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // Remove button positioned at top-right
                        ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),

            // Surah List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: filteredSurahs.length,
                itemBuilder: (context, index) {
                  final surah = filteredSurahs[index];
                  return GestureDetector(
                    onTap: () {
                      // Add to recent before navigating
                      _addToRecent(surah);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SurahFullScreen(surahRef: surah),
                        ),
                      ).then((_) {
                        // Refresh recent list when coming back
                        _loadRecentSurahs();
                      });
                    },
                    child: SurahTile(
                      surah: surah,
                      theme: theme,
                      font: font.fontFamily,
                    ),
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
          leading: StarNumberWidget(
            number: surah.number,
            borderColor: theme.primary,
          ),
          title: Text(
              surah.englishName,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textBlack
              )
          ),
          subtitle: Text(
              '${surah.revelationType} - ${surah.numberOfAyahs} Verses',
              style: TextStyle(color: theme.grey)
          ),
          trailing: Text(
              surah.name,
              style: TextStyle(
                  fontSize: 22,
                  fontFamily: font,
                  fontWeight: FontWeight.w600,
                  color: theme.secondary
              )
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: theme.grey.withOpacity(0.5))
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
