import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alegria_navigation_app/demo_auth.dart';
import 'package:alegria_navigation_app/main.dart';

void main() {
  setUp(() {
    DemoAuth.registeredUsername = null;
    DemoAuth.registeredPassword = null;
    DemoAuth.currentUsername = null;
  });

  testWidgets('Full 14-step checklist test for Student Navigation App', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // 1. Open application -> Login appears first
    await tester.pumpWidget(const StudentApp());
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));

    // 2. Submit empty login fields -> Validation messages appear
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();
    expect(find.text('Enter your username.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);

    // 3. Enter incorrect credentials -> Login is rejected
    await tester.enterText(find.byType(TextFormField).at(0), 'wrongadmin');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrongpass');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();
    expect(find.text('Invalid username or password.'), findsOneWidget);
    
    // Clear snackbar and settle
    tester.state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger)).clearSnackBars();
    await tester.pumpAndSettle();

    // 4. Enter admin / admin123 -> Dashboard opens
    await tester.enterText(find.byType(TextFormField).at(0), 'admin');
    await tester.enterText(find.byType(TextFormField).at(1), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // 5. Read dashboard greeting -> Displays Welcome, admin!
    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Welcome, admin!'), findsOneWidget);

    // 6. Open Calculator and calculate 10 + 5 -> Displays 15.0
    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();
    expect(find.text('BASIC CALCULATOR'), findsOneWidget);

    final num1Field = find.widgetWithText(TextField, 'First Number');
    final num2Field = find.widgetWithText(TextField, 'Second Number');
    await tester.enterText(num1Field, '10');
    await tester.enterText(num2Field, '5');
    await tester.tap(find.widgetWithText(ElevatedButton, '+'));
    await tester.pump();
    expect(find.text('15.0'), findsOneWidget);

    // Also test Step 7 requirements: 20 and 5 for all operations
    await tester.enterText(num1Field, '20');
    await tester.enterText(num2Field, '5');
    await tester.tap(find.widgetWithText(ElevatedButton, '+'));
    await tester.pump();
    expect(find.text('25.0'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, '−'));
    await tester.pump();
    expect(find.text('15.0'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, '×'));
    await tester.pump();
    expect(find.text('100.0'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, '÷'));
    await tester.pump();
    expect(find.text('4.0'), findsOneWidget);

    // 7. Switch tabs and return to Calculator -> Inputs and result remain
    await tester.tap(find.byType(NavigationDestination).at(0));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, admin!'), findsOneWidget);

    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();
    expect(find.text('4.0'), findsOneWidget);

    // 8. Create a social post -> Displays logged-in username
    await tester.tap(find.byType(NavigationDestination).at(2));
    await tester.pumpAndSettle();
    expect(find.text('Social Media'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Create Post'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Caption'), 'First admin announcement');
    await tester.enterText(find.widgetWithText(TextField, 'Image URL'), 'https://picsum.photos/id/1/600/400');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();

    expect(find.text('First admin announcement'), findsOneWidget);
    expect(find.text('admin'), findsWidgets);

    // 9. Like a post and add a comment -> Both interactions update correctly
    final likeButtons = find.widgetWithText(TextButton, 'Like');
    await tester.tap(likeButtons.first);
    await tester.pump();
    expect(find.text('Liked'), findsAtLeastNWidgets(1));

    final commentInputs = find.widgetWithText(TextField, 'Add a comment...');
    await tester.enterText(commentInputs.first, 'Awesome first post!');
    final sendIcons = find.byIcon(Icons.send);
    await tester.ensureVisible(sendIcons.first);
    await tester.tap(sendIcons.first);
    await tester.pump();
    expect(find.text('Awesome first post!'), findsOneWidget);
    expect(find.text('1 Comments'), findsOneWidget);

    // 10. Switch tabs and return to Social -> Posts, likes, and comments remain
    await tester.tap(find.byType(NavigationDestination).at(0));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, admin!'), findsOneWidget);

    await tester.tap(find.byType(NavigationDestination).at(2));
    await tester.pumpAndSettle();
    expect(find.text('First admin announcement'), findsOneWidget);
    expect(find.text('Liked'), findsAtLeastNWidgets(1));
    expect(find.text('Awesome first post!'), findsOneWidget);

    // 11. Open Profile -> Student information and username appear
    await tester.tap(find.byType(NavigationDestination).at(3));
    await tester.pumpAndSettle();
    expect(find.text('Student Profile'), findsOneWidget);
    expect(find.text('Prince Alegria'), findsOneWidget);
    expect(find.text('Logged in as: admin'), findsOneWidget);
    expect(find.text('2026-554271'), findsOneWidget);
    expect(find.text('BSIT — CCE106 (3447)'), findsOneWidget);
    expect(find.text('p.alegria.554271@umindanao.edu.ph'), findsOneWidget);

    // 12. Tap Logout -> Login appears; Back does not reopen MainScreen
    await tester.tap(find.widgetWithText(ElevatedButton, 'Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(DemoAuth.currentUsername, isNull);

    // 13. Register a valid account and log in -> Dashboard displays registered username
    await tester.tap(find.text("Don't have an account? Register"));
    await tester.pumpAndSettle();
    expect(find.text('Create an Account'), findsOneWidget);

    final regInputs = find.byType(TextFormField);
    await tester.enterText(regInputs.at(0), 'student_prince');
    await tester.enterText(regInputs.at(1), 'password123');
    await tester.enterText(regInputs.at(2), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pumpAndSettle();
    tester.state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger)).clearSnackBars();
    await tester.pumpAndSettle();

    // Now login with the newly registered user
    expect(find.text('Welcome Back!'), findsOneWidget);
    final loginInputs = find.byType(TextFormField);
    await tester.enterText(loginInputs.at(0), 'student_prince');
    await tester.enterText(loginInputs.at(1), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Welcome, student_prince!'), findsOneWidget);

    // 14. Create a post using the registered account -> Displays registered username
    await tester.tap(find.byType(NavigationDestination).at(2));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Caption'), 'Post from student_prince');
    await tester.enterText(find.widgetWithText(TextField, 'Image URL'), 'https://picsum.photos/id/2/600/400');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();

    expect(find.text('Post from student_prince'), findsOneWidget);
    expect(find.text('student_prince'), findsWidgets);
  });
}
