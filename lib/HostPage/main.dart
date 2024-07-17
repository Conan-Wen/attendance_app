import 'package:flutter/material.dart';

class HostPage extends StatelessWidget {
  const HostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('開催者ページ'),
      ),
      body: const Center(
        child: Text('開催者ページ'),
      ),
    );
  }
}
