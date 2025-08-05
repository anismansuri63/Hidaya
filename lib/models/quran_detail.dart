// models/quran_detail.dart

class QuranDetail {
  final int code;
  final String status;
  final QuranData data;

  QuranDetail({required this.code, required this.status, required this.data});

  factory QuranDetail.fromJson(Map<String, dynamic> json) {
    return QuranDetail(
      code: json['code'],
      status: json['status'],
      data: QuranData.fromJson(json['data']),
    );
  }
}

class QuranData {
  final CountOnly ayahs;
  final Surahs surahs;
  final Sajdas sajdas;
  final Rukus rukus;
  final Pages pages;
  final GenericReferences manzils;
  final GenericReferences hizbQuarters;
  final GenericReferences juzs;

  QuranData({
    required this.ayahs,
    required this.surahs,
    required this.sajdas,
    required this.rukus,
    required this.pages,
    required this.manzils,
    required this.hizbQuarters,
    required this.juzs,
  });

  factory QuranData.fromJson(Map<String, dynamic> json) {
    return QuranData(
      ayahs: CountOnly.fromJson(json['ayahs']),
      surahs: Surahs.fromJson(json['surahs']),
      sajdas: Sajdas.fromJson(json['sajdas']),
      rukus: Rukus.fromJson(json['rukus']),
      pages: Pages.fromJson(json['pages']),
      manzils: GenericReferences.fromJson(json['manzils']),
      hizbQuarters: GenericReferences.fromJson(json['hizbQuarters']),
      juzs: GenericReferences.fromJson(json['juzs']),
    );
  }
}

class CountOnly {
  final int count;

  CountOnly({required this.count});

  factory CountOnly.fromJson(Map<String, dynamic> json) {
    return CountOnly(count: json['count']);
  }
}

class Surahs {
  final int count;
  final List<SurahReference> references;

  Surahs({required this.count, required this.references});

  factory Surahs.fromJson(Map<String, dynamic> json) {
    return Surahs(
      count: json['count'],
      references: (json['references'] as List)
          .map((e) => SurahReference.fromJson(e))
          .toList(),
    );
  }
}

class SurahReference {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;

  SurahReference({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory SurahReference.fromJson(Map<String, dynamic> json) {
    return SurahReference(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      numberOfAyahs: json['numberOfAyahs'],
      revelationType: json['revelationType'],
    );
  }
}

class Sajdas {
  final int count;
  final List<SajdaReference> references;

  Sajdas({required this.count, required this.references});

  factory Sajdas.fromJson(Map<String, dynamic> json) {
    return Sajdas(
      count: json['count'],
      references: (json['references'] as List)
          .map((e) => SajdaReference.fromJson(e))
          .toList(),
    );
  }
}

class SajdaReference {
  final int surah;
  final int ayah;
  final bool recommended;
  final bool obligatory;

  SajdaReference({
    required this.surah,
    required this.ayah,
    required this.recommended,
    required this.obligatory,
  });

  factory SajdaReference.fromJson(Map<String, dynamic> json) {
    return SajdaReference(
      surah: json['surah'],
      ayah: json['ayah'],
      recommended: json['recommended'],
      obligatory: json['obligatory'],
    );
  }
}

class Rukus {
  final int count;
  final List<BasicReference> references;

  Rukus({required this.count, required this.references});

  factory Rukus.fromJson(Map<String, dynamic> json) {
    return Rukus(
      count: json['count'],
      references: (json['references'] as List)
          .map((e) => BasicReference.fromJson(e))
          .toList(),
    );
  }
}

class Pages {
  final int count;
  final List<BasicReference> references;

  Pages({required this.count, required this.references});

  factory Pages.fromJson(Map<String, dynamic> json) {
    return Pages(
      count: json['count'],
      references: (json['references'] as List)
          .map((e) => BasicReference.fromJson(e))
          .toList(),
    );
  }
}

class GenericReferences {
  final int count;
  final List<BasicReference> references;

  GenericReferences({required this.count, required this.references});

  factory GenericReferences.fromJson(Map<String, dynamic> json) {
    return GenericReferences(
      count: json['count'],
      references: (json['references'] as List)
          .map((e) => BasicReference.fromJson(e))
          .toList(),
    );
  }
}

class BasicReference {
  final int surah;
  final int ayah;

  BasicReference({required this.surah, required this.ayah});

  factory BasicReference.fromJson(Map<String, dynamic> json) {
    return BasicReference(
      surah: json['surah'],
      ayah: json['ayah'],
    );
  }
}
