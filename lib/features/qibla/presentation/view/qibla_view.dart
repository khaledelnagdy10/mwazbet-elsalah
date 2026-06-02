import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

class QiblaView extends StatelessWidget {
  const QiblaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FlutterQiblah.requestPermissions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<QiblahDirection>(
            stream: FlutterQiblah.qiblahStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final qiblaDirection = snapshot.data!;
              final angle = qiblaDirection.qiblah * (pi / 180);

              return Center(
                child: Transform.rotate(
                  angle: angle,
                  child: const Icon(
                    Icons.navigation,
                    size: 140,
                    color: Colors.green,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
