import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AttendanceResult{
  int id;
  String conferenceName;
  List<String> attendeesName;
  List<String> absenteesName;


  AttendanceResult({required this.id, required this.conferenceName, required this.attendeesName, required this.absenteesName});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'conferenceName': conferenceName,
      'attendeesName': attendeesName.join(','),
      'absenteesName': absenteesName.join(','),
    };
  }

  Map<String, dynamic> toMapExceptId(){
    return {
      'conferenceName': conferenceName,
      'attendeesName': attendeesName.join(','),
      'absenteesName': absenteesName.join(','),
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
          '''CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, conferenceName TEXT, attendeesName TEXT, absenteesName TEXT)''',
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
        attendeesName: maps[i]['attendeesName'].split(','),
        absenteesName: maps[i]['absenteesName'].split(','),
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