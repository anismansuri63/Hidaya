class TafsirResponse {
  final TafsirData? tafsir;

  TafsirResponse({this.tafsir});

  factory TafsirResponse.fromJson(Map<String, dynamic> json) => TafsirResponse(
    tafsir: json['tafsir'] != null ? TafsirData.fromJson(json['tafsir']) : null,
  );
}

class TafsirData {
  final Map<String, TafsirVerse>? verses;
  final int? resourceID;
  final String? resourceName;
  final int? languageID;
  final String? slug;
  final TranslatedName? translatedName;
  final String? text;

  TafsirData({
    this.verses,
    this.resourceID,
    this.resourceName,
    this.languageID,
    this.slug,
    this.translatedName,
    this.text,
  });
  // List<(String, String)> getWords(String verse) {
  //   final words = verses?[verse]?.words?? [];
  //   return words.map<(String, String)>((word) {
  //     final arabicText = word.text ?? '';
  //     final translationText = word.translation?.text ?? '';
  //     return (arabicText, translationText);
  //   }).toList();
  // }
  Map<String, String> getWordsDic(String verse) {
    final words = verses?[verse]?.words ?? [];
    return {
      for (var word in words)
        (word.text ?? ''): (word.translation?.text ?? '')
    };
  }
  String arabic(String verse) {
    final words = verses?[verse]?.words;
    print(words);
    if (words == null) return '';
    return words
        .map((w) => w.text ?? '')
        .join(' ');
  }
  String translation(String verse) {
    final words = verses?[verse]?.words;
    print(words);
    if (words == null) return '';
    return words
        .map((w) => w.translation?.text ?? '')
        .join(' ');
  }
  String transliteration(String verse) {
    final words = verses?[verse]?.words;
    print(words);
    if (words == null) return '';
    return words
        .map((w) => w.transliteration?.text ?? '')
        .join(' ');
  }

  factory TafsirData.fromJson(Map<String, dynamic> json) => TafsirData(
    verses: (json['verses'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(k, TafsirVerse.fromJson(v)),
    ),
    resourceID: json['resource_id'],
    resourceName: json['resource_name'],
    languageID: json['language_id'],
    slug: json['slug'],
    translatedName: json['translated_name'] != null ? TranslatedName.fromJson(json['translated_name']) : null,
    text: json['text'],
  );
}

class TranslatedName {
  final String? name;
  final String? languageName;

  TranslatedName({this.name, this.languageName});

  factory TranslatedName.fromJson(Map<String, dynamic> json) => TranslatedName(
    name: json['name'],
    languageName: json['language_name'],
  );
}

class TafsirVerse {
  final int? id;
  final List<TafsirWord>? words;

  TafsirVerse({this.id, this.words});

  factory TafsirVerse.fromJson(Map<String, dynamic> json) => TafsirVerse(
    id: json['id'],
    words: (json['words'] as List<dynamic>?)?.map((e) => TafsirWord.fromJson(e)).toList(),
  );
}

class TafsirWord {
  final int? id;
  final int? position;
  final String? audioURL;
  final String? codeV1;
  final int? pageNumber;
  final String? charTypeName;
  final int? lineNumber;
  final String? text;
  final TafsirLangText? translation;
  final TafsirLangText? transliteration;

  TafsirWord({
    this.id,
    this.position,
    this.audioURL,
    this.codeV1,
    this.pageNumber,
    this.charTypeName,
    this.lineNumber,
    this.text,
    this.translation,
    this.transliteration,
  });

  factory TafsirWord.fromJson(Map<String, dynamic> json) => TafsirWord(
    id: json['id'],
    position: json['position'],
    audioURL: json['audio_url'],
    codeV1: json['code_v1'],
    pageNumber: json['page_number'],
    charTypeName: json['char_type_name'],
    lineNumber: json['line_number'],
    text: json['text'],
    translation: json['translation'] != null ? TafsirLangText.fromJson(json['translation']) : null,
    transliteration: json['transliteration'] != null ? TafsirLangText.fromJson(json['transliteration']) : null,
  );
}

class TafsirLangText {
  final String? text;
  final String? languageName;
  final int? languageID;

  TafsirLangText({this.text, this.languageName, this.languageID});

  factory TafsirLangText.fromJson(Map<String, dynamic> json) => TafsirLangText(
    text: json['text'],
    languageName: json['language_name'],
    languageID: json['language_id'],
  );
}