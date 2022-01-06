// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workoutgraph/circle_info.dart';

import 'package:workoutgraph/main.dart';

void main() {
  testWidgets('Banner is shown after workout is done',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MaterialBanner), findsNothing);
    await tester.pump(const Duration(seconds: HomePage.maxTime));
    expect(find.byType(MaterialBanner), findsOneWidget);
  });

  testWidgets('Circle Gauges are shown', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(CircleInfo), findsWidgets);
  });

  testWidgets('time is adding one every second', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 2));
    expect(find.text("0:02"), findsWidgets);

    await tester.pump(const Duration(seconds: 2));

    expect(find.text("0:04"), findsWidgets);
  });

  testWidgets('Pause Button actually pauses the time',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 2));
    expect(find.text("0:02"), findsWidgets);

    await tester.tap(find.byIcon(Icons.pause));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.text("0:02"), findsWidgets);
  });
}
