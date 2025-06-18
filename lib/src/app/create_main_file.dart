import 'dart:io';

/// Creates the `main.dart` file which is the entry point of the app
///
/// The generated file imports [MaterialApp], [App], [ThemeManager] and
/// [ServiceLocator].
///
/// The generated file also prints a message to the console when it is created.
///
/// The file is written to the `lib` directory of the current working directory.
createMainFile() {
  File('lib/main.dart').writeAsStringSync('''
// lib/main.dart
import 'package:flutter/material.dart';

import 'app.dart';
import 'injection_container.dart';

import 'config/theme/theme_manager.dart';
import 'config/auth/auth_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  themeManager = await ThemeManager.loadTheme();
  
  // Initialize user manager (generic - can work with any user model)
  authManager = await AuthManager.loadUser();
  
  Future.wait([
    ServiceLocator().setup(),
  ]).then((value) {
    runApp(App());
  });
}
''');
  print('Created main.dart');
}
