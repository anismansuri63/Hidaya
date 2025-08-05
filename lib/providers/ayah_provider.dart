import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ayah.dart';
import '../models/quran_detail.dart';
import '../models/tafsir.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/services.dart' show rootBundle;



class AyahProvider with ChangeNotifier {
  String errorTitle = '';
  String errorDesc = '';
  AyahDetail ayah = AyahDetail(surahNameArabic: '', surahNameEnglish: '', arabic: '', transliteration: '', translation: '', surahNumber: '0', ayahNumber: '0', tafsir: '',audio: '', wordsToLearn: {});
  AyahDetail searchedAyah = AyahDetail(surahNameArabic: '', surahNameEnglish: '', arabic: '', transliteration: '', translation: '', surahNumber: '0', ayahNumber: '0', tafsir: '',audio: '', wordsToLearn: {});
  bool isLoading = false;
  String? _currentSurah;
  String? _currentAyah;
  String _selectedFont = 'AlQuranIndoPak.ttf';
  double _playbackSpeed = 1.0;

  String get selectedFont => _selectedFont;
  double get playbackSpeed => _playbackSpeed;

  AyahProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFont = prefs.getString('selectedFont') ?? 'AlQuranIndoPak';
    _playbackSpeed = prefs.getDouble('playbackSpeed') ?? 1.0;

