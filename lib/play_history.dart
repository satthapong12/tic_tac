import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PlayHistoryDatabase {
  Database? _db;

  Future<void> openDatabasee() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'play_history.db');
    _db = await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE play_history(id INTEGER PRIMARY KEY AUTOINCREMENT, winner TEXT, play_date TEXT, play_time TEXT)',
        );
      },
      version: 1,
    );
  }
 

  

  Future<void> insertPlay(String winner, String playDate, String playTime) async {
    await _ensureDbInitialized();
    if (_db != null) {
      await _db!.insert(
        'play_history',
        {'winner': winner, 'play_date': playDate, 'play_time': playTime},
      );
    } else {
      print("Database is not initialized.");
    }
  }
  


  Future<List<Map<String, dynamic>>> getPlayHistory() async {
    await _ensureDbInitialized();
    if (_db != null) {
      final List<Map<String, dynamic>> maps = await _db!.query('play_history', orderBy: 'id DESC');
      return maps;
    } else {
      print("Database is not initialized.");
      return [];
    }
  }

  Future<void> closeDatabase() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    } else {
      print("Database is not initialized.");
    }
  }

  Future<void> _ensureDbInitialized() async {
    if (_db == null) {
      await openDatabasee();
    }
  }
}
