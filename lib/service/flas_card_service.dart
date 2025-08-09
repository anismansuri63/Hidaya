import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FlashCardService {
  static const String _flashCardKey = 'flash_card_words';

  /// Save unique words to SharedPreferences
  static Future<void> saveWordsForFlashCard(Map<String, String> newWords) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve existing words first
    final existingJson = prefs.getString(_flashCardKey);
    Map<String, String> existingWords = {};
    if (existingJson == null) {
      existingWords = allWords;
    }
    if (existingJson != null) {
      existingWords = Map<String, String>.from(json.decode(existingJson));
    }

    // Merge and keep unique keys
    existingWords.addAll(newWords);

    // Save updated map
    await prefs.setString(_flashCardKey, json.encode(existingWords));
  }

  /// Retrieve saved words as Map<String, String>
  static Future<Map<String, String>> getWordsForFlashCard() async {
    final prefs = await SharedPreferences.getInstance();
    final wordsJson = prefs.getString(_flashCardKey);

    if (wordsJson == null) {
      return {};
    }
    var finalResult = Map<String, String>.from(json.decode(wordsJson));
    return finalResult;
  }
  static final Map<String, String> allWords = {
    // First group
    "وَلَقَدْ": "And certainly",
    "نَعْلَمُ": "We know",
    "أَنَّهُمْ": "that they",
    "يَقُولُونَ": "say",
    "إِنَّمَا": "Only",
    "يُعَلِّمُهُۥ": "teaches him",
    "بَشَرٌۭ ۗ": "a human being",
    "لِّسَانُ": "(The) tongue",
    "ٱلَّذِى": "(of) the one",
    "يُلْحِدُونَ": "they refer",
    "إِلَيْهِ": "to him",
    "أَعْجَمِىٌّۭ": "(is) foreign",
    "وَهَـٰذَا": "while this",
    "لِسَانٌ": "(is) a language",
    "عَرَبِىٌّۭ": "Arabic",
    "مُّبِينٌ": "clear",

    // Second group
    "۞ يَسْـَٔلُونَكَ": "They ask you",
    "عَنِ": "about",
    "ٱلْخَمْرِ": "[the] intoxicants",
    "وَٱلْمَيْسِرِ ۖ": "and [the] games of chance",
    "قُلْ": "Say",
    "فِيهِمَآ": "In both of them",
    "إِثْمٌۭ": "(is) a sin",
    "كَبِيرٌۭ": "great",
    "وَمَنَـٰفِعُ": "and (some) benefits",
    "لِلنَّاسِ": "for [the] people",
    "وَإِثْمُهُمَآ": "But sin of both of them",
    "أَكْبَرُ": "(is) greater",
    "مِن": "than",
    "نَّفْعِهِمَا ۗ": "(the) benefit of (the) two",
    "وَيَسْـَٔلُونَكَ": "And they ask you",
    "مَاذَا": "what",
    "يُنفِقُونَ": "they (should) spend",
    "قُلِ": "Say",
    "ٱلْعَفْوَ ۗ": "The surplus",
    "كَذَٰلِكَ": "Thus",
    "يُبَيِّنُ": "makes clear",
    "ٱللَّهُ": "Allah",
    "لَكُمُ": "to you",
    "ٱلْـَٔايَـٰتِ": "[the] Verses",
    "لَعَلَّكُمْ": "so that you may",
    "تَتَفَكَّرُونَ": "ponder",

    // Third group
    "وَإِنَّهُۥ": "And indeed, he",
    "عَلَىٰ": "on",
    "ذَٰلِكَ": "that",
    "لَشَهِيدٌۭ": "surely (is) a witness",

    // Fourth group
    "ثُمَّ": "Then",
    "بَعَثْنَا": "We sent",
    "مِنۢ": "after him",
    "بَعْدِهِۦ": "after him",
    "رُسُلًا": "Messengers",
    "إِلَىٰ": "to",
    "قَوْمِهِمْ": "their people",
    "فَجَآءُوهُم": "and they came to them",
    "بِٱلْبَيِّنَـٰتِ": "with clear proofs",
    "فَمَا": "But not",
    "كَانُوا۟": "they were",
    "لِيُؤْمِنُوا۟": "to believe",
    "بِمَا": "what",
    "كَذَّبُوا۟": "they had denied",
    "بِهِۦ": "[it]",
    "قَبْلُ ۚ": "before",
    "نَطْبَعُ": "We seal",
    "قُلُوبِ": "the hearts",
    "ٱلْمُعْتَدِينَ": "(of) the transgressors",

    // Fifth group
    "وَقَرْنَ": "And stay",
    "فِى": "in",
    "بُيُوتِكُنَّ": "your houses",
    "وَلَا": "and (do) not",
    "تَبَرَّجْنَ": "display yourselves",
    "تَبَرُّجَ": "(as was the) display",
    "ٱلْجَـٰهِلِيَّةِ": "(of the times of) ignorance",
    "ٱلْأُولَىٰ ۖ": "the former",
    "وَأَقِمْنَ": "And establish",
    "ٱلصَّلَوٰةَ": "the prayer",
    "وءَاتِينَ": "and give",
    "ٱلزَّكَوٰةَ": "zakah",
    "وَأَطِعْنَ": "and obey",
    "ٱللَّهَ": "Allah",
    "وَرَسُولَهُۥٓ ۚ": "and His Messenger",
    "يُرِيدُ": "Allah wishes",
    "لِيُذْهِبَ": "to remove",
    "عَنكُمُ": "from you",
    "ٱلرِّجْسَ": "the impurity",
    "أَهْلَ": "(O) People",
    "ٱلْبَيْتِ": "(of) the House",
    "وَيُطَهِّرَكُمْ": "And to purify you",
    "تَطْهِيرًۭا": "(with thorough) purification",

    // Sixth group
    "ءَامَنَ": "believed",
    "ٱلرَّسُولُ": "the Messenger",
    "بِمَآ": "in what",
    "أُنزِلَ": "was revealed",
    "إِلَيْهِ": "to him",
    "مِن": "from",
    "رَّبِّهِۦ": "his Lord",
    "وَٱلْمُؤْمِنُونَ ۚ": "and the believers",
    "كُلٌّ": "All",
    "بِٱللَّهِ": "in Allah",
    "وَمَلَـٰٓئِكَتِهِۦ": "and His Angels",
    "وَكُتُبِهِۦ": "and His Books",
    "وَرُسُلِهِۦ": "and His Messengers",
    "لَا": "Not",
    "نُفَرِّقُ": "we make distinction",
    "بَيْنَ": "between",
    "أَحَدٍۢ": "any",
    "رُّسُلِهِۦ ۚ": "His messengers",
    "وَقَالُوا۟": "And they said",
    "سَمِعْنَا": "We heard",
    "وَأَطَعْنَا ۖ": "and we obeyed",
    "غُفْرَانَكَ": "(Grant) us Your forgiveness",
    "رَبَّنَا": "our Lord",
    "وَإِلَيْكَ": "and to You",
    "ٱلْمَصِيرُ": "(is) the return",

    // Seventh group
    "يُكَلِّفُ": "burden",
    "نَفْسًا": "any soul",
    "إِلَّا": "except",
    "وُسْعَهَا ۚ": "its capacity",
    "لَهَا": "for it",
    "مَا": "what",
    "كَسَبَتْ": "it earned",
    "وَعَلَيْهَا": "and against it",
    "ٱكْتَسَبَتْ ۗ": "it earned",
    "تُؤَاخِذْنَآ": "take us to task",
    "إِن": "if",
    "نَّسِينَآ": "we forget",
    "أَوْ": "or",
    "أَخْطَأْنَا ۚ": "we err",
    "تَحْمِلْ": "lay",
    "عَلَيْنَآ": "upon us",
    "إِصْرًۭا": "a burden",
    "كَمَا": "like that",
    "حَمَلْتَهُۥ": "(which) You laid [it]",
    "عَلَى": "against",
    "ٱلَّذِينَ": "those who",
    "مِن": "(were) from",
    "قَبْلِنَا ۚ": "before us",
    "تُحَمِّلْنَا": "lay on us",
    "طَاقَةَ": "(the) strength",
    "لَنَا": "[for] us",
    "بِهِۦ ۖ": "[of it] (to bear)",
    "وَٱعْفُ": "And pardon",
    "عَنَّا": "[from] us",
    "وَٱغْفِرْ": "and forgive",
  };

}
