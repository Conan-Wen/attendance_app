import 'package:flutter/material.dart';

// <- 出席結果画面 ->
class AttendanceResultScreen extends StatelessWidget {
  final List<Widget> attendanceWidgets;

  const AttendanceResultScreen({super.key, required this.attendanceWidgets});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Result'),
      ),
      body: ListView(
        children: attendanceWidgets,
      ),
    );
  }
}
