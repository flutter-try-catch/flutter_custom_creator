import 'dart:io';

// Create theme file
/// Creates the `app.dart` file with a basic material app that uses the
/// [themeManager] and the [AppRouter].
///
/// The generated file is a [StatefulWidget] with an empty [MaterialApp] and has
/// a listener on the [themeManager] to update the theme when the user changes
/// the system theme.
///
/// The generated file also prints a message to the console when it is created.
///
/// The file is written to the `lib` directory of the current working directory.
///
Future<void> createAppFile() async {
  File('lib/app.dart').writeAsStringSync('''
import 'package:flutter/material.dart';
import 'config/theme/theme_manager.dart';
import 'config/auth/auth_manager.dart';
import 'config/router/app_router.dart';
import 'config/app_helper/app_constants.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    themeManager.addListener(_notifyChange);
    authManager.addListener(_notifyChange);
  }

  @override
  void dispose() {
    themeManager.removeListener(_notifyChange);
    authManager.removeListener(_notifyChange);
    super.dispose();
  }

  void _notifyChange() {
    setState(() {}); // Rebuild the widget when the theme changes
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: themeManager.themeData,
      debugShowCheckedModeBanner: false,
      navigatorKey: AppRouter.navigatorKey,
      initialRoute: '/',
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
''');

  print('Created app.dart file successfully! 🎉');
}
