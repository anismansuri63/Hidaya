import 'dart:convert';
import 'package:com_quranicayah/providers/ayah_provider.dart';
import 'package:com_quranicayah/providers/font_provider.dart';
import 'package:com_quranicayah/screens/flash_cards/difficulty_screen.dart';
import 'package:com_quranicayah/screens/recitations_screen.dart';
import 'package:com_quranicayah/screens/search_ayah.dart';
import 'package:com_quranicayah/screens/surah_list_screen.dart';
import 'package:com_quranicayah/screens/tasbih_counter_screen.dart';
import 'package:com_quranicayah/theme/app_theme.dart';
import 'package:com_quranicayah/widget/audio_button.dart';
import 'package:com_quranicayah/widget/ayah_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ayah.dart';
import '../widget/generate_button.dart';
import 'app_drawer.dart';
import 'ayah_list_screen.dart';
import 'setting_screen.dart';
import 'full_tafsir_screen.dart';
import '../theme/app_colors.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool hasLoaded = false;


  // Ayah _currentAyah = Ayah.sampleData[0];
  int _selectedIndex = 0;

  void _generateRandomAyah(AyahProvider viewModel) async {
    if (!kIsWeb) {
      final isConnected = await viewModel.hasInternetConnection();
      if (!isConnected) {
        showNoInternetDialog(context);
        return;
      }
    }

    await viewModel.fetchRandomAyah();
    await viewModel.fetchTafsir();

  }
  void _onItemTapped(int index) {

    setState(() {
      _selectedIndex = index;
    });

    // // Now navigate based on index
    switch (index) {
      case 0:
        break;

      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SurahListScreen()),
        );
        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AyahListScreen(
              title: 'Bookmarks',
              sharedPrefKey: 'ayahBookmark',
            ),
          ),
        );

        break;

      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AyahListScreen(
              title: 'History',
              sharedPrefKey: 'ayahArchive',
            ),
          ),
        );

        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RecitationsScreen()),
        ).then((_) {
          // Trigger UI rebuild
          setState(() {});
        });
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  TasbihScreen()),
        );
        break;
      case 6:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DifficultyScreen()),
        );
        break;

      case 7:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  SearchAyahScreen()),
        );
        break;
      case 8:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
        break;

      default:
        break;
    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!hasLoaded) {
      hasLoaded = true;
      final viewModel = Provider.of<AyahProvider>(context, listen: false);
      Future(() async {
        if (!kIsWeb) {
          final isConnected = await viewModel.hasInternetConnection();
          if (!isConnected) {
            showNoInternetDialog(context);
            return;
          }
        }

        await viewModel.fetchRandomAyah();
        await viewModel.fetchTafsir();
      });
    }
  }
  void showNoInternetDialog(BuildContext context) {
    final theme = AppColors.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("No Internet Connection"),
        content: const Text("Please check your network and try again."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("OK", style: TextStyle(color: theme.primary),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran Ayah'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(
        onItemSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
      body: Consumer<AyahProvider>(
        builder: (context, viewModel, _) {
          final fontProvider = Provider.of<FontProvider>(context);

          return Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [theme.primary, theme.primary2],
                    ),
                  ),
                  child: Column(
                    children: [
                      GenerateButton(onPressed: () {
                        _generateRandomAyah(viewModel);
                      }),
                      AyahWidget(
                        key: ValueKey('${viewModel.ayah.surahNumber}:${viewModel.ayah.ayahNumber}'),
                        ayah: viewModel.ayah,
                        theme: theme,
                        font: fontProvider.fontFamily,
                      ),
                    ],
                  ),
                ),
              ),
              if (viewModel.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.4),
                  child:  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(theme.textWhite),
                    ),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final AyahDetail ayah;

  const HeaderSection({super.key, required this.ayah});

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:  theme.primary.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.secondary, width: 2),
        boxShadow: [
          BoxShadow(
            color: theme.textBlack.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            ayah.surahNameArabic,
            style: TextStyle(
              fontFamily: 'AlQuranIndoPak',
              fontSize: 28,
              color: theme.textWhite,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ayah.surahNameEnglish,
                style: TextStyle(
                  fontSize: 20,
                  color: theme.secondary,
                ),
              ),
              Text(
                'Surah ${ayah.surahNumber}:${ayah.ayahNumber}',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.textWhite,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AyahSection extends StatefulWidget {
  final AyahDetail ayah;
  final String font;
  final AppTheme theme;

  const AyahSection({super.key, required this.ayah, required this.font, required this.theme});

  @override
  State<AyahSection> createState() => _AyahSectionState();
}

class _AyahSectionState extends State<AyahSection> {
  List<AyahDetail> _bookmarks = [];
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }
  @override
  void didUpdateWidget(covariant AyahSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isSameAyah(oldWidget.ayah, widget.ayah)) {
      _loadBookmarks(); // reload only if the ayah changed
    }
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = prefs.getStringList('ayahBookmark') ?? [];

    final loadedBookmarks = encodedList.map((jsonStr) {
      final decoded = json.decode(jsonStr);
      return AyahDetail.fromMap(decoded);
    }).toList();

    final isBookmarked = loadedBookmarks.any((ayah) => _isSameAyah(ayah, widget.ayah));
    setState(() {
      _bookmarks = loadedBookmarks;
      _isBookmarked = isBookmarked;
    });
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();

    final exists = _bookmarks.any((ayah) => _isSameAyah(ayah, widget.ayah));

    setState(() {
      if (exists) {
        _bookmarks.removeWhere((ayah) => _isSameAyah(ayah, widget.ayah));
        _isBookmarked = false;
      } else {
        _bookmarks.add(widget.ayah);
        _isBookmarked = true;
      }
    });

    final updatedEncoded = _bookmarks.map((ayah) => json.encode(ayah.toMap())).toList();
    await prefs.setStringList('ayahBookmark', updatedEncoded);
  }

  bool _isSameAyah(AyahDetail a, AyahDetail b) {
    return a.surahNumber == b.surahNumber && a.ayahNumber == b.ayahNumber;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.accent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.secondary,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.textBlack.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.share, color: theme.primary),
                    onPressed: () => _shareAyah(widget.ayah),
                  ),
                  FutureBuilder<String>(
                    future: widget.ayah.audioRecite(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // or a placeholder widget
                      } else if (snapshot.hasError) {
                        return Text('Error loading audio');
                      } else {
                        return AudioPlayButton(audioUrl: snapshot.data!);
                      }
                    },
                  )
                  //AudioPlayButton(audioUrl: widget.ayah.audioRecite()),
                ],
              ),

              IconButton(
                icon: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                  color: theme.primary,
                ),
                onPressed: _toggleBookmark,
              )
            ],
          ),
          Text(
            widget.ayah.arabic,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: widget.font,
              fontSize: 32,
              height: 1.8,
              color: theme.textBlack,
            ),
          ),
          Divider(color: theme.secondary, thickness: 2),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Transliteration',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: theme.secondary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.ayah.transliteration,
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: theme.textBlack,
              fontWeight: FontWeight.w500
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Translation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: theme.secondary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.ayah.translation,
            style: TextStyle(
              fontSize: 18,
              color: theme.textBlack,
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }

  void _shareAyah(AyahDetail ayah) {
    final text = """
${ayah.surahNameEnglish} (${ayah.numberDetail()})

${ayah.arabic}

${ayah.translation}

- Shared via Hidayat App
""";
    Share.share(text, subject: 'Quran Ayah Sharing');
  }
}


class TafsirPreviewSection extends StatelessWidget {
  final AyahDetail detail;

  const TafsirPreviewSection({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:  theme.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color:  theme.secondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.book, color: theme.primary, size: 28),
              const SizedBox(width: 10),
              Text(
                'Tafsir Insight',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullTafsirView(detail: detail),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:  theme.primary,
              foregroundColor: theme.textWhite,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Read Full Tafsir', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



