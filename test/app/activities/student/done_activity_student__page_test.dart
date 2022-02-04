import 'package:flutter_test/flutter_test.dart';

main() {
  group('DoneActivityStudentPage', () {
    testWidgets('has a title and message', (WidgetTester tester) async {
      final titleFinder = find.text('T');
      expect(titleFinder, findsOneWidget);
    });
  });
}
