import 'package:attendance_app/HostPage/SelectPage.dart';
import 'package:flutter/material.dart';
import 'GuestPage/main.dart';
// import 'HostPage/main.dart';
import 'package:lucide_icons/lucide_icons.dart';

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

class SquareButton extends StatelessWidget {
  const SquareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxSize = constraints.biggest.shortestSide * 0.7;
        double size = maxSize > 300 ? 300 : maxSize;

        return SizedBox(
          width: size,
          height: size,
          child: ElevatedButton(
            onPressed: () {
              // 버튼 클릭 시 동작
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Button'),
          ),
        );
      },
    );
  }
}

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
                        builder: (context) => const SelectPage())),
                child: const Text('開催者ページ'),
              ),
              const SquareButton(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                      color: Colors.deepPurpleAccent, width: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const GuestPage())),

                child: const Column(
                  children: [
                    Icon(LucideIcons.qrCode, size: 100),
                    Text(
                      '参加者ページ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple),
                    ),
                  ],
                ), // Text('参加者ページ'),
              )
            ])));
  }
}
