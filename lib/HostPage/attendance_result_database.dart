import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AttendanceResult{
  int id;
  String conferenceName;
  List<String> participantsName;
  List<String> absenteesName;

  AttendanceResult({required this.id, required this.conferenceName,required this.participantsName,required this.absenteesName});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'conferenceName': conferenceName,
      'participantsName': participantsName,
      'absenteesName': absenteesName,
    };
  }

  Map<String, dynamic> toMapExceptId(){
    return {
      'conferenceName': conferenceName,
      'participantsName': participantsName,
      'absenteesName': absenteesName,
    };
  }
}

class DatabaseHelperAttendanceResult{
  static Database? _database;
  static const String tableName = 'attendance_result';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'attendance_result_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, conferenceName TEXT, participantsName TEXT, absenteesName TEXT)",
        );
      },
      version: 1,
    );
  }
  Future<void> insertAttendanceResult(AttendanceResult attendanceResult) async {
    final Database db = await database;
    await db.insert(
      tableName,
      attendanceResult.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AttendanceResult>> getAttendanceResults() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return AttendanceResult(
        id: maps[i]['id'],
        conferenceName: maps[i]['conferenceName'],
        participantsName: maps[i]['participantsName'],
        absenteesName: maps[i]['absenteesName'],
      );
    });
  }

  Future<void> deleteAttendanceResult(int id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}