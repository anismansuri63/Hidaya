
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AyahDetail {
  String surahNameArabic;
  String surahNameEnglish;
  String arabic;
  String transliteration;
  String translation;
  String surahNumber;
  String ayahNumber;
  String tafsir;
  String audio;
  Map<String, String> wordsToLearn;
  String numberDetail() {
    return '$surahNumber:$ayahNumber';
  }
  Future<String> audioRecite() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('selected_reciter') ?? '1';
    if (['1', '2', '3', '4', '5'].contains(id)) {
      return 'https://the-quran-project.github.io/Quran-Audio/Data/$id/${surahNumber}_$ayahNumber.mp3';
    }
    if (id == '6') {
      String paddedSurah = surahNumber.padLeft(3, '0');
      String paddedAyah = ayahNumber.padLeft(3, '0');
      String url = "https://everyayah.com/data/Saood_ash-Shuraym_128kbps/$paddedSurah$paddedAyah.mp3";
      return url;
    }
    return 'https://the-quran-project.github.io/Quran-Audio/Data/1/${surahNumber}_$ayahNumber.mp3';
  }

  AyahDetail({
    required this.surahNameArabic,
    required this.surahNameEnglish,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.surahNumber,
    required this.ayahNumber,
    required this.tafsir,
    required this.audio,
    required this.wordsToLearn,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'surahNameArabic': surahNameArabic,
      'surahNameEnglish': surahNameEnglish,
      'arabic': arabic,
      'transliteration': transliteration,
      'translation': translation,
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'tafsir': tafsir,
      'audio': audio,
      'wordsToLearn': json.encode(wordsToLearn),
    };
  }

  // Create from Map
  factory AyahDetail.fromMap(Map<String, dynamic> map) {
    return AyahDetail(
      surahNameArabic: map['surahNameArabic'],
      surahNameEnglish: map['surahNameEnglish'],
      arabic: map['arabic'],
      transliteration: map['transliteration'],
      translation: map['translation'],
      surahNumber: map['surahNumber'],
      ayahNumber: map['ayahNumber'],
      tafsir: map['tafsir'],
      audio: map['audio'],
      wordsToLearn: Map<String, String>.from(json.decode(map['wordsToLearn'])),
    );
  }


}

class Ayah {
  final String arabic;
  final String translation;
  final String audio;
  final String surah;
  final int number;

  Ayah({
    required this.arabic,
    required this.translation,
    required this.audio,
    required this.surah,
    required this.number,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      arabic: json['arabic'] ?? '',
      translation: json['translation'] ?? '',
      audio: json['audio'] ?? '',
      surah: json['surah'] ?? '',
      number: json['number'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arabic': arabic,
      'translation': translation,
      'audio': audio,
      'surah': surah,
      'number': number,
    };
  }
}

// ayah.dart
class AyahResponse {
  final int code;
  final String status;
  final AyahData data;

  AyahResponse({required this.code, required this.status, required this.data});

  factory AyahResponse.fromJson(Map<String, dynamic> json) => AyahResponse(
    code: json['code'],
    status: json['status'],
    data: AyahData.fromJson(json['data']),
  );
}


class AyahData {
  final int number;
  final String? audio;
  final List<String>? audioSecondary;
  final String text;
  final Edition edition;
  final Surah surah;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final bool sajda;

  AyahData({
    required this.number,
    this.audio,
    this.audioSecondary,
    required this.text,
    required this.edition,
    required this.surah,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  factory AyahData.fromJson(Map<String, dynamic> json) => AyahData(
    number: json['number'],
    audio: json['audio'],
    audioSecondary: (json['audioSecondary'] as List<dynamic>?)?.cast<String>(),
    text: json['text'],
    edition: Edition.fromJson(json['edition']),
    surah: Surah.fromJson(json['surah']),
    numberInSurah: json['numberInSurah'],
    juz: json['juz'],
    manzil: json['manzil'],
    page: json['page'],
    ruku: json['ruku'],
    hizbQuarter: json['hizbQuarter'],
    sajda: json['sajda'] is bool ? json['sajda'] : json['sajda'] != null,
  );
}

class Edition {
  final String identifier;
  final String language;
  final String name;
  final String englishName;
  final String format;
  final String type;
  final String? direction;

  Edition({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
    this.direction,
  });

  factory Edition.fromJson(Map<String, dynamic> json) => Edition(
    identifier: json['identifier'],
    language: json['language'],
    name: json['name'],
    englishName: json['englishName'],
    format: json['format'],
    type: json['type'],
    direction: json['direction'],
  );
}

class Surah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
    number: json['number'],
    name: json['name'],
    englishName: json['englishName'],
    englishNameTranslation: json['englishNameTranslation'],
    numberOfAyahs: json['numberOfAyahs'],
    revelationType: json['revelationType'],
  );
}
