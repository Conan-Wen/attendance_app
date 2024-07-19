import 'package:flutter/material.dart';
import './main.dart';
import 'Database.dart';
import 'AddMeetingScreen.dart';
import 'attendance_result_database.dart';
import 'attendance_result.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  _SelectPage createState() => _SelectPage();
}

class _SelectPage extends State<SelectPage> {
  late Future<List<Meeting>> meetings;
  Future<List<AttendanceResult>>? attendanceResultsFuture;

  @override
  void initState() {
    super.initState();
    meetings = DatabaseHelper().getMeetings();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      meetings = DatabaseHelper().getMeetings();
    });
  }

  void _navigateToAddMeeting() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMeetingScreen()),
    );
    setState(() {
      meetings = DatabaseHelper().getMeetings();
    });
  }
   void _loadAttendanceResults() {
    setState(() {
      attendanceResultsFuture = DatabaseHelperAttendanceResult().getAttendanceResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('開催者ページ'),
      ),
      body: Column(
        children: [
          Expanded(child:FutureBuilder<List<Meeting>>(
        future: meetings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('登録した会議はありません'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final meeting = snapshot.data![index];
                return ListTile(
                    title: Text(meeting.meetingName),
                    subtitle: Text('参加者: ${meeting.participants.join(', ')}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await DatabaseHelper().deleteMeeting(meeting.id);
                        setState(() {
                          meetings = DatabaseHelper().getMeetings();
                        });
                      },
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HostPage(
                                  conferenceName: meeting.meetingName,
                                  participants: meeting.participants,
                                ))));
              },
            );
          }
        },
      ),
      ),
      Expanded(
        child: FutureBuilder<List<AttendanceResult>>(
        future: attendanceResultsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('出席記録はありません'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final attendanceResult = snapshot.data![index];
                return ListTile(
                    title: Text(attendanceResult.conferenceName),
                    subtitle: Text('参加者: ${attendanceResult.participantsName.join(', ')}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await DatabaseHelperAttendanceResult().deleteAttendanceResult(attendanceResult.id);
                        _loadAttendanceResults(); // ここでリロード
                      },
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AttendanceResultScreen(
                                  conferenceName: attendanceResult.conferenceName,
                                  participants: attendanceResult.participantsName,
                                  checkList: attendanceResult.checkList,
                                ))));
              },
            );
          }
        },
        )
      )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddMeeting,
        child: Icon(Icons.add),
      ),
    );
  }
}
