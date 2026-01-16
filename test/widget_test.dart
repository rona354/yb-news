import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App widget can be instantiated', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('YB News Test')),
        ),
      ),
    );
    expect(find.text('YB News Test'), findsOneWidget);
  });
}
