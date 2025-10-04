import 'package:flites/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Find flites text', (tester) async {
    await tester.pumpWidget(const FlitesApp());

    expect(find.text('TOOLS'), findsOneWidget);
  });
}
