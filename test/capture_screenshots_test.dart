import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alegria_navigation_app/demo_auth.dart';
import 'package:alegria_navigation_app/main_screen.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  testWidgets('Capture screenshots', (WidgetTester tester) async {
    // Set screen size to mobile dimensions
    tester.view.physicalSize = const Size(1080, 2220);
    tester.view.devicePixelRatio = 2.5;

    DemoAuth.login('admin', 'admin123');

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
      debugPrint('Saved: ${file.path}');
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

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _TestHttpClient();
  }
}

class _TestHttpClient implements HttpClient {
  @override
  bool autoUncompress = true;
  @override
  Duration? connectionTimeout;
  @override
  Duration idleTimeout = const Duration(seconds: 15);
  @override
  int? maxConnectionsPerHost;
  @override
  String? userAgent;

  @override
  void addCredentials(Uri url, String realm, HttpClientCredentials credentials) {}
  @override
  void addProxyCredentials(String host, int port, String realm, HttpClientCredentials credentials) {}
  @override
  set authenticate(Future<bool> Function(Uri url, String scheme, String? realm)? f) {}
  @override
  set authenticateProxy(Future<bool> Function(String host, int port, String scheme, String? realm)? f) {}
  @override
  set badCertificateCallback(bool Function(X509Certificate cert, String host, int port)? callback) {}
  @override
  set findProxy(String Function(Uri url)? f) {}

  @override
  void close({bool force = false}) {}

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _TestHttpClientRequest();
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async => _TestHttpClientRequest();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _TestHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _TestHttpClientResponse();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  @override
  int get statusCode => 200;
  @override
  int get contentLength => _kTransparentImage.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;
  @override
  final HttpHeaders headers = _TestHttpHeaders();

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_kTransparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final Uint8List _kTransparentImage = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
  0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
  0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
  0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82,
]);
