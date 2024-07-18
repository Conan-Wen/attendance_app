import 'package:flutter/material.dart';
import 'attendance_result_database.dart';

// <- 出席結果画面 ->
class AttendanceResultScreen extends StatelessWidget {
  final List<String> participants;
  final List<bool> checkList;
  final String conferenceName;

  const AttendanceResultScreen(
      {super.key, required this.participants, required this.checkList ,required this.conferenceName});

  @override
  Widget build(BuildContext context) {
    List<String> participantsName = [];
    List<String> absenteesName = [];
    String conferenceName = this.conferenceName;
    List<DropdownMenuItem<String>> presentItems = [];
    List<DropdownMenuItem<String>> absentItems = [];

    for (int i = 0; i < participants.length; i++) {
      var item = DropdownMenuItem(
        value: participants[i],
        child: Text(participants[i]),
      );

      if (checkList[i]) {
        presentItems.add(item);
        participantsName.add(participants[i]);
      } else {
        absentItems.add(item);
        absenteesName.add(participants[i]);
      }
    }
    // databaseに出席者と不在者を登録
    DatabaseHelperAttendanceResult().insertAttendanceResult(AttendanceResult(
        id: 0,
        conferenceName: conferenceName,
        participantsName: participantsName,
        absenteesName: absenteesName));

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
      onPressed: () {
        Navigator.popUntil(context, (route) => route.isFirst);
      },
      child: const Icon(Icons.home),
    ),
  );
  }
}