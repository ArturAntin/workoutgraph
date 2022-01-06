import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:workoutgraph/circle_info.dart';
import 'package:workoutgraph/data_stream.dart';
import 'package:workoutgraph/graph.dart';

void main() {
  runApp(const MyApp());
}

//TODO https://dart.dev/articles/libraries/creating-streams#using-a-streamcontroller

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

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _streamData = <int>[];
  DateTime _time = DateTime.fromMillisecondsSinceEpoch(0);
  StreamSubscription? _streamSubscription;
  final MyStream _myStream = MyStream();
  final BorderRadius _borderRadius = BorderRadius.circular(8.0);

  @override
  void initState() {
    super.initState();
    subscribeToStream();
  }

  void subscribeToStream() {
    if (_streamSubscription != null) _streamSubscription!.cancel();
    _streamSubscription = _myStream.stream.listen((event) {
      if (_streamSubscription != null && !_streamSubscription!.isPaused) {
        _streamData.add(event);
        setState(() {
          _time =
              DateTime.fromMillisecondsSinceEpoch(_streamData.length * 1000);
        });
      }
    });
  }

  void restartWorkout() {
    setState(() {
      _streamData.clear();
      _myStream.reset();
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 160,
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            onPressed: _myStream.timerFinished
                                ? null
                                : () {
                                    setState(() {
                                      _streamSubscription!.isPaused
                                          ? _streamSubscription!.resume()
                                          : _streamSubscription!.pause();
                                    });
                                  },
                            icon: _streamSubscription!.isPaused
                                ? const Icon(Icons.play_arrow)
                                : const Icon(Icons.pause),
                            label: _streamSubscription!.isPaused
                                ? const Text("Resume")
                                : const Text("Pause / Stop"),
                          ),
                        ),
                        Text(
                          _time.minute.toString() +
                              ':' +
                              _time.second.toString().padLeft(2, '0'),
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Visibility(
                          visible: _streamSubscription!.isPaused,
                          maintainSize: true,
                          maintainState: true,
                          maintainAnimation: true,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            onPressed: restartWorkout,
                            icon: const Icon(Icons.restart_alt),
                            label: const Text("Start new workout"),
                          ),
                        ),
                      ],
                    ),

                    //show Banner if workout is completed
                    if (_myStream.timerFinished)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: _borderRadius,
                          child: MaterialBanner(
                            backgroundColor:
                                Theme.of(context).primaryColorLight,
                            forceActionsBelow: true,
                            content: Text(
                              "Good job! Your workout is over.\nYour average level was ${_streamData.average.toStringAsFixed(2)}\nYour maximum level was ${_streamData.reduce(max)}",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            actions: [
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  primary: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: restartWorkout,
                                icon: const Icon(Icons.restart_alt),
                                label: const Text("Start new workout"),
                              )
                            ],
                          ),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Graph(
                        data: _streamData,
                      ),
                    ),

                    Wrap(
                      spacing: 24,
                      runSpacing: 12,
                      children: const [
                        CircleInfo(
                          text: "km/h",
                          number: 24,
                          maxNumber: 30,
                          icon: Icons.speed,
                        ),
                        CircleInfo(
                          text: "rpm",
                          number: 99,
                          maxNumber: 200,
                          icon: Icons.repeat,
                        ),
                        CircleInfo(
                          text: "watt",
                          number: 142,
                          maxNumber: 180,
                          icon: Icons.bolt,
                        ),
                        CircleInfo(
                          text: "bpm",
                          number: 143,
                          maxNumber: 160,
                          icon: Icons.favorite,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
