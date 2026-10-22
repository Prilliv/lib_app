import 'package:flutter_test/flutter_test.dart';
import 'package:library_app/main.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    await tester.pumpWidget(const LibraryApp());
    // Just ensure it builds without throwing
    expect(find.byType(LibraryApp), findsOneWidget);
  });
}
