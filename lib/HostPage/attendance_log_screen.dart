import 'package:flutter/material.dart';

// <- 出席結果画面 ->
class AttendanceLogScreen extends StatefulWidget {
  final String conferenceName;
  final List<String> attendeesName;
  final List<String> absenteesName;

  const AttendanceLogScreen(
      {super.key, required this.conferenceName, required this.attendeesName ,required this.absenteesName});

  @override
  AttendanceLogScreenState createState() => AttendanceLogScreenState();
}

class AttendanceLogScreenState extends State<AttendanceLogScreen> {
  List<String> attendeesName = [];
  List<String> absenteesName = [];

  @override
  Widget build(BuildContext context) {
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
                itemCount: widget.attendeesName.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.attendeesName[index]),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Text("欠席者"),
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.absenteesName.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.absenteesName[index]),
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