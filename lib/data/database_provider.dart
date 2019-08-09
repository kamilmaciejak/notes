import 'package:notes/data/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseProvider {
  static final _databaseName = 'notes_database.db';
  static final _noteTableName = 'note';
  static final DatabaseProvider _this = DatabaseProvider._();

  Database _database;

  DatabaseProvider._();

  factory DatabaseProvider() => _this;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      p.join(await getDatabasesPath(), _databaseName),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $_noteTableName("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "text TEXT,"
          "creationDate INTEGER"
          ")",
        );
      },
    );
  }

  Future<List<Note>> getNotes() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_noteTableName);
    return maps.map((map) => Note.fromJson(map)).toList();
  }

  Future<List<Note>> getNotesWithText(String text) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      "SELECT * FROM $_noteTableName WHERE title = ? or text = ?",
      [text, text],
    );
    return maps.map((map) => Note.fromJson(map)).toList();
  }

  Future<Note> getNote(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _noteTableName,
      where: "id = ?",
      whereArgs: [id],
    );
    return Note.fromJson(maps.first);
  }

  Future<int> insertNote(Note note) async {
    final Database db = await database;
    return await db.insert(
      _noteTableName,
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteNote(int id) async {
    final Database db = await database;
    return await db.delete(
      _noteTableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
//  https://medium.com/flutter-community/using-sqlite-in-flutter-187c1a82e8b
//  https://flutter.dev/docs/cookbook/persistence/sqlite
//  https://applandeo.com/blog/sqflite-flutter-database/
