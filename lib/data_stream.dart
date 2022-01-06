import 'dart:async';
import 'dart:math';

import 'package:workoutgraph/main.dart';

Stream<int> timedCounter([int maxTime = 10 * 60]) {
  Duration interval = const Duration(seconds: 1);
  late StreamController<int> controller;
  Timer? timer;
  int time = 0;
  final _random = Random();

  void tick(_) {
    time++;

    ///creates a random number 0..24 and puts it into the stream
    controller.add(
      _random.nextInt(HomePage.maxY + 1),
    );

    ///checks if maxTime is reached and cancels the timer if true
    if (time >= maxTime) {
      timer?.cancel();
      controller.close();
    }
  }

  void startTimer() {
    timer = Timer.periodic(interval, tick);
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  controller = StreamController<int>(
    onListen: startTimer,
    onPause: stopTimer,
    onResume: startTimer,
    onCancel: stopTimer,
  );

  return controller.stream;
}
