import 'dart:convert';
import 'dart:math';

import 'package:com_quranicayah/theme/app_colors.dart';
import 'package:com_quranicayah/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/flas_card_service.dart';

enum Difficulty {
  easy(2, "Easy (2 Options)"),
  medium(3, "Medium (3 Options)"),
  hard(4, "Hard (4 Options)"),
  extreme(5, "Extreme (5 Options)"),
  mix(0, "Mix (Random)");

  final int optionCount;
  final String displayName;

  const Difficulty(this.optionCount, this.displayName);
}

// 2. Flash Card Provider
class FlashCardProvider with ChangeNotifier {
  final Difficulty difficulty;
  final List<Map<String, String>> _wordPairs = [];
  List<FlashCard> _cards = [];
  int _currentIndex = 0;
  bool _showResult = false;
  bool _isCorrect = false;
  List<String> _currentOptions = [];
  String? _selectedOption;

  FlashCardProvider({required this.difficulty}) {
    _loadWordPairs();
  }

  List<FlashCard> get cards => _cards;
  int get currentIndex => _currentIndex;
  bool get showResult => _showResult;
  bool get isCorrect => _isCorrect;
  List<String> get currentOptions => _currentOptions;
  String? get selectedOption => _selectedOption;
  FlashCard get currentCard => _cards[_currentIndex];

  /// Load saved words and generate cards
  void _loadWordPairs() async {
    final savedMap = await FlashCardService.getWordsForFlashCard();

    final mapToUse = savedMap.isNotEmpty
        ? savedMap
        : FlashCardService.allWords;

    _wordPairs.clear();
    _wordPairs.addAll(
      mapToUse.entries.map((e) => {e.key: e.value}),
    );

    _generateCards();
  }

  void _generateCards() {
    var allCards = _wordPairs.map((pair) {
      final arabic = pair.keys.first;
      final english = pair.values.first;
      return FlashCard(arabic: arabic, english: english);
    }).toList();

    allCards.shuffle();
    _cards = allCards.take(10).toList();
    _generateOptions();
  }

  void _generateOptions() {
    final currentEnglish = currentCard.english;
    final allEnglish = _wordPairs.map((pair) => pair.values.first).toList();
    allEnglish.remove(currentEnglish);

    int optionCount = difficulty == Difficulty.mix
        ? Random().nextInt(4) + 2
        : difficulty.optionCount;

    final options = <String>[currentEnglish];
    while (options.length < optionCount && allEnglish.isNotEmpty) {
      final randomIndex = Random().nextInt(allEnglish.length);
      options.add(allEnglish.removeAt(randomIndex));
    }
    options.shuffle();
    _currentOptions = options;
    notifyListeners();
  }

  Future<void> _saveQuizResult() async {
    final prefs = await SharedPreferences.getInstance();

    final correctCards = _cards.where((c) => c.answeredCorrectly).toList();
    final wrongCards = _cards.where((c) => !c.answeredCorrectly).toList();

    final result = {
      'date': DateTime.now().toIso8601String(),
      'correct': correctCards
          .map((c) => {'arabic': c.arabic, 'english': c.english})
          .toList(),
      'wrong': wrongCards
          .map((c) => {'arabic': c.arabic, 'english': c.english})
          .toList(),
    };

    final historyJson = prefs.getString('quiz_history');
    List<dynamic> history = historyJson != null ? jsonDecode(historyJson) : [];

    history.insert(0, result);

    await prefs.setString('quiz_history', jsonEncode(history));
  }

  void selectOption(String option, BuildContext context, AppTheme theme) {
    _selectedOption = option;
    _isCorrect = option == currentCard.english;


    if (_isCorrect) {
      _cards[_currentIndex].answeredCorrectly = true;
    }

    _showResult = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 600), () async {
      if (_currentIndex < _cards.length - 1) {
        _currentIndex++;
        _showResult = false;
        _selectedOption = null;
        _generateOptions();
        notifyListeners();
      } else {
        await _saveQuizResult(); // Save results before showing dialog

        int correctCount = _cards.where((c) => c.answeredCorrectly).length;
        int total = _cards.length;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text("🎉 Completed!"),
            content: Text(
              "You got $correctCount out of $total correct!\n\n"
                  "${correctCount == total ? 'Perfect score! 🏆' : 'Keep practicing!'}",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("OK", style: TextStyle(color: theme.primary)),
              ),
            ],
          ),
        );
      }
    });
  }
}



class FlashCard {
  final String arabic;
  final String english;
  bool answeredCorrectly;

  FlashCard({
    required this.arabic,
    required this.english,
    this.answeredCorrectly = false,
  });
}

