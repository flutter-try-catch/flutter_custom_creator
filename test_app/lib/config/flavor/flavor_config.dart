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
