import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/note.dart';

class DatabaseService {
  // Singleton instance
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('secure_notes.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, fileName);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        orderIndex INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE notes ADD COLUMN orderIndex INTEGER NOT NULL DEFAULT 0');
    }
  }

  // --- CRUD METHODS ---

  Future<List<Note>> getAllNotes() async {
    final db = await instance.database;
    final result = await db.query('notes', orderBy: 'orderIndex ASC, id DESC');
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<int> addNote(Note note) async {
    final db = await instance.database;
    
    final countResult = await db.rawQuery('SELECT COUNT(*) FROM notes');
    final count = Sqflite.firstIntValue(countResult) ?? 0;
    
    final updatedNote = note.copyWith(orderIndex: count);
    return await db.insert('notes', updatedNote.toMap());
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> updateAllNotes(List<Note> notes) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      for (int i = 0; i < notes.length; i++) {
        await txn.update(
          'notes',
          {'orderIndex': i},
          where: 'id = ?',
          whereArgs: [notes[i].id],
        );
      }
    });
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllNotes() async {
    final db = await instance.database;
    await db.delete('notes');
  }
}