import 'package:flutter/material.dart';
import './main.dart';

class SelectPage extends StatelessWidget {
  final List<String> conferenceNames;
  final Map<String,List<String>> participantMap;
  var index = 1;//Listviewのindex、とりあえず0で初期化
  SelectPage({super.key, required this.conferenceNames, required this.participantMap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("開催者ページ"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HostPage(
                        conferenceName: conferenceNames[index],
                        participants: participantMap[conferenceNames[index]]!,
                      ))),
              child: Container(//ここをlistviewにする
                width: 200,
                height: 50,
                child: Center(
                  child: Text(conferenceNames[index]),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
