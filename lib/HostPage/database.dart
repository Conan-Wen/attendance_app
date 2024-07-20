import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Meeting {
  int id;
  String meetingName;
  List<String> participants;

  Meeting(
      {required this.id,
      required this.meetingName,
      required this.participants});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'meetingName': meetingName,
      'participants': participants.join(','), // 参加者を文字列に変換
    };
  }

  Map<String, dynamic> toMapExceptId() {
    return {'meetingName': meetingName, 'participants': participants.join(',')};
  }

  factory Meeting.fromMap(Map<String, dynamic> map) {
    return Meeting(
      id: map['id'],
      meetingName: map['meetingName'],
      participants: map['participants'].split(','), // 文字列をリストに変換
    );
  }
}

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'meetings';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'meetings_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  void _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        meetingName TEXT,
        participants TEXT
      )
    ''');
  }

  Future<void> insertMeeting(Meeting meeting) async {
    final Database db = await database;
    await db.insert(tableName, meeting.toMapExceptId(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Meeting>> getMeetings() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Meeting.fromMap(maps[i]);
    });
  }

  Future<void> deleteMeeting(int id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateMeeting(Meeting meeting) async {
    try {
      final db = await database;
      int result = await db.update(tableName, meeting.toMap(),
          where: 'id = ?', whereArgs: [meeting.id]);
      if (result == 0) {
        print("更新に失敗しました。ID: ${meeting.id} のミーティングは見つかりません。");
      }
    } catch (e) {
      print("updateMeetingでエラーが発生しました: $e");
    }
  }
}
