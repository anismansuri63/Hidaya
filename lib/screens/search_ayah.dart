import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/ayah_provider.dart';
import '../widget/ayah_widget.dart';
import '../theme/app_colors.dart';
class SearchAyahScreen extends StatefulWidget {
  @override
  _SearchAyahScreenState createState() => _SearchAyahScreenState();
}

class _SearchAyahScreenState extends State<SearchAyahScreen> {
  final _surahController = TextEditingController();
  final _ayahController = TextEditingController();

  int? _maxAyah;
  bool _isAyahFieldEnabled = false;

  final ayahsPerSurah = [
    7, 286, 200, 176, 120, 165, 206, 75, 129, 109,
    123, 111, 43, 52, 99, 128, 111, 110, 98, 135,
    112, 78, 118, 64, 77, 227, 93, 88, 69, 60,
    34, 30, 73, 54, 45, 83, 182, 88, 75, 85,
    54, 53, 89, 59, 37, 35, 38, 29, 18, 45,
    60, 49, 62, 55, 78, 96, 29, 22, 24, 13,
    14, 11, 11, 18, 12, 12, 30, 52, 52, 44,
    28, 28, 20, 56, 40, 31, 50, 40, 46, 42,
    29, 19, 36, 25, 22, 17, 19, 26, 30, 20,
    15, 21, 11, 8, 8, 19, 5, 8, 8, 11,
    11, 8, 3, 9, 5, 4, 7, 3, 6, 3,
    5, 4, 5, 6
  ];

