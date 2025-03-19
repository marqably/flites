import 'package:flutter_test/flutter_test.dart';
import 'package:flites/main.dart';

void main() {
  testWidgets('Find flites text', (WidgetTester tester) async {
    await tester.pumpWidget(const FlitesApp());

    expect(find.text('Export'), findsOneWidget);
  });
}
