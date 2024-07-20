import 'package:flutter/material.dart';
import 'attendance_result_database.dart';

// <- 出席結果画面 ->
class AttendanceResultScreen extends StatefulWidget {
  final List<String> participants;
  final List<bool> checkList;
  final String conferenceName;

  const AttendanceResultScreen(
      {super.key, required this.participants, required this.checkList ,required this.conferenceName});

  @override
  AttendanceResultScreenState createState() => AttendanceResultScreenState();
}

class AttendanceResultScreenState extends State<AttendanceResultScreen> {
  List<String> attendeesName = [];
  List<String> absenteesName = [];

  Future<void> saveAttendanceResult() async {
    await DatabaseHelperAttendanceResult().insertAttendanceResult(AttendanceResult(
      id: 0,
      conferenceName: widget.conferenceName,
      attendeesName: attendeesName,
      absenteesName: absenteesName,
    ));
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> presentItems = [];
    List<DropdownMenuItem<String>> absentItems = [];

    for (int i = 0; i < widget.participants.length; i++) {
      var item = DropdownMenuItem(
        value: widget.participants[i],
        child: Text(widget.participants[i]),
      );

      if (widget.checkList[i]) {
        presentItems.add(item);
        attendeesName.add(widget.participants[i]);
      } else {
        absentItems.add(item);
        absenteesName.add(widget.participants[i]);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('集計結果'),
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: const Text("出席者"),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: presentItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: presentItems[index],
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Text("不在者"),
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: absentItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: absentItems[index],
                  );
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          if (widget.conferenceName.isNotEmpty || attendeesName.isNotEmpty || absenteesName.isNotEmpty) {
            await saveAttendanceResult();
            Navigator.popUntil(context, (route) => route.isFirst);
            return;
          }
        },
        child: const Icon(Icons.home),
      ),
    );
  }
}