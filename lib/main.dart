import 'package:attendance_app/HostPage/SelectPage.dart';
import 'package:flutter/material.dart';
import 'GuestPage/main.dart';
// import 'HostPage/main.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  runApp(const MyApp());
}

final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.all(40),
  backgroundColor: Colors.white,
  side: const BorderSide(color: Color(0xFFA9A2D1), width: 3),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '出席記録アプリ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA9A2D1)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '出席記録'),
    );
  }
}

enum DeviceType { advertiser, browser }

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          ElevatedButton(
            style: buttonStyle,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SelectPage())),
            child: const Column(
              children: [
                Icon(LucideIcons.calendarPlus, size: 100),
                SizedBox(height: 10),
                Text(
                  'ミーティング開催',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ],
            ), //
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: buttonStyle,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const GuestPage())),

            child: const Column(
              children: [
                Icon(LucideIcons.doorOpen, size: 100),
                SizedBox(height: 10),
                Text(
                  'ミーティング参加',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ],
            ), // Text('参加者ページ'),
          )
        ])));
  }
}
