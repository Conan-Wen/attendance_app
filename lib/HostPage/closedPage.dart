import 'package:flutter/material.dart';

class MeetingClosedPage extends StatelessWidget {
  const MeetingClosedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
	return Scaffold(
	  appBar: AppBar(
		title: Text('会議締切'),
	  ),
	  body: Center(
		child: Text('この会議は締め切りました。'),
	  ),
	);
  }
}