import 'package:flutter_test/flutter_test.dart';
import 'package:workoutgraph/data_stream.dart';
import 'package:workoutgraph/main.dart';
import 'dart:async';

void main() {
  group("data stream", () {
    Stream<int> stream = timedCounter();
    //This will run before every test
    setUp(() => stream = timedCounter());

    test('should always emit numbers within the range(maxY,0) inclusively', () {
      stream.listen(
        expectAsync1(
          (value) => expect(
            value,
            inInclusiveRange(0, HomePage.maxY),
          ),
          count: 15,
        ),
      );
    });
  });
}
