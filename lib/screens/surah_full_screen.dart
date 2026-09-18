import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../models/quran_detail.dart';
import '../providers/font_provider.dart';
import '../service/database_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widget/audio_button.dart';

class SurahFullScreen extends StatefulWidget {
  final SurahReference surahRef;

  const SurahFullScreen({
    super.key,
    required this.surahRef,
  });

  @override
  State<SurahFullScreen> createState() => _SurahFullScreenState();
}


class _SurahFullScreenState extends State<SurahFullScreen> {
  SurahDb? surah;
  QuranDetail? detail;
  bool isLoading = true;

  final ScrollController _scrollController = ScrollController();
  bool isAutoScrolling = false;
  double scrollSpeed = 30; // pixels per second

  @override
  void initState() {
    super.initState();
    fetchSurahById(widget.surahRef.number);
    loadQuranDetail();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> loadQuranDetail() async {
    final jsonString = await rootBundle.loadString('assets/quran.json');
    final jsonMap = jsonDecode(jsonString);
    setState(() {
      detail = QuranDetail.fromJson(jsonMap);
    });
  }

  void fetchSurahById(int id) async {
    final result = await DatabaseHelper.getSurahById(id);
    if (result != null) {
      setState(() {
        surah = result;
        print(surah?.content);
        isLoading = false;
      });
    } else {
      print("Surah not found for ID: $id");
      setState(() {
        isLoading = false;
      });
    }
  }

  void startAutoScroll() {
    isAutoScrolling = true;
    _autoScroll();
  }

  void stopAutoScroll() {
    isAutoScrolling = false;
  }

  Future<void> _autoScroll() async {
    while (isAutoScrolling && _scrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 100));

      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;

      // If we've reached (or almost reached) the bottom, stop auto-scrolling
      if (currentScroll >= maxScroll - 10) {
        setState(() {
          isAutoScrolling = false;
        });
        break;
      }

      // Otherwise, scroll by a small increment
      _scrollController.animateTo(
        currentScroll + scrollSpeed * 0.1,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    final font = Provider.of<FontProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primary,
        iconTheme: IconThemeData(color: theme.textWhite),
        title: Text("Surah", style: TextStyle(color: theme.textWhite)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: isLoading || detail == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Control Section
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: theme.cardBorder ?? Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Font size control
                Row(
                  children: [
                    Icon(Icons.text_fields, color: theme.primary),
                    const SizedBox(width: 10),
                    const Text("Font Size"),
                    Expanded(
                      child: Slider(
                        activeColor: theme.primary,
                        value: font.fontSize,
                        min: 20,
                        max: 40,
                        divisions: 8,
                        label: font.fontSize.round().toString(),
                        onChanged: (value) => font.setFontSize(value),
                      ),
                    ),
                    Text(font.fontSize.toInt().toString()),
                  ],
                ),
                const Divider(height: 16),
                // Auto scroll + speed controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.swap_vert, color: theme.primary),
                        const SizedBox(width: 8),
                        const Text("Auto Scroll"),
                        Switch(
                          activeColor: theme.primary,
                          value: isAutoScrolling,
                          onChanged: (value) {
                            setState(() => isAutoScrolling = value);
                            if (value) {
                              startAutoScroll();
                            } else {
                              stopAutoScroll();
                            }
                          },
                        ),
                      ],
                    ),
                    // Speed control
                    Expanded(
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Icon(Icons.speed, color: theme.primary),
                          Expanded(
                            child: Slider(
                              value: scrollSpeed,
                              activeColor: theme.primary,
                              min: 10,
                              max: 100,
                              divisions: 9,
                              label: scrollSpeed.toStringAsFixed(0),
                              onChanged: (value) {
                                setState(() => scrollSpeed = value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider between controls and content
          const Divider(height: 1),
          // Surah Text Section
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.surahRef.number != 9)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        '﷽',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: font.fontFamily,
                          fontSize: font.fontSize + 4,
                          color: theme.primary,
                        ),
                      ),
                    ),
                  ..._buildVerses(surah!.content, font, theme),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }
  List<Widget> _buildVerses(String content, FontProvider font, AppTheme theme) {
    final RegExp versePattern = RegExp(r'(.*?)\s*\[(\d+)\]');
    final matches = versePattern.allMatches(content);
    final sajdas = detail!.data.sajdas.references;
    return matches.map((match) {
      final verseText = match.group(1)?.trim() ?? '';
      final verseNumber = match.group(2) ?? '';
      final surahNumber = widget.surahRef.number;

      final isSajdah = sajdas.any((sajda) =>
      sajda.surah == surahNumber &&
          sajda.ayah.toString() == verseNumber);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              verseText,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: font.fontFamily,
                fontSize: font.fontSize,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isSajdah)
                  Text(
                    'سجدة',
                    style: TextStyle(
                      color: theme.primary,
                      fontFamily: font.fontFamily,
                      fontSize: font.fontSize - 5,
                    ),
                  ),
                const SizedBox(width: 10),

                Row(children: [
                  FutureBuilder<String>(
                    future: audioRecite('$surahNumber', verseNumber),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // or a placeholder widget
                      } else if (snapshot.hasError) {
                        return Text('Error loading audio');
                      } else {
                        return AudioPlayButton(audioUrl: snapshot.data!);
                      }
                    },
                  ),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.primary,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      verseNumber,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.textWhite,
                      ),
                    ),
                  ),
                ],),
              ],
            ),

            Divider(color: theme.primary.withOpacity(0.2)),

          ],
        ),
      );
    }).toList();
  }
  Future<String> audioRecite(String surahNumber, String ayahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('selected_reciter') ?? '1';
    if (['1', '2', '3', '4', '5'].contains(id)) {
      return 'https://the-quran-project.github.io/Quran-Audio/Data/$id/${surahNumber}_$ayahNumber.mp3';
    }
    if (id == '6') {
      String paddedSurah = surahNumber.padLeft(3, '0');
      String paddedAyah = ayahNumber.padLeft(3, '0');
      String url = "https://everyayah.com/data/Saood_ash-Shuraym_128kbps/$paddedSurah$paddedAyah.mp3";
      return url;
    }
    return 'https://the-quran-project.github.io/Quran-Audio/Data/1/${surahNumber}_$ayahNumber.mp3';
  }
}
