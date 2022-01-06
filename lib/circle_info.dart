import 'package:flutter/material.dart';
import 'package:workoutgraph/painter/circle_painter.dart';

class CircleInfo extends StatelessWidget {
  const CircleInfo({
    Key? key,
    required this.text,
    required this.number,
    required this.maxNumber,
    required this.icon,
  }) : super(key: key);

  final String text;
  final int number;
  final int maxNumber;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomPaint(
        painter: CirclePainter(
          percentage: number / maxNumber,
          context: context,
        ),
        child: SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 5,
                right: 5,
                child: Column(
                  children: [
                    Text(
                      number.toString(),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Text(
                      text,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
              ),
              Positioned(
                child: Icon(icon),
                bottom: 0,
                left: 5,
                right: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
