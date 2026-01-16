import 'package:flutter_test/flutter_test.dart';
import 'package:yb_news/app.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const YbNewsApp());
    expect(find.text('YB News'), findsOneWidget);
  });
}
