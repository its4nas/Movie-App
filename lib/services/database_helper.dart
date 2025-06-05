import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('favorites.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String path;
    if (kIsWeb) {
      throw UnsupportedError('Web platform is not supported');
    } else {
      // For mobile platforms, use the app's documents directory
      final dbPath = await getDatabasesPath();
      path = join(dbPath, filePath);
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY,
        movie_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        poster_path TEXT,
        vote_average REAL,
        overview TEXT,
        added_date TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertFavorite(Map<String, dynamic> movie) async {
    final db = await database;
    return await db.insert('favorites', {
      'movie_id': movie['id'],
      'title': movie['title'],
      'poster_path': movie['poster_path'],
      'vote_average': movie['vote_average'],
      'overview': movie['overview'],
      'added_date': DateTime.now().toIso8601String(),
    });
  }

  Future<int> removeFavorite(int movieId) async {
    final db = await database;
    return await db.delete(
      'favorites',
      where: 'movie_id = ?',
      whereArgs: [movieId],
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return await db.query('favorites', orderBy: 'added_date DESC');
  }

  Future<bool> isFavorite(int movieId) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'movie_id = ?',
      whereArgs: [movieId],
    );
    return result.isNotEmpty;
  }
} 