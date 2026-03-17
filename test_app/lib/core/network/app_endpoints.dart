import '../../config/flavor/flavor_config.dart';

class AppEndpoints {
  static String get baseUrl => FlavorConfig.instance.apiBaseUrl;

  static String get getPosts => '${baseUrl}posts';
}
