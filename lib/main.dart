import 'package:flutter/material.dart';
import 'GuestPage/main.dart';
// import 'HostPage/main.dart';
import 'HostPage/SelectPage.dart';

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
                      builder: (context) => SelectPage(
                            conferenceNames: [
                              '会議1',
                              '会議2',
                              '会議3',
                            ],
                            participantMap: {
                              '会議1': [
                                '参加者1',
                                '参加者2',
                                '参加者3',
                              ],
                              '会議2': [
                                '参加者4',
                                '参加者5',
                                '参加者6',
                              ],
                              '会議3': [
                                '参加者7',
                                '参加者8',
                                '参加者9',
                              ],
                            }
                          ))),
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
