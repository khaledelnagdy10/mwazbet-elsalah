import 'package:flutter/material.dart';

class MyParentsView extends StatelessWidget {
  const MyParentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Parents')),
      body: const Center(child: Text('Parents will appear here')),
    );
  }
}
