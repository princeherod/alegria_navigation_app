import 'package:flutter_test/flutter_test.dart';
import 'package:alegria_navigation_app/main.dart';

void main() {
  testWidgets('App loads LoginScreen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentApp());
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Welcome Back!'), findsOneWidget);
  });
}
