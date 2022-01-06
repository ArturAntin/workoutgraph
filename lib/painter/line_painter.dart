import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class LineGraphPainter extends CustomPainter {
  final List<int> data;
  final List<String> labelY;
  final Color graphColor;
  final double graphOpacity;
  final Color infosColor;
  final int x;
  final int y;

  LineGraphPainter({
    required this.data,
    required this.labelY,
    required this.graphColor,
    required this.graphOpacity,
    required this.infosColor,
    required this.x,
    required this.y,
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
      graph.width / (x - 1),
      graph.height / y,
    );

    drawAxis(canvas, graph, margin);
    drawLabelsY(canvas, size, margin, graph, cell);
    drawLabelsX(canvas, margin, graph, cell);
    drawVerticalLine(canvas, graph, margin, cell);

    for (int i = 0; i < data.length; i++) {
      drawGraph(
        canvas,
        graph,
        cell,
        margin,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawAxis(Canvas canvas, Size graph, Size margin) {
    double spaceBetween = graph.height / 3;
    Paint linePaint = Paint()
      ..color = infosColor
      ..strokeWidth = 1;

    //X-Axis and horizontal lines
    canvas.drawLine(
        Offset(margin.width, graph.height + margin.height),
        Offset(graph.width + 2 * margin.width, graph.height + margin.height),
        linePaint);

    canvas.drawLine(
        Offset(margin.width, graph.height + margin.height - spaceBetween),
        Offset(graph.width + 2 * margin.width,
            graph.height + margin.height - spaceBetween),
        linePaint);

    canvas.drawLine(
        Offset(margin.width, graph.height + margin.height - spaceBetween * 2),
        Offset(graph.width + 2 * margin.width,
            graph.height + margin.height - spaceBetween * 2),
        linePaint);

    canvas.drawLine(
        Offset(margin.width, graph.height + margin.height - spaceBetween * 3),
        Offset(graph.width + 2 * margin.width,
            graph.height + margin.height - spaceBetween * 3),
        linePaint);

    // canvas.drawLine(
    //     Offset(margin.width, graph.height + margin.height - spaceBetween * 4),
    //     Offset(graph.width + 2 * margin.width,
    //         graph.height + margin.height - spaceBetween * 4),
    //     linePaint);

    //Y-Axis
    // Offset yStart = Offset(margin.width, 0);

    // canvas.drawLine(
    //     yStart, Offset(margin.width, graph.height + margin.height), linePaint);
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
      ..color = graphColor.withOpacity(.5)
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        startOffset,
        marginOffset,
        [
          graphColor.withOpacity(.5),
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
          x / 20,
          margin.height + graph.height - 8 - (i * 8) * cell.height,
        ),
      );
    }
  }

  void drawLabelsX(Canvas canvas, Size margin, Size graph, Size cell) {
    for (int i = 0; i < x; i++) {
      TextSpan span = TextSpan(
        style: TextStyle(
          color: graphColor,
        ),
        text: '',
      );
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(
        canvas,
        Offset(
          margin.width + cell.width * i - 16,
          margin.height + graph.height + 10,
        ),
      );
    }
  }

  void drawGraph(Canvas canvas, Size graph, Size cell, Size margin) {
    Paint fillPaint = Paint()
      ..color = graphColor.withOpacity(graphOpacity)
      ..style = PaintingStyle.fill;
    Paint strokePaint = Paint()
      ..color = graphColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    List<double> normedData = data.map((e) => e / y).toList();

    Path path = Path();
    Path linePath = Path();
    path.moveTo(margin.width, graph.height + margin.height);
    path.lineTo(
      margin.width,
      margin.height + graph.height - normedData[0] * graph.height,
    );
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
      path.lineTo(
        margin.width + i * cell.width,
        margin.height + graph.height - normedData[i] * graph.height,
      );
      linePath.lineTo(
        margin.width + i * cell.width,
        margin.height + graph.height - normedData[i] * graph.height,
      );
    }
    //TODO linien mit rechtem winkel zeichnen
    path.lineTo(
        margin.width + (normedData.length - 1) * cell.width, margin.height);
    path.lineTo(
      margin.width + cell.width * (i - 1),
      margin.height + graph.height,
    );
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(linePath, strokePaint);
  }
}
