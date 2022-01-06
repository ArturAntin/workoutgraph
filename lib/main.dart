import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:workoutgraph/data_stream.dart';
import 'package:workoutgraph/gauges.dart';
import 'package:workoutgraph/graph.dart';
import 'package:workoutgraph/top_row.dart';
import 'package:workoutgraph/workout_done_banner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Envidual Workout",
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(0, 133, 149, 1),
        primaryColorLight: const Color.fromRGBO(80, 181, 198, 1),
        primaryColorDark: const Color.fromRGBO(0, 88, 103, 1),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  ///[maxTime] represents the time after the workout is completed. When this time is reached, the timer will stop.
  ///[maxY] is the amplitude of y
  ///[lines] is the number of horizontal lines shown in the graph plus the line at the bottom
  ///[maxY] needs to be divisible by [lines] so the graph will show the correct numbers on the side
  static const maxTime = 1 * 60;
  static const maxY = 24;
  static const lines = 3;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _streamData = <int>[];
  DateTime _time = DateTime.fromMillisecondsSinceEpoch(0);
  StreamSubscription? _streamSubscription;
  bool _timerFinished = false;

  @override
  void initState() {
    super.initState();
    subscribeToStream();
  }

  void subscribeToStream() {
    _streamSubscription = timedCounter(HomePage.maxTime).listen((int event) {
      _streamData.add(event);
      setState(() {
        _time = DateTime.fromMillisecondsSinceEpoch(_streamData.length * 1000);
        if (_streamData.length >= HomePage.maxTime) {
          _timerFinished = true;
        }
      });
    });
  }

  void restartWorkout() {
    setState(() {
      _streamData.clear();
      _timerFinished = false;
      subscribeToStream();
      _time = DateTime.fromMillisecondsSinceEpoch(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Envidual Workout"),
      ),
      body: _streamSubscription == null || _streamData.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 8.0,
                ),
                child: Column(
                  children: [
                    //Pause Button and Time
                    TopRow(
                      timerFinished: _timerFinished,
                      streamSubscription: _streamSubscription!,
                      time: _time,
                      restartWorkout: restartWorkout,
                    ),

                    //show Banner if workout is completed
                    if (_timerFinished)
                      WorkoutDoneBanner(
                        avg: _streamData.average,
                        max: _streamData.reduce(max),
                        restartWorkout: restartWorkout,
                      ),

                    Graph(
                      data: _streamData,
                      maxX: HomePage.maxTime,
                      maxY: HomePage.maxY,
                      lines: HomePage.lines,
                    ),

                    Gauges(),
                  ],
                ),
              ),
            ),
    );
  }
}
