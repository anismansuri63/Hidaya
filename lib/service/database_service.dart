import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
//id, location, surah, ayah, word, text

class DatabaseHelper {
  static Database? _db;

  static const String dbName = 'quran.sqlite';//dbNameSqlite
  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;

    // Get path to store DB
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);

    // Check if db already copied
    if (!await File(path).exists()) {
      // Copy from assets
      ByteData data = await rootBundle.load('assets/database/quran.sqlite');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }

    _db = await openDatabase(path, readOnly: true);
    return _db!;
  }


  static Future<SurahDb?> getSurahById(int id) async {
    final db = await DatabaseHelper.getDatabase();

    final List<Map<String, dynamic>> result =
    await db.query('chapters', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
        return SurahDb.fromJson(result.first);
    }
    return null;
  }

}
class SurahDb {
  final int id;
  final String nameAr;
  final String namePronEn;
  final String revelationClass;
  final int versesNumber;
  final String content;

  SurahDb({
    required this.id,
    required this.nameAr,
    required this.namePronEn,
    required this.revelationClass,
    required this.versesNumber,
    required this.content,
  });

  factory SurahDb.fromJson(Map<String, dynamic> json) {
    return SurahDb(
      id: json['id'],
      nameAr: json['name_ar'],
      namePronEn: json['name_pron_en'],
      revelationClass: json['class'],
      versesNumber: json['verses_number'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_pron_en': namePronEn,
      'class': revelationClass,
      'verses_number': versesNumber,
      'content': content,
    };
  }
}
