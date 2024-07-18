import 'package:flutter/material.dart';
import './main.dart';
import 'Database.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  _SelectPage createState() => _SelectPage();
}

class _SelectPage extends State<SelectPage> {
  late Future<List<Meeting>> meetings;

  @override
  void initState() {
    super.initState();
    meetings = DatabaseHelper().getMeetings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('開催者ページ'),
      ),
      body: FutureBuilder<List<Meeting>>(
        future: meetings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No meetings found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final meeting = snapshot.data![index];
                return ListTile(
                  title: Text(meeting.name),
                  subtitle:
                      Text('Participants: ${meeting.participants.join(', ')}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await DatabaseHelper().deleteMeeting(meeting.name);
                      setState(() {
                        meetings = DatabaseHelper().getMeetings();
                      });
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // ダイアログなどで新しい会議を追加するコードをここに記述
          await DatabaseHelper().insertMeeting(
              Meeting(name: 'New Meeting', participants: ['New Participant']));
          setState(() {
            meetings = DatabaseHelper().getMeetings();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
