import 'dart:io';

import 'package:test_utils/src/fakeclient/fake_http_client.dart';

class FakeHttpOverrides extends HttpOverrides {
  bool warningPrinted = false;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return FakeHttpClient();
  }
}
