import 'package:com_quranicayah/providers/ayah_provider.dart';
import 'package:com_quranicayah/providers/font_provider.dart';
import 'package:com_quranicayah/screens/search_ayah.dart';
import 'package:com_quranicayah/screens/tasbih_counter_screen.dart';
import 'package:com_quranicayah/widget/audio_button.dart';
import 'package:com_quranicayah/widget/ayah_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/ayah.dart';
import '../widget/generate_button.dart';
import '../widget/word_by_word_grid.dart';
import 'app_drawer.dart';
import 'history_screen.dart';
import 'setting_screen.dart';
import 'full_tafsir_screen.dart';


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
    final isConnected = await viewModel.hasInternetConnection();
    if (!isConnected) {
      showNoInternetDialog(context);
      return;
    }
    await viewModel.fetchRandomAyah();
    await viewModel.fetchTafsir();

  }
  void _onItemTapped(int index) {

    setState(() {
      _selectedIndex = index;
    });
    print('_selectedIndex');
    print(_selectedIndex);


    // // Now navigate based on index
    switch (index) {
      case 0:
        break;
      case 8:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
        break;

      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  TasbihScreen()),
        );
        break;

      case 7:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  SearchAyahScreen()),
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
        final isConnected = await viewModel.hasInternetConnection();
        if (!isConnected) {
          showNoInternetDialog(context);
          return;
        }
        await viewModel.fetchRandomAyah();
        await viewModel.fetchTafsir();
      });
    }
  }
  void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("No Internet Connection"),
        content: const Text("Please check your network and try again."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

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
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0A5E2A), Color(0xFF1B7942)],
                    ),
                  ),
                  child: Column(
                    children: [
                      GenerateButton(onPressed: () {
                        _generateRandomAyah(viewModel);
                      }),
                      AyahWidget(ayah: viewModel.ayah, font: fontProvider.fontFamily),
                    ],
                  ),
                ),
              ),
              if (viewModel.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.4),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
    print(ayah.surahNameEnglish);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A5E2A).withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4A017), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            ayah.surahNameArabic,
            style: const TextStyle(
              fontFamily: 'AlQuranIndoPak',
              fontSize: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ayah.surahNameEnglish,
                style: const TextStyle(
                  fontFamily: 'Playfair',
                  fontSize: 20,
                  color: Color(0xFFD4A017),
                ),
              ),
              Text(
                'Surah ${ayah.surahNumber}:${ayah.ayahNumber}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AyahSection extends StatelessWidget {
  final AyahDetail ayah;
  final String font;
  const AyahSection({super.key, required this.ayah, required this.font});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4A017),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
                IconButton(
                  icon: Icon(Icons.share, color: Color(0xFF0A5E2A)),
                  onPressed: () => _shareAyah(ayah),
                ),
              AudioPlayButton(audioUrl: ayah.audio)
            ],
          ),
          Text(
            ayah.arabic,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: font,
              fontSize: 32,
              height: 1.8,
            ),
          ),
          Divider(color: Color(0xFFD4A017), thickness: 2),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Transliteration',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFFD4A017),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ayah.transliteration,
            style: const TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: Color(0xFF5D5A57),
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Translation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFFD4A017),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ayah.translation,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

// Add method to _MainScreenState
  void _shareAyah(AyahDetail ayah) {
    final text = """
${ayah.surahNameEnglish} (${ayah.numberDetail()})

${ayah.arabic}

${ayah.translation}

- Shared via Quran Ayah App
  """;

    Share.share(text, subject: 'Quran Ayah Sharing');
  }
}

class TafsirPreviewSection extends StatelessWidget {
  final AyahDetail detail;

  const TafsirPreviewSection({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E3D7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4A017)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.book, color: Color(0xFF0A5E2A), size: 28),
              const SizedBox(width: 10),
              const Text(
                'Tafsir Insight',
                style: TextStyle(
                  fontFamily: 'Playfair',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A5E2A),
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
              backgroundColor: const Color(0xFF0A5E2A),
              foregroundColor: Colors.white,
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



