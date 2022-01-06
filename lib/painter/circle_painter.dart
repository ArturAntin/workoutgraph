import 'dart:math' as math;

import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final double percentage;
  final BuildContext context;

  CirclePainter({
    required this.percentage,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final _paint = Paint()
      ..color = Theme.of(context).primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      2.2,
      percentage * math.pi * 2 * .8,
      false,
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
