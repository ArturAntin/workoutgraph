import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:workoutgraph/chart.dart';

class Graph extends StatelessWidget {
  Graph({
    Key? key,
    required this.data,
    required this.maxY,
    required this.maxX,
    this.height = 150,
    this.width = 300,
    this.lines = 3,
  }) : super(key: key);

  final List<int> data;
  final int maxY;
  final int maxX;
  final double height;
  final double width;
  final int lines;

  double get _average => data.average;
  int get _max => data.reduce(max);
  final BorderRadius _borderRadius = BorderRadius.circular(8.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: _borderRadius,
        color: Colors.white54,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LineGraph(
                data: data,
                x: maxX,
                y: maxY,
                lines: lines,
                labelY: getLabelsY(maxY),
                graphColor: Theme.of(context).primaryColor,
                infosColor: Theme.of(context).hintColor,
                height: height,
                width: width,
                average: _average,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Level"),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 48,
                      child: Center(
                        child: Text(
                          data.last.toString(),
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const RotationTransition(
                              turns: AlwaysStoppedAnimation(90 / 360),
                              child: Icon(Icons.motion_photos_off_outlined),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: 24,
                              child: Text(
                                _average.truncate().toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.arrow_circle_up),
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: 24,
                              child: Text(
                                _max.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(fontSize: 18),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> getLabelsY(int maxY) {
    int distance = (maxY / lines).truncate();
    List<String> res = [];
    for (int i = 0; i <= maxY; i += distance) {
      res.add(i.toString());
    }
    return res;
  }
}
