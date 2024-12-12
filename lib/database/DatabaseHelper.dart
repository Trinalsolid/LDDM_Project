import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  String temp = "";
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final path = join(".\\lib\\database\\", filePath);
    temp = path;
    return await openDatabase(
      path,
      version: 10,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        senha TEXT NOT NULL
      );
    ''');
  }

  Future<bool> loginUser(String email, String password) async {
    final db = await database;
    final results = await db.query(
      'user',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, password],
    );
    return results.isNotEmpty;
  }

  Future<bool> userExists(String email) async {
    final db = await database;
    final results = await db.query(
      'user',
      where: 'email = ?',
      whereArgs: [email],
    );
    return results.isNotEmpty;
  }

  // Registration methods
  Future<int> registerUser(
      String username, String email, String password) async {
    print(temp);
    final db = await database;
    final conflict = await db.rawInsert(
      'INSERT INTO user (nome, email, senha) VALUES (?, ?, ?)',
      [username, email, password],
    );
    if (conflict == -1) {
      throw Exception('Username or email already exists');
    }
    return conflict;
  }

  Future<Map<String, dynamic>> getUser(String email) async {
    final db = await database;
    final results = await db.query(
      'user',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {}; // Return empty map if user not found
    }
  }
}
