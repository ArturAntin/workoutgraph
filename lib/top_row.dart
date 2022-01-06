import 'dart:async';

import 'package:flutter/material.dart';

class TopRow extends StatefulWidget {
  const TopRow(
      {Key? key,
      required this.timerFinished,
      required this.streamSubscription,
      required this.time,
      required this.restartWorkout})
      : super(key: key);

  final bool timerFinished;
  final StreamSubscription streamSubscription;
  final DateTime time;
  final void Function() restartWorkout;

  @override
  State<TopRow> createState() => _TopRowState();
}

class _TopRowState extends State<TopRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: widget.timerFinished
                  ? null
                  : () {
                      setState(() {
                        widget.streamSubscription.isPaused
                            ? widget.streamSubscription.resume()
                            : widget.streamSubscription.pause();
                      });
                    },
              icon: widget.streamSubscription.isPaused
                  ? const Icon(Icons.play_arrow)
                  : const Icon(Icons.pause),
              label: widget.streamSubscription.isPaused
                  ? const Text("Resume")
                  : const Text("Pause / Stop"),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              widget.time.minute.toString() +
                  ':' +
                  widget.time.second.toString().padLeft(2, '0'),
              style:
                  Theme.of(context).textTheme.headline4!.copyWith(fontSize: 30),
            ),
          ),
        ),
        Expanded(
          child: Visibility(
            visible: widget.streamSubscription.isPaused,
            maintainAnimation: true,
            maintainSize: true,
            maintainState: true,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: widget.restartWorkout,
              icon: const Icon(Icons.restart_alt),
              label: const Text("Start new workout"),
            ),
          ),
        ),
      ],
    );
  }
}
