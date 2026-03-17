import 'dart:io';

/// Creates three flavor-specific entry point files:
/// - `lib/main_dev.dart`
/// - `lib/main_staging.dart`
/// - `lib/main_prod.dart`
///
/// Each file initializes FlavorConfig with the appropriate flavor,
/// then runs the same app initialization as `main.dart`.
Future<void> createFlavorMainFiles({required String appName}) async {
  // Convert project name to a display name (e.g., "my_app" -> "My App")
  String displayName = appName
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');

  _createMainFile(
    fileName: 'lib/main_dev.dart',
    flavor: 'Flavor.dev',
    appDisplayName: '$displayName Dev',
    apiBaseUrl: 'https://dev-api.example.com/',
  );

  _createMainFile(
    fileName: 'lib/main_staging.dart',
    flavor: 'Flavor.staging',
    appDisplayName: '$displayName Staging',
    apiBaseUrl: 'https://staging-api.example.com/',
  );

  _createMainFile(
    fileName: 'lib/main_prod.dart',
    flavor: 'Flavor.prod',
    appDisplayName: displayName,
    apiBaseUrl: 'https://api.example.com/',
  );

  print('Created main_dev.dart, main_staging.dart, main_prod.dart');
}

void _createMainFile({
  required String fileName,
  required String flavor,
  required String appDisplayName,
  required String apiBaseUrl,
}) {
  File(fileName).writeAsStringSync('''
import 'package:flutter/material.dart';

import 'app.dart';
import 'injection_container.dart';
import 'config/flavor/flavor_config.dart';
import 'config/theme/theme_manager.dart';
import 'config/auth/auth_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig.initialize(
    flavor: $flavor,
    appName: '$appDisplayName',
    apiBaseUrl: '$apiBaseUrl',
  );

  themeManager = await ThemeManager.loadTheme();
  authManager = await AuthManager.loadUser();

  Future.wait([
    ServiceLocator().setup(),
  ]).then((value) {
    runApp(App());
  });
}
''');
}
