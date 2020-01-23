import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:my_notekeeper/models/notes.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();

    String path = directory.path + 'notes.db';

    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    String query =
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT ,$colTitle TEXT, $colDescription TEXT $colPriority INTEGER $colDate TEXT';

    await db.execute(query);
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result =
        await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');

    return result;
  }

  Future<int> insertNote (Note note) async{
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap(),);
    return result;
  }

  Future<int> updateNote (Note note) async{
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(), where:  '$colId = ?',whereArgs: [note.id] );
    return result;
  }

  Future<int> deleteNote (int id) async{
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId =$id');
    return result;
  }

  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNoteList() async {

    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = List<Note> ();

    for(int i =0 ; i< count; i++){
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }

}
