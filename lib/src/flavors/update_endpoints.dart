import 'dart:io';

/// Overwrites `lib/core/network/app_endpoints.dart` with a flavor-aware
/// version that uses `FlavorConfig.instance.apiBaseUrl` instead of a
/// hardcoded URL.
Future<void> updateEndpointsForFlavors() async {
  File('lib/core/network/app_endpoints.dart').writeAsStringSync('''
import '../../config/flavor/flavor_config.dart';

class AppEndpoints {
  static String get baseUrl => FlavorConfig.instance.apiBaseUrl;

  static String get getPosts => '\${baseUrl}posts';
}
''');

  print('Updated app_endpoints.dart for flavor support');
}
