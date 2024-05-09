import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:csv/csv.dart';


class DatabaseHelper {
  static Database? _database;
  static const _tableName = 'babydetails';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'babyname.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, name TEXT, meaning TEXT, nationality TEXT, gender TEXT, selected_nation TEXT, liked_name INTEGER, rejected_name INTEGER)');
  }

  Future<int> insertData(Map<String, dynamic> data) async {
    Database db = await database;
    return await db.insert(_tableName, data);
  }

  Future<List<Map<String, dynamic>>> getDataByGender(String gender) async {
    Database db = await database;
    return await db.query(_tableName, where: 'gender = ?', whereArgs: [gender]);
  }

  Future<List<Map<String, dynamic>>> getDataByLikedName(String liked_name) async {
    Database db = await database;
    return await db.query(_tableName, where: 'liked_name = ?', whereArgs: [liked_name]);
  }
  Future<List<Map<String, dynamic>>> getDataByRejectedName(String rejected_name) async {
    Database db = await database;
    return await db.query(_tableName, where: 'rejected_name = ?', whereArgs: [rejected_name]);
  }

  Future<void> importCsvData(String filePath) async {
    String data = await rootBundle.loadString('assets/babynames.csv');
    List<List<dynamic>> csvData = CsvToListConverter().convert(data);

    for (var row in csvData) {
      await insertData({
        'name': row[0],
        'meaning': row[1],
        'nationality': row[2],
        'gender': row[3],
        'selected_nation': '',
        'liked_name': 0,
        'rejected_name': 0, // Adding the rejected_name field with default value 0
      });
    }
  }

  Future<List<Map<String, dynamic>>> getData() async {
    Database db = await database;
    return await db.query(_tableName);
  }

  Future<void> updateLikedName(int id, int liked) async {
    Database db = await database;
    await db.rawUpdate('UPDATE $_tableName SET liked_name = ? WHERE id = ?', [liked, id]);
  }

  Future<void> updateRejectedName(int id, int rejected) async {
    Database db = await database;
    await db.rawUpdate('UPDATE $_tableName SET rejected_name = ? WHERE id = ?', [rejected, id]);
  }
}

