import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/quran_detail.dart';
import '../providers/font_provider.dart';
import '../service/database_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';


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
  SurahDb? surah; // Make it nullable
  QuranDetail? detail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSurahById(widget.surahRef.number);
    loadQuranDetail();

  }
  loadQuranDetail() async {
    final jsonString = await rootBundle.loadString('assets/quran.json');
    final jsonMap = jsonDecode(jsonString);
    detail = QuranDetail.fromJson(jsonMap);
  }

  void fetchSurahById(int id) async {
    final result = await DatabaseHelper.getSurahById(id);
    if (result != null) {
      setState(() {
        surah = result;
        isLoading = false;
      });
    } else {
      print("Surah not found for ID: $id");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    final font = Provider.of<FontProvider>(context);
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
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : surah == null
            ? Center(child: Text("Surah not found"))
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Optional Bismillah Header (skip for Surah Tawbah)
              if (widget.surahRef.number != 9)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    '﷽',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: font.fontFamily,
                      fontSize: 36,
                      color: theme.primary,
                    ),
                  ),
                ),

              // Verse-by-verse view
              ..._buildVerses(surah!.content, font, theme),
            ],
          ),
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

      // Check if current verse is a sajdah
      final isSajdah = sajdas.any((sajda) =>
      sajda.surah == surahNumber && sajda.ayah.toString() == verseNumber);

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
                fontSize: 30,
                height: 1.4,
              ),
            ),
            const SizedBox(width: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isSajdah)
                  Text(
                    'سجدة',
                    style: TextStyle(
                      color: theme.primary,
                      fontFamily: font.fontFamily,
                      fontSize: 25,
                    ),
                  ),
                SizedBox(width: 10,),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primary.withOpacity(0.9),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    verseNumber,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.textWhite,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }


}
