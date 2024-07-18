import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Meeting {
  String name;
  List<String> participants;

  Meeting({required this.name, required this.participants});

  // Convert a Meeting object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'participants': participants.join(','),
    };
  }

  // Extract a Meeting object from a Map object
  static Meeting fromMap(Map<String, dynamic> map) {
    return Meeting(
      name: map['name'],
      participants: List<String>.from(map['participants'].split(',')),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  //データベースの初期化
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'meeting_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  //データベースとテーブルの作成
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE meetings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        participants TEXT NOT NULL
      )
    ''');
  }

  //会議データの挿入
  Future<void> insertMeeting(Meeting meeting) async {
    final db = await database;
    await db.insert(
      'meetings',
      meeting.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //会議データの削除
  Future<void> deleteMeeting(String name) async {
    final db = await database;
    await db.delete(
      'meetings',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  //会議データの取得
  Future<List<Meeting>> getMeetings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('meetings');
    return List.generate(maps.length, (i) {
      return Meeting.fromMap(maps[i]);
    });
  }
}
