import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alegria_navigation_app/main_screen.dart';

void main() {
  testWidgets('Capture screenshots', (WidgetTester tester) async {
    // Set screen size to mobile dimensions
    tester.view.physicalSize = const Size(1080, 2220);
    tester.view.devicePixelRatio = 2.5;

    final repaintBoundaryKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: RepaintBoundary(
          key: repaintBoundaryKey,
          child: const MainScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Directory for screenshots
    final dir = Directory('screenshots');
    if (!dir.existsSync()) {
      dir.createSync();
    }

    // Helper to capture
    Future<void> saveScreenshot(String filename) async {
      final boundary = repaintBoundaryKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 1.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();
      final file = File('screenshots/$filename');
      await file.writeAsBytes(bytes);
      print('Saved: ${file.path}');
    }

    // Tab 0: Home
    await saveScreenshot('1_home_page.png');

    // Tab 1: Calculator
    await tester.tap(find.byIcon(Icons.calculate_outlined));
    await tester.pumpAndSettle();
    await saveScreenshot('2_calculator_page.png');

    // Tab 2: Profile
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    await saveScreenshot('3_profile_page.png');

    // Tab 3: Social Media
    await tester.tap(find.byIcon(Icons.share_outlined));
    await tester.pumpAndSettle();
    await saveScreenshot('4_social_media_page.png');

    // Reset view
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
