import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AttendanceResult{
  int id;
  String conferenceName;
  List<String> participantsName;
  List<bool> checkList;


  AttendanceResult({required this.id, required this.conferenceName,required this.participantsName,required this.checkList});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'conferenceName': conferenceName,
      'participantsName': participantsName,
      'checkList': checkList,
    };
  }

  Map<String, dynamic> toMapExceptId(){
    return {
      'conferenceName': conferenceName,
      'participantsName': participantsName,
      'checkList': checkList,
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
          "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, conferenceName TEXT, participantsName TEXT, checkList INTEGER)",
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
      if (oldVersion < 2) {
        // checkList カラムを追加するSQL文を実行
        await db.execute("ALTER TABLE $tableName ADD COLUMN checkList INTEGER");
      }
    },
      version: 2,
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
        checkList: maps[i]['checkList'],
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