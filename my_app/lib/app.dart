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
      home: Container(),
      debugShowCheckedModeBanner: false,
      navigatorKey: AppRouter.navigatorKey,
      initialRoute: '/',
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
