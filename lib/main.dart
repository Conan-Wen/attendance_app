import 'package:flutter/material.dart';

import 'GuestPage/main.dart';
import 'HostPage/main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '出席記録アプリ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HostPage(
                      conferenceName: '会議名',
                      participants: ['人名1', '人名2', '人名3','人名4', '人名5', '人名6','人名7', '人名8', '人名9','人名10', '人名11', '人名12','人名13', '人名14', '人名15','人名16', '人名17', '人名18','人名19', '人名20'],
                      )
                    )
                  ),
              child: const Text('開催者ページ'),
            ),
            ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const GuestPage())),
                child: const Text('参加者ページ'))
          ],
        ),
      ),
    );
  }
}
