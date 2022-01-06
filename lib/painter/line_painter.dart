import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class LineGraphPainter extends CustomPainter {
  final List<int> data;
  final List<String> labelY;
  final Color graphColor;
  final Color infosColor;
  final int x;
  final int y;
  final double? average;
  final Color avergageColor;
  final int lines;

  LineGraphPainter({
    required this.data,
    required this.labelY,
    required this.graphColor,
    required this.infosColor,
    required this.x,
    required this.y,
    this.average,
    this.avergageColor = Colors.red,
    this.lines = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double _offsetX = 1;
    for (int i = 0; i < labelY.length; i++) {
      if (labelY[i].length > _offsetX) {
        _offsetX = labelY[i].length.toDouble();
      }
    }

    _offsetX *= 7;
    _offsetX += 2 * size.width / 20;
    Size margin = Size(_offsetX, size.height / 8);
    Size graph = Size(
      size.width - 2 * margin.width,
      size.height - 2 * margin.height,
    );
    Size cell = Size(
      graph.width / (x - 10),
      graph.height / y,
    );

    drawAxis(canvas, graph, margin);
    drawLabelsY(canvas, size, margin, graph, cell);
    drawVerticalLine(canvas, graph, margin, cell);
    if (average != null && data.length > 5) {
      drawAverageLine(canvas, graph, margin, cell, average!);
    }

    for (int i = 0; i < data.length; i++) {
      drawGraph(canvas, graph, cell, margin);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawAxis(Canvas canvas, Size graph, Size margin) {
    double spaceBetween = graph.height / lines;
    Paint linePaint = Paint()
      ..color = infosColor
      ..strokeWidth = 1;

    //X-Axis and horizontal lines
    for (int i = 0; i <= lines; i++) {
      canvas.drawLine(
        Offset(
          margin.width,
          graph.height + margin.height - spaceBetween * i,
        ),
        Offset(
          graph.width + 2 * margin.width,
          graph.height + margin.height - spaceBetween * i,
        ),
        linePaint,
      );
    }
  }

  void drawAverageLine(
      Canvas canvas, Size graph, Size margin, Size cell, double average) {
    Paint linePaint = Paint()
      ..color = avergageColor
      ..strokeWidth = 1;
    double normedAvg = average / y;

    canvas.drawLine(
      Offset(
        margin.width,
        graph.height + margin.height - normedAvg * graph.height,
      ),
      Offset(
        margin.width - cell.width + cell.width * data.length,
        graph.height + margin.height - normedAvg * graph.height,
      ),
      linePaint,
    );
  }

  void drawVerticalLine(Canvas canvas, Size graph, Size margin, Size cell) {
    Paint linePaint = Paint()
      ..color = graphColor
      ..strokeWidth = 2;

    final startOffset = Offset(
      margin.width - cell.width + cell.width * data.length,
      margin.height,
    );

    final endOffset = Offset(
      margin.width - cell.width + cell.width * data.length,
      graph.height + margin.height,
    );

    final marginOffset = Offset(margin.width, margin.height);

    canvas.drawLine(
      startOffset,
      endOffset,
      linePaint,
    );

    Paint fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        startOffset,
        marginOffset,
        [
          graphColor.withOpacity(.3),
          graphColor.withOpacity(.1),
        ],
      );

    Rect rect = Rect.fromPoints(
      endOffset,
      marginOffset,
    );

    canvas.drawRect(rect, fillPaint);
  }

  void drawLabelsY(
      Canvas canvas, Size size, Size margin, Size graph, Size cell) {
    for (int i = 0; i < labelY.length; i++) {
      TextSpan span = TextSpan(
        style: TextStyle(
          color: infosColor,
        ),
        text: labelY[i],
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(
        canvas,
        Offset(
          x / 5,
          graph.height + margin.height - graph.height / lines * i - 9,
        ),
      );
    }
  }

  void drawGraph(Canvas canvas, Size graph, Size cell, Size margin) {
    Paint strokePaint = Paint()
      ..color = graphColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    List<double> normedData = data.map((e) => e / y).toList();

    Path linePath = Path();
    linePath.moveTo(
      margin.width,
      margin.height + graph.height - normedData[0] * graph.height,
    );
    int i = 0;
    for (i = 1; i < x && i < normedData.length; i++) {
      if (normedData[i] > 1) {
        normedData[i] = 1;
      }
      if (normedData[i] < 0) {
        normedData[i] = 0;
      }

      linePath.lineTo(
        margin.width + i * cell.width,
        margin.height + graph.height - normedData[i - 1] * graph.height,
      );
      linePath.lineTo(
        margin.width + i * cell.width,
        margin.height + graph.height - normedData[i] * graph.height,
      );
    }
    canvas.drawPath(linePath, strokePaint);
  }
}
