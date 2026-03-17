import 'dart:io';

/// Creates the `lib/config/flavor/flavor_config.dart` file with a singleton
/// FlavorConfig class that provides flavor-specific configuration throughout
/// the app.
Future<void> createFlavorConfig() async {
  Directory('lib/config/flavor').createSync(recursive: true);

  File('lib/config/flavor/flavor_config.dart').writeAsStringSync('''
enum Flavor { dev, staging, prod }

class FlavorConfig {
  static FlavorConfig? _instance;

  final Flavor flavor;
  final String appName;
  final String apiBaseUrl;

  FlavorConfig._internal({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
  });

  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception(
        'FlavorConfig has not been initialized. '
        'Call FlavorConfig.initialize() in your main file before using it.',
      );
    }
    return _instance!;
  }

  static void initialize({
    required Flavor flavor,
    required String appName,
    required String apiBaseUrl,
  }) {
    _instance = FlavorConfig._internal(
      flavor: flavor,
      appName: appName,
      apiBaseUrl: apiBaseUrl,
    );
  }

  bool get isDev => flavor == Flavor.dev;
  bool get isStaging => flavor == Flavor.staging;
  bool get isProd => flavor == Flavor.prod;

  static String get currentApiBaseUrl => instance.apiBaseUrl;
  static String get currentAppName => instance.appName;
  static Flavor get currentFlavor => instance.flavor;
}
''');

  print('Created flavor_config.dart');
}
