import 'package:flutter/material.dart';

class MyChildrenView extends StatelessWidget {
  const MyChildrenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Children')),
      body: const Center(child: Text('Children will appear here')),
    );
  }
}
