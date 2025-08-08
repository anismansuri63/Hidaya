import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/recitations_screen.dart';

class RecitationProvider with ChangeNotifier {
  List<Recitation> _recitations = [];
  String? _selectedReciterId;

  List<Recitation> get recitations => _recitations;
  String? get selectedReciterId => _selectedReciterId;

  RecitationProvider() {
    _loadRecitations();
    _loadSelectedReciter();
  }

  void _loadRecitations() {
    _recitations = [
      Recitation(
        id: '1',
        name: 'Mishary Rashid Alafasy',
        imagePath: 'assets/images/people/Mishary.png',
        sampleUrl: 'https://the-quran-project.github.io/Quran-Audio/Data/1/1_2.mp3',
      ),
      Recitation(
        id: '2',
        name: 'AbuBakr Al Shatri',
        imagePath: 'assets/images/people/AbuBakrAlShatri.png',
        sampleUrl: 'https://the-quran-project.github.io/Quran-Audio/Data/2/1_2.mp3',
      ),
      Recitation(
        id: '3',
        name: 'Nasser Al Qatami',
        imagePath: 'assets/images/people/NasserAlQatami.png',
        sampleUrl: 'https://the-quran-project.github.io/Quran-Audio/Data/3/1_2.mp3',
      ),
      Recitation(
        id: '4',
        name: 'Yasser Al-Dosari',
        imagePath: 'assets/images/people/Yasser.png',
        sampleUrl: 'https://the-quran-project.github.io/Quran-Audio/Data/4/1_2.mp3',
      ),
      Recitation(
        id: '5',
        name: 'Hani Ar Rifai',
        imagePath: 'assets/images/people/HaniArRifai.png',
        sampleUrl: 'https://the-quran-project.github.io/Quran-Audio/Data/5/1_2.mp3',
      ),
      // Add more reciters here as needed
    ];
  }
  Future<void> _loadSelectedReciter() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedReciterId = prefs.getString('selected_reciter') ?? '1';
    notifyListeners();
  }

  Future<void> selectReciter(String id) async {
    _selectedReciterId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_reciter', id);
    print('selectReciter');
    print(id);
    notifyListeners();
  }
  @override
  void dispose() {
    super.dispose();
  }
}