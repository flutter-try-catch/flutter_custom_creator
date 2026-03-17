import 'package:flutter/material.dart';

import 'app.dart';
import 'injection_container.dart';
import 'config/flavor/flavor_config.dart';
import 'config/theme/theme_manager.dart';
import 'config/auth/auth_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig.initialize(
    flavor: Flavor.prod,
    appName: 'Test App',
    apiBaseUrl: 'https://api.example.com/',
  );

  themeManager = await ThemeManager.loadTheme();
  authManager = await AuthManager.loadUser();

  Future.wait([
    ServiceLocator().setup(),
  ]).then((value) {
    runApp(App());
  });
}
