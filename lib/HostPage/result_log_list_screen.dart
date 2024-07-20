import 'package:flutter/material.dart';
import 'Database.dart';
import 'attendance_result_database.dart';
import 'attendance_log_screen.dart';

class ResultLogListPage extends StatefulWidget {
  const ResultLogListPage({super.key});

  @override
  ResultLogListState createState() => ResultLogListState();
}

class ResultLogListState extends State<ResultLogListPage> {
  late Future<List<Meeting>> meetings;
  Future<List<AttendanceResult>>? attendanceResults;
  List<bool> checkListBool=[];

  @override
  void initState() {
    super.initState();
    attendanceResults = DatabaseHelperAttendanceResult().getAttendanceResults();
  }

  void _loadAttendanceResults() {
    setState(() {
      attendanceResults = DatabaseHelperAttendanceResult().getAttendanceResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('会議履歴'),
      ),
      body: FutureBuilder<List<AttendanceResult>>(
            future: attendanceResults,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('出席記録はありません'));
              } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final attendanceResult = snapshot.data![index];
                      return ListTile(
                        title: Text(attendanceResult.conferenceName),
                        // subtitle: Text('参加者: ${attendanceResult.participantsName.join(', ')}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await DatabaseHelperAttendanceResult().deleteAttendanceResult(attendanceResult.id);
                            _loadAttendanceResults();
                          },
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttendanceLogScreen(
                              conferenceName: attendanceResult.conferenceName,
                              attendeesName: attendanceResult.attendeesName,
                              absenteesName: attendanceResult.absenteesName,
                            )
                          )
                        )
                      );
                    },
                  );
                }
              }
            )
          );
        }
      }