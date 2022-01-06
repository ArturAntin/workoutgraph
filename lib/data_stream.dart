import 'dart:async';
import 'dart:math';

class MyStream {
  final _controller = StreamController<int>();
  final _random = Random();

  ///maxTime is 1 minute, so 1 minutes * 60 seconds
  static const maxTime = 1 * 60;
  static const maxY = 24;

  int _time = 0;
  bool _timerFinished = false;

  MyStream() {
    Timer.periodic(const Duration(seconds: 1), (timer) => timerAction(timer));
  }

  void reset() {
    _time = 0;
    _timerFinished = false;
    Timer.periodic(const Duration(seconds: 1), (timer) => timerAction(timer));
  }

  void timerAction(Timer timer) {
    ///creates a random number 0..24 and puts it into the stream
    _controller.sink.add(_random.nextInt(maxY + 1));
    _time++;

    ///checks if maxTime is reached and cancels the timer if true
    if (_time >= maxTime) {
      timer.cancel();
      _timerFinished = true;
    }
  }

  Stream<int> get stream => _controller.stream;

  bool get timerFinished => _timerFinished;
}
