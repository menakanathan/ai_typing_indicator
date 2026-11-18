import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_typing_indicator/ai_typing_indicator.dart';

void main() {
  testWidgets('renders incoming stream tokens progressively', (tester) async {
    final controller = StreamController<String>();
    var finished = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StreamingTextBox(
            tokenStream: controller.stream,
            onCompleted: () => finished = true,
          ),
        ),
      ),
    );

    controller.add('Hello ');
    await tester.pump();
    expect(find.textContaining('Hello '), findsOneWidget);

    controller.add('Graduate Class!');
    await tester.pump();
    expect(find.textContaining('Hello Graduate Class!'), findsOneWidget);

    await controller.close();
    await tester.pump();
    expect(finished, isTrue);
  });
}
