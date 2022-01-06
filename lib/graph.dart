import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:workoutgraph/chart.dart';
import 'package:workoutgraph/data_stream.dart';

class Graph extends StatelessWidget {
  Graph({Key? key, required this.data}) : super(key: key);

  final List<int> data;

  double get _average => data.average;
  int get _max => data.reduce(max);
  final BorderRadius _borderRadius = BorderRadius.circular(8.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white54,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LineGraph(
                data: data,
                x: MyStream.maxTime,
                y: MyStream.maxY,
                labelY: const ['0', '8', '16', '24'],
                graphColor: Theme.of(context).primaryColor,
                infosColor: Theme.of(context).hintColor,
                height: 150,
                width: 300,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: _borderRadius,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
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
}
