import 'dart:convert';

import 'package:com_quranicayah/providers/font_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/settings_provider.dart';
import 'ayah_detail_screen.dart';
import '../models/ayah.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  AudioPlayer? audioPlayer;
  int? currentlyPlayingIndex;
  List<AyahDetail> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    audioPlayer?.dispose();
    super.dispose();
  }
  void playAudio(String url, int index, double speed) async {
    audioPlayer?.stop();
    final player = AudioPlayer();
    await player.setUrl(url);
    player.setSpeed(speed);
    await player.play();

    setState(() {
      audioPlayer = player;
      currentlyPlayingIndex = index;
    });

    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          currentlyPlayingIndex = null;
          audioPlayer = null;
        });
      }
    });
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = prefs.getStringList('ayahArchive') ?? [];

    setState(() {
      _history = encodedList.map<AyahDetail>((jsonStr) {
        final decoded = json.decode(jsonStr);
        return AyahDetail.fromMap(decoded);
      }).toList();

      _isLoading = false;
    });
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('ayahArchive');
    setState(() {
      _history = [];
    });
  }
  void _deleteHistoryItem(AyahDetail ayah) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history.remove(ayah);
      final updatedList = _history.map((a) => json.encode(a.toMap())).toList();

      prefs.setStringList('ayahArchive', updatedList);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);
    final fontFamily = fontProvider.fontFamily;
    final speed = settingsProvider.playbackSpeed;
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _clearHistory,
              tooltip: 'Clear History',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
          ? const Center(
        child: Text(
          'No history yet',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final ayah = _history[index];

          return GestureDetector(
            onTap: () {
              print('detail');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AyahDetailView(
                      ayah: ayah

                  ),
                ),
              );
            },
            child: _buildHistoryItem(ayah, index, speed, fontFamily),

          );

        },
      ),
    );
  }

  Widget _buildHistoryItem(AyahDetail ayah, int index, double speed, String font) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8F5F0), Color(0xFFE8E3D7)],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFD4A017), width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Header with surah info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${ayah.surahNameArabic} - ${ayah.surahNameEnglish} | ${ayah.numberDetail()}',
                    style: TextStyle(
                      fontFamily: font,
                      color: const Color(0xFF0A5E2A),
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      currentlyPlayingIndex == index ? Icons.pause_circle_filled : Icons.play_circle_fill,
                      color: Color(0xFF0A5E2A),
                      size: 26,
                    ),
                    onPressed: () {
                      if (currentlyPlayingIndex == index) {
                        audioPlayer?.stop();
                        setState(() {
                          currentlyPlayingIndex = null;
                        });
                      } else {
                        final url = ayah.audio;
                        if (url.isNotEmpty) {
                          playAudio(url, index, speed);
                        }
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Arabic text
              Text(
                ayah.arabic,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: font,
                  fontSize: 24,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 16),

              // Translation
              Text(
                ayah.translation,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteHistoryItem(ayah),
              )
            ],
          ),
        ),
      ),
    );
  }
}
