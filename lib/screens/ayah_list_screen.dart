import 'dart:convert';
import 'package:com_quranicayah/providers/font_provider.dart';
import 'package:com_quranicayah/providers/settings_provider.dart';
import 'package:com_quranicayah/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ayah.dart';
import '../theme/app_colors.dart';
import '../widget/tappable_ayah.dart';
import 'ayah_detail_screen.dart';

class AyahListScreen extends StatefulWidget {
  final String title;
  final String sharedPrefKey;
  final bool allowDelete;
  final bool allowClearAll;

  const AyahListScreen({
    super.key,
    required this.title,
    required this.sharedPrefKey,
    this.allowDelete = true,
    this.allowClearAll = true,
  });

  @override
  State<AyahListScreen> createState() => _AyahListScreenState();
}

class _AyahListScreenState extends State<AyahListScreen> {
  AudioPlayer? audioPlayer;
  int? currentlyPlayingIndex;
  List<AyahDetail> _ayahList = [];
  bool _isLoading = true;
  Set<int> disabledIndices = {}; // Add this to your state

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  @override
  void dispose() {
    audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> _loadList() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = prefs.getStringList(widget.sharedPrefKey) ?? [];

    setState(() {
      _ayahList = encodedList.map((jsonStr) {
        final decoded = json.decode(jsonStr);
        return AyahDetail.fromMap(decoded);
      }).toList();

      _isLoading = false;
    });
  }

  Future<void> _clearList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(widget.sharedPrefKey);
    setState(() {
      _ayahList = [];
    });
  }

  void _deleteItem(AyahDetail ayah) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _ayahList.removeWhere((a) => a.surahNumber == ayah.surahNumber && a.surahNumber == ayah.surahNumber);
      final updatedList = _ayahList.map((a) => json.encode(a.toMap())).toList();
      prefs.setStringList(widget.sharedPrefKey, updatedList);
    });
  }

  void playAudio(String url, int index, double speed) async {
    print('url');
    print(url);
    audioPlayer?.dispose();
    final player = AudioPlayer();
    await player.setUrl(url);
    player.setSpeed(speed);

    setState(() {
      audioPlayer = player;
      currentlyPlayingIndex = index;
    });
    await player.play();

    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          currentlyPlayingIndex = null;
          audioPlayer = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);
    final fontFamily = fontProvider.fontFamily;
    final speed = settingsProvider.playbackSpeed;
    final theme = AppColors.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primary,
        iconTheme: IconThemeData(color: theme.textWhite),
        actions: [
          if (_ayahList.isNotEmpty && widget.allowClearAll)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _clearList,
              tooltip: 'Clear All',
            ),
        ],
        title: Text(widget.title, style: TextStyle(color: theme.textWhite)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _ayahList.isEmpty
          ? const Center(
        child: Text('No items found', style: TextStyle(fontSize: 18)),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: _ayahList.length,
        itemBuilder: (context, index) {
          final ayah = _ayahList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AyahDetailView(ayah: ayah, theme: theme,),
                ),
              );
            },
            child: _buildItem(ayah, index, speed, fontFamily, theme),
          );
        },
      ),
    );
  }

  Widget _buildItem(AyahDetail ayah, int index, double speed, String font, AppTheme theme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient:  LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [theme.accent, theme.background],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: theme.secondary, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${ayah.surahNameArabic} - ${ayah.surahNameEnglish} | ${ayah.numberDetail()}',
                    style: TextStyle(
                      fontFamily: font,
                      color: theme.primary,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      currentlyPlayingIndex == index
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: theme.primary,
                      size: 34,
                    ),
                    onPressed: disabledIndices.contains(index)
                        ? null // Disable button
                        : () async {
                      setState(() {
                        disabledIndices.add(index); // Disable this index
                      });

                      // Re-enable after 2 seconds
                      Future.delayed(Duration(seconds: 2), () {
                        setState(() {
                          disabledIndices.remove(index);
                        });
                      });

                      if (currentlyPlayingIndex == index) {
                        await audioPlayer?.stop();
                        setState(() {
                          currentlyPlayingIndex = null;
                        });
                      } else {
                        var audio = await ayah.audioRecite();
                        playAudio(audio, index, speed);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TappableAyahWord(
                child: Text(
                  ayah.arabic,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: font,
                    fontSize: 24,
                    color: theme.textBlack
                  ),
                ),
                onTapConfirmed: () {},
              ),
              const SizedBox(height: 16),
              Text(
                ayah.translation,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16, color: theme.textBlack),
              ),
              if (widget.allowDelete)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteItem(ayah),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

