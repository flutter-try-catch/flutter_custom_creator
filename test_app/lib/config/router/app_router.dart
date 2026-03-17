import 'package:flutter/material.dart';
import 'unknown_route.dart';

class AppRouter {
  ///[navigatorKey] is the global NavigatorState key
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => const Scaffold(), settings: settings);
      default:
        return unknownRoute;
    }
  }

  static BuildContext get currentContext => navigatorKey.currentState!.context;

  static Route get unknownRoute =>
      MaterialPageRoute(builder: (context) => const UnknownRoute());

  //To go back or close snackBars, dialogs, bottomSheets, or anything you would normally close with Navigator.pop(context);
  static void pop(dynamic data) {
    navigatorKey.currentState?.pop(data);
  }

  //Navigate to new screen with name
  static Future<Object?>? to(String route, {Object? data}) async {
    return await navigatorKey.currentState?.pushNamed(route, arguments: data);
  }

  //To go to the next screen and no option to go back to the previous screen
  static Future<Object?>? toReplacement(String route, {Object? data}) async {
    return await navigatorKey.currentState
        ?.pushReplacementNamed(route, arguments: data);
  }

  //To go to the next screen and cancel all previous routes
  static Future<Object?>? toAndRemoveUntil(String route, {Object? data}) async {
    return await navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(route, (route) => false, arguments: data);
  }

}

