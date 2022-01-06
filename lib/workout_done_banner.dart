import 'package:flutter/material.dart';

class WorkoutDoneBanner extends StatelessWidget {
  final _borderRadius = BorderRadius.circular(8.0);
  final double avg;
  final int max;

  final void Function() restartWorkout;

  WorkoutDoneBanner({
    Key? key,
    required this.avg,
    required this.max,
    required this.restartWorkout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: _borderRadius,
        child: MaterialBanner(
          backgroundColor: Theme.of(context).primaryColorLight,
          forceActionsBelow: true,
          content: Text(
            "Good job! Your workout is over.\nYour average level was ${avg.toStringAsFixed(2)}\nYour maximum level was $max",
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
    );
  }
}