    notifyListeners();
  }
  Future<QuranDetail> loadQuranDetail() async {
    final jsonString = await rootBundle.loadString('assets/quran.json');
    final jsonMap = jsonDecode(jsonString);
    return QuranDetail.fromJson(jsonMap);
  }
  Future<void> fetchRandomAyah() async {
    isLoading = true;
    notifyListeners();
    var ayahNumber = Random().nextInt(6236) + 1;
    final surahInfo = getSurahAndAyah(ayahNumber);
    QuranDetail detail = await loadQuranDetail();
    var current = detail.data.surahs.references[int.parse(surahInfo?['surah'] as String)];
    _currentSurah = surahInfo?['surah'];
    _currentAyah = surahInfo?['ayah'];

    ayah.audio = 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/$ayahNumber.mp3';
    ayah.surahNameArabic = current.name;
    ayah.surahNameEnglish = current.englishName;
    ayah.surahNumber = _currentSurah ?? '';
    ayah.ayahNumber = _currentAyah ?? '';
  }

  Future<void> fetchTafsir() async {
    if (_currentSurah == null || _currentAyah == null) return;

    try {
      final tafsirData = await fetchTafsirFor(
        surah: _currentSurah!,
        ayah: _currentAyah!,
      );
      String verse = '$_currentSurah:$_currentAyah';
      ayah.arabic = tafsirData!.arabic(verse);
      ayah.transliteration = tafsirData!.transliteration(verse);
      ayah.translation = tafsirData.translation(verse);
      ayah.tafsir = tafsirData.text ?? '';
      ayah.wordsToLearn = tafsirData.getWordsDic(verse);
      saveToArchive(ayah);
    } catch (e) {
      debugPrint('Tafsir fetch failed: $e');
    }

    notifyListeners();
    isLoading = false;
  }

  void saveToArchive(AyahDetail detail) async {

    final prefs = await SharedPreferences.getInstance();
    final archiveList =
        prefs.getStringList('ayahArchive')?.map((e) => json.decode(e)).toList() ?? [];
    final ayahMap = {
      'surahNameArabic': detail.surahNameArabic,
      'surahNameEnglish': detail.surahNameEnglish,
      'arabic': detail.arabic,
      'transliteration': detail.transliteration,
      'translation': detail.translation,
      'surahNumber': detail.surahNumber,
      'ayahNumber': detail.ayahNumber,
      'tafsir': detail.tafsir,
      'audio': detail.audio,
      'wordsToLearn': json.encode(detail.wordsToLearn),
    };

    archiveList.insert(0, ayahMap);
    prefs.setStringList(
      'ayahArchive',
      archiveList.map((e) => json.encode(e)).toList(),
    );
  }
  final List<int> ayahsPerSurah = [
    7, 286, 200, 176, 120, 165, 206, 75, 129, 109, 123, 111, 43, 52, 99, 128,
    111, 110, 98, 135, 112, 78, 118, 64, 77, 227, 93, 88, 69, 60, 34, 30,
    73, 54, 45, 83, 182, 88, 75, 85, 54, 53, 89, 59, 37, 35, 38, 29, 18,
    45, 60, 49, 62, 55, 78, 96, 29, 22, 24, 13, 14, 11, 11, 18, 12, 12, 30,
    52, 52, 44, 28, 28, 20, 56, 40, 31, 50, 40, 46, 42, 29, 19, 36, 25, 22,
    17, 19, 26, 30, 20, 15, 21, 11, 8, 8, 19, 5, 8, 8, 11, 11, 8, 3, 9, 5,
    4, 7, 3, 6, 3, 5, 4, 5, 6
  ];

  /// Returns the global ayah number
  int getGlobalAyahNumber(int surah, int ayahNum) {
    if (surah < 1 || surah > 114) return -1;
    if (ayahNum < 1 || ayahNum > ayahsPerSurah[surah - 1]) return -1;
    final previousAyahCount = ayahsPerSurah.sublist(0, surah - 1).fold(0, (a, b) => a + b);
    return previousAyahCount + ayahNum;
  }

  Map<String, String>? getSurahAndAyah(int globalAyahNumber) {
    if (globalAyahNumber < 1 || globalAyahNumber > 6236) return null;
    int currentCount = 0;
    for (int i = 0; i < ayahsPerSurah.length; i++) {
      int nextCount = currentCount + ayahsPerSurah[i];
      if (globalAyahNumber <= nextCount) {
        return {'surah': '${i + 1}', 'ayah': '${globalAyahNumber - currentCount}'};
      }
      currentCount = nextCount;
    }
    return null;
  }

  Future<TafsirData?> fetchTafsirFor({
    required String surah,
    required String ayah,
    int tafsirResourceId = 169,
    String locale = 'en',
    bool includeWords = true,
  }) async {
    final verseKey = '$surah:$ayah';
    final url = Uri.parse(
        'https://api.qurancdn.com/api/v4/tafsirs/$tafsirResourceId/by_ayah/$verseKey?locale=$locale&words=$includeWords');

    final res = await http.get(url)
    .timeout(const Duration(seconds: 10));
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      return TafsirResponse.fromJson(decoded).tafsir;
    }
    return null;
  }

  Future<bool> hasInternetConnection() async {
    // Check if device is connected to a network (WiFi/Mobile)
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    // Check if the network has actual internet access
    return await InternetConnectionChecker().hasConnection;
  }
  Future<void> fetchSpecificAyah(String surah, String ayahNum) async {
    isLoading = true;
    notifyListeners();
    errorTitle = '';
    errorDesc = '';
    try {
      QuranDetail detail = await loadQuranDetail();
      var current = detail.data.surahs.references[int.parse(surah)];

      final ayahNumber = getGlobalAyahNumber(int.parse(surah), int.parse(ayahNum));

      final audio = 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/$ayahNumber.mp3';

      try {
        final tafsirData = await fetchTafsirFor(
          surah: surah,
          ayah: ayahNum,
        );
        String verse = '$surah:$ayahNum';

        searchedAyah = AyahDetail(
          surahNameArabic: current.name,
          surahNameEnglish: current.englishName,
          arabic: tafsirData?.arabic(verse) ?? '',
          transliteration: tafsirData!.transliteration(verse),
          translation: tafsirData.translation(verse),
          surahNumber: surah,
          ayahNumber: ayahNum,
          tafsir: tafsirData.text ?? '',
          audio: audio,
          wordsToLearn: tafsirData.getWordsDic(verse),
        );
        saveToArchive(searchedAyah);
      } catch (e) {
        debugPrint('Tafsir fetch failed: $e');
      }

    } catch (e) {
      debugPrint('Error fetching specific ayah: $e');
    }

    isLoading = false;
    notifyListeners();
  }


}