import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;
//id, location, surah, ayah, word, text
  static const String dbName = 'quran.db';

  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;

    // Get path to store DB
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);

    // Check if db already copied
    if (!await File(path).exists()) {
      // Copy from assets
      ByteData data = await rootBundle.load('assets/database/quran.db');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }

    _db = await openDatabase(path, readOnly: true);
    return _db!;
  }
  static Future<List<Map<String, dynamic>>> getAllSurahs() async {
    final db = await DatabaseHelper.getDatabase();
    final List<Map<String, dynamic>> result = await db.query('surahs'); // table name
    return result;
  }

  static Future<Map<String, dynamic>?> getSurahById(int id) async {
    final db = await DatabaseHelper.getDatabase();
    final List<Map<String, dynamic>> result =
    await db.query('surahs', where: 'id = ?', whereArgs: [id]);

    return result.isNotEmpty ? result.first : null;
  }

}
