import 'package:flutter/material.dart';
import 'package:workoutgraph/painter/line_painter.dart';

class LineGraph extends StatelessWidget {
  final List<int> data;
  final int x;
  final int y;
  final List<String> labelY;
  final Color graphColor;
  final Color infosColor;
  final double graphOpacity;
  final double height;
  final double width;

  const LineGraph({
    Key? key,
    required this.data,
    required this.x,
    required this.y,
    this.labelY = const [],
    this.graphColor = Colors.blue,
    this.infosColor = Colors.grey,
    this.graphOpacity = 0.0,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CustomPaint(
        size: Size(width, height),
        painter: LineGraphPainter(
          data: data,
          labelY: labelY,
          graphColor: graphColor,
          graphOpacity: graphOpacity,
          infosColor: infosColor,
          x: x,
          y: y,
        ),
      ),
    );
  }
}
