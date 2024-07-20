import 'package:flutter/material.dart';
import './main.dart';
import 'Database.dart';
import 'AddMeetingScreen.dart';
import 'ClosedPage.dart';
import 'attendance_result_database.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  SelectPageState createState() => SelectPageState();
}

class SelectPageState extends State<SelectPage> {
  late Future<List<Meeting>> meetings;
  Future<List<AttendanceResult>>? attendanceResults;
  List<bool> checkListBool = [];

  @override
  void initState() {
    super.initState();
    meetings = DatabaseHelper().getMeetings();
    attendanceResults = DatabaseHelperAttendanceResult().getAttendanceResults();
  }

  void _navigateToAddMeeting() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddMeetingScreen()),
    );
    setState(() {
      meetings = DatabaseHelper().getMeetings();
    });
  }

  void _loadAttendanceResults() {
    setState(() {
      attendanceResults =
          DatabaseHelperAttendanceResult().getAttendanceResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登録会議一覧'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Meeting>>(
              future: meetings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('登録した会議はありません'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final meeting = snapshot.data![index];
                      return ListTile(
                        title: Text(meeting.meetingName),
                        subtitle:
                            Text('参加者: ${meeting.participants.join(', ')}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await DatabaseHelper().deleteMeeting(meeting.id);
                            setState(() {
                              meetings = DatabaseHelper().getMeetings();
                            });
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HostPage(
                                id: meeting.id,
                                conferenceName: meeting.meetingName,
                                participants: meeting.participants,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
          //     Expanded(
          //     child: FutureBuilder<List<AttendanceResult>>(
          //     future: attendanceResults,
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(child: CircularProgressIndicator());
          //       } else if (snapshot.hasError) {
          //           return Center(child: Text('Error: ${snapshot.error}'));
          //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          //           return const Center(child: Text('出席記録はありません'));
          //       } else {
          //           return ListView.builder(
          //             itemCount: snapshot.data!.length,
          //             itemBuilder: (context, index) {
          //               final attendanceResult = snapshot.data![index];
          //               return ListTile(
          //                 title: Text(attendanceResult.conferenceName),
          //                 subtitle: Text('参加者: ${attendanceResult.participantsName.join(', ')}'),
          //                 trailing: IconButton(
          //                   icon: const Icon(Icons.delete),
          //                   onPressed: () async {
          //                     await DatabaseHelperAttendanceResult().deleteAttendanceResult(attendanceResult.id);
          //                     _loadAttendanceResults();
          //                   },
          //                 ),
          //                 onTap: () => Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                     builder: (context) => AttendanceResultScreen(
          //                       conferenceName: attendanceResult.conferenceName,
          //                       participants: attendanceResult.participantsName,
          //                       checkList: attendanceResult.checkList.map((i) => i != 0).toList(),
          //                     )
          //                   )
          //                 )
          //               );
          //             },
          //           );
          //         }
          //       }
          //     )
          //   )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          child: FloatingActionButton(
        onPressed: _navigateToAddMeeting,
        child: const Text("新しい会議"),
      )),
    );
  }
}
