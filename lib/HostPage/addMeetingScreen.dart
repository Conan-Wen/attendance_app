import 'package:flutter/material.dart';
import './Database.dart';
import './main.dart';
// import './SelectPage.dart';

class AddMeetingScreen extends StatefulWidget {
  const AddMeetingScreen({super.key});

  @override
  AddMeetingScreenState createState() => AddMeetingScreenState();
}

class AddMeetingScreenState extends State<AddMeetingScreen> {
  final _nameController = TextEditingController();
  final List<TextEditingController> _participantControllers = [];

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('登録確認'),
          content: Text('この会議を登録しますか?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('いいえ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('はい'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  void _showAlertDialog(BuildContext content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('警告'),
          content: Text('入力内容に不備があります'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"))
          ],
        );
      },
    );
  }

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
        title: const Text('会議追加ページ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '会議名'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  '参加者の名前',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
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
                        icon: const Icon(Icons.remove),
                        onPressed: () => _removeParticipantField(index),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
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
                  await DatabaseHelper().insertMeeting(Meeting(
                      id: 0, meetingName: name, participants: participants, closed: 0));
                  Navigator.of(context).pop(true); // trueを渡して追加が成功したことを示す
                } else {
                  _showAlertDialog(context);
                }
              },
              child: const Text('会議の追加'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text;
                final participants = _participantControllers
                    .map((controller) => controller.text)
                    .where((text) => text.isNotEmpty)
                    .toList();
                if (name.isNotEmpty && participants.isNotEmpty) {
                  bool result = await _showConfirmationDialog(context);
                  if (result) {
                    await DatabaseHelper().insertMeeting(Meeting(
                        id: 0, meetingName: name, participants: participants, closed: 0));
                  }
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HostPage(
                                id: 0,
                                conferenceName: name,
                                participants: participants,
                              )));
                } else {
                  _showAlertDialog(context);
                }
              },
              child: const Text('会議の開始'),
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