  @override
  void initState() {
    super.initState();
    _surahController.addListener(_handleSurahChange);
    // Clear previous ayah result when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AyahProvider>(context, listen: false).resetSearchedAyah();
    });
  }

  @override
  void dispose() {
    _surahController.removeListener(_handleSurahChange);
    _surahController.dispose();
    _ayahController.dispose();
    super.dispose();
  }

  void _handleSurahChange() {
    final input = _surahController.text.trim();

    // Handle empty field
    if (input.isEmpty) {
      setState(() {
        _maxAyah = null;
        _isAyahFieldEnabled = false;
        _ayahController.clear();
      });
      return;
    }

    final surahNum = int.tryParse(input);
    if (surahNum != null && surahNum >= 1 && surahNum <= 114) {
      setState(() {
        _maxAyah = ayahsPerSurah[surahNum - 1];
        _isAyahFieldEnabled = true;
      });
    } else {
      setState(() {
        _maxAyah = null;
        _isAyahFieldEnabled = false;
        _ayahController.clear();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AyahProvider>(context);
    final ayah = provider.searchedAyah;
    final theme = AppColors.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // This hides the keyboard
      },

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primary,
          iconTheme: IconThemeData(
            color: theme.textWhite, // ← Set your desired color here
          ),
          title: Text("Search Ayah",
          style: TextStyle(color: theme.textWhite),),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: _surahController,
                      keyboardType: TextInputType.number,
                      cursorColor: theme.textBlack,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        SurahRangeFormatter(),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Surah(1–114)',
                        labelStyle: TextStyle(fontSize: 14,
                        color: theme.textBlack),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: theme.primary), // default border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: theme.secondary, width: 2), // when focused
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: TextField(
                      enabled: _isAyahFieldEnabled,
                      controller: _ayahController,
                      keyboardType: TextInputType.number,
                      cursorColor: theme.textBlack,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        if (_maxAyah != null)
                          AyahRangeFormatter(max: _maxAyah!),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Ayah',
                        labelStyle: TextStyle(fontSize: 14,color: theme.textBlack),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: theme.primary), // default border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: theme.secondary, width: 2), // when focused
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.secondary,
                    ),
                    onPressed: () async {
                      FocusScope.of(context).unfocus(); // dismiss keyboard

                      final surah = _surahController.text.trim();
                      final ayahNum = _ayahController.text.trim();

                      if (surah.isNotEmpty &&
                          ayahNum.isNotEmpty &&
                          int.tryParse(surah) != null &&
                          int.tryParse(ayahNum) != null &&
                          int.parse(surah) >= 1 &&
                          int.parse(surah) <= 114 &&
                          _maxAyah != null &&
                          int.parse(ayahNum) >= 1 &&
                          int.parse(ayahNum) <= _maxAyah!) {
                        await provider.fetchSpecificAyah(surah, ayahNum);

                        if (provider.errorTitle.isNotEmpty ||
                            provider.errorDesc.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(provider.errorTitle),
                              content: Text(provider.errorDesc),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(),
                                  child: Text("OK"),
                                )
                              ],
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      "Fetch",
                      style: TextStyle(color: theme.textWhite),
                    ),
                  ),
                ],
              ),
            ),
            if (provider.isLoading)
              CircularProgressIndicator()
            else if (ayah != null)
              Expanded(
                child: ListView(
                  children: [
                    AyahWidget(ayah: ayah, font: provider.selectedFont, widgetValue: previousNext(context)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  Widget previousNext(BuildContext context) {
    final provider = Provider.of<AyahProvider>(context, listen: false);
    final ayah = provider.searchedAyah;
    if (ayah == null) {
      return SizedBox(height: 1);
    }
    final currentSurah = int.tryParse(ayah.surahNumber) ?? 0;
    final currentAyah = int.tryParse(ayah.ayahNumber) ?? 0;

    // Bounds check
    final isFirstAyah = currentSurah == 1 && currentAyah == 1;
    final isLastAyah = currentSurah == 114 && currentAyah == ayahsPerSurah[113];
    final theme = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isFirstAyah ? Colors.grey :  theme.secondary,
            ),
            onPressed: isFirstAyah
                ? null
                : () async {
              int newSurah = currentSurah;
              int newAyah = currentAyah;

              if (currentAyah > 1) {
                newAyah -= 1;
              } else if (currentSurah > 1) {
                newSurah -= 1;
                newAyah = ayahsPerSurah[newSurah - 1]; // previous surah's last ayah
              }
              _surahController.text = newSurah.toString();
              _ayahController.text = newAyah.toString();
              await provider.fetchSpecificAyah(
                newSurah.toString(),
                newAyah.toString(),
              );
            },
            child: Text(
              "Previous",
              style: TextStyle(color: theme.textWhite),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isLastAyah ? Colors.grey :  theme.secondary,
            ),
            onPressed: isLastAyah
                ? null
                : () async {
              int newSurah = currentSurah;
              int newAyah = currentAyah;
              final maxAyah = ayahsPerSurah[currentSurah - 1];

              if (currentAyah < maxAyah) {
                newAyah += 1;
              } else if (currentSurah < 114) {
                newSurah += 1;
                newAyah = 1;
              }
              _surahController.text = newSurah.toString();
              _ayahController.text = newAyah.toString();
              await provider.fetchSpecificAyah(
                newSurah.toString(),
                newAyah.toString(),
              );
            },
            child: Text(
              "Next",
              style: TextStyle(color: theme.textWhite),
            ),
          ),
        ],
      ),
    );
  }


}

// Formatter to allow only 1–114 for Surah
class SurahRangeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final input = newValue.text;

    // Allow empty string so user can delete
    if (input.isEmpty) return newValue;

    final number = int.tryParse(input);

    // Block only if number is invalid and not null
    if (number == null || number < 1 || number > 114) {
      return oldValue;
    }

    return newValue;
  }
}


// Formatter to restrict Ayah number based on Surah's max ayah count
class AyahRangeFormatter extends TextInputFormatter {
  final int max;
  AyahRangeFormatter({required this.max});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final input = newValue.text;
    if (input.isEmpty) return newValue; // Allow deletion
    final number = int.tryParse(input);
    if (number == null || number < 1 || number > max) {
      return oldValue;
    }
    return newValue;
  }
}
