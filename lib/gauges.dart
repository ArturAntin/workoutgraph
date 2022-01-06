import 'dart:math';

import 'package:flutter/material.dart';
import 'package:workoutgraph/circle_info.dart';

class Gauges extends StatelessWidget {
  final _random = Random();

  Gauges({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 12,
      children: [
        CircleInfo(
          text: "km/h",
          number: _random.nextInt(10) + 15,
          maxNumber: 30,
          icon: Icons.speed,
        ),
        CircleInfo(
          text: "rpm",
          number: _random.nextInt(30) + 150,
          maxNumber: 200,
          icon: Icons.repeat,
        ),
        CircleInfo(
          text: "watt",
          number: _random.nextInt(30) + 140,
          maxNumber: 180,
          icon: Icons.bolt,
        ),
        CircleInfo(
          text: "bpm",
          number: _random.nextInt(50) + 100,
          maxNumber: 160,
          icon: Icons.favorite,
        ),
      ],
    );
  }
}
