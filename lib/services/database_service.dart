import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/note.dart';

// DatabaseService to handle storage
class DatabaseService {
  // Singleton instance
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('secure_notes.db');
    return _database!;
  }

  // Initialize the database in the app's documents directory
  Future<Database> _initDB(String fileName) async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, fileName);

    return await openDatabase(
      path,
      version: 2, // Incremented version to 2 for migration
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // Define the table structure
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

  // Migration logic for upgrading the database
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE notes ADD COLUMN orderIndex INTEGER NOT NULL DEFAULT 0');
    }
  }

  // --- CRUD METHODS ---

  // 1. Retrieve all notes sorted by orderIndex
  Future<List<Note>> getAllNotes() async {
    final db = await instance.database;
    final result = await db.query('notes', orderBy: 'orderIndex ASC, id DESC');
    return result.map((json) => Note.fromMap(json)).toList();
  }

  // 2. Insert a new note
  Future<int> addNote(Note note) async {
    final db = await instance.database;
    // Set orderIndex to the count of notes to place it at the end
    final countResult = await db.rawQuery('SELECT COUNT(*) FROM notes');
    final count = Sqflite.firstIntValue(countResult) ?? 0;
    
    final updatedNote = note.copyWith(orderIndex: count);
    return await db.insert('notes', updatedNote.toMap());
  }

  // 3. Update an existing note
  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // 4. Batch update note order
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

  // 5. Delete a specific note
  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 6. Clear all notes
  Future<void> deleteAllNotes() async {
    final db = await instance.database;
    await db.delete('notes');
  }
}