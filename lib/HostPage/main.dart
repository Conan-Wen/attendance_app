import 'package:flutter/material.dart';

class HostPage extends StatefulWidget {
  final String conferenceName;
  final List<String> participants;

  const HostPage({super.key, required this.conferenceName, required this.participants});

  @override
  _HostPageState createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  IconData statusIcon = Icons.check_circle;
  Color iconColor = Colors.green;

  void _changeStatusIcon() {
    setState(() {
      if (statusIcon == Icons.highlight_off) {
        statusIcon = Icons.check_circle_outline;
        iconColor = Colors.green;
      } else {
        statusIcon = Icons.highlight_off;
        iconColor = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conferenceName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.participants.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(statusIcon, color: iconColor),
                  title: Text(widget.participants[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _changeStatusIcon,
              child: const Text('締め切り'),
            ),
          ),
        ],
      ),
    );
  }
}
