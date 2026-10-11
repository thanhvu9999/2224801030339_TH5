import 'package:flutter_test/flutter_test.dart';
import 'package:note_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NoteApp());
    expect(find.text('Ghi chú cá nhân'), findsOneWidget);
  });
}
