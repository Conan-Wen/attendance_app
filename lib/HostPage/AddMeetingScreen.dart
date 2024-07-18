import 'package:flutter/material.dart';
import './Database.dart';
import './main.dart';
import './SelectPage.dart';

class AddMeetingScreen extends StatefulWidget {
  @override
  _AddMeetingScreenState createState() => _AddMeetingScreenState();
}

class _AddMeetingScreenState extends State<AddMeetingScreen> {
  final _nameController = TextEditingController();
  final List<TextEditingController> _participantControllers = [];

  void _addParticipantField() {
    setState(() {
      _participantControllers.add(TextEditingController());
    });
  }

  void _removeParticipantField(int index) {
    setState(() {
      _participantControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('会議追加ページ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '会議名'),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  '参加者の名前',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addParticipantField,
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _participantControllers.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _participantControllers[index],
                          decoration:
                              InputDecoration(labelText: '参加者 ${index + 1}'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => _removeParticipantField(index),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    final name = _nameController.text;
                    final participants = _participantControllers
                        .map((controller) => controller.text)
                        .where((text) => text.isNotEmpty)
                        .toList();
                    if (name.isNotEmpty && participants.isNotEmpty) {
                      await DatabaseHelper().insertMeeting(
                          Meeting(name: name, participants: participants));
                      Navigator.of(context).pop(true); // trueを渡して追加が成功したことを示す
                    }
                  },
                  child: Text('会議の追加'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    final name = _nameController.text;
                    final participants = _participantControllers
                        .map((controller) => controller.text)
                        .where((text) => text.isNotEmpty)
                        .toList();
                    if (name.isNotEmpty && participants.isNotEmpty) {
                      await DatabaseHelper().insertMeeting(
                          Meeting(name: name, participants: participants));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HostPage(
                                    conferenceName: name,
                                    participants: participants,
                                  )));
                    }
                  },
                  child: Text('会議の開始'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (var controller in _participantControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
