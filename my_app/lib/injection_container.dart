import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:my_app/features/test/inject_test.dart';

import 'core/network/api_provider.dart';

final GetIt getIt = GetIt.instance;

// how to use
// ignore: slash_for_doc_comments
/**
 * Future.wait([
    ServiceLocator().setup(),
    ]).then((value) {
    runApp(const App());
    });
 * **/
class ServiceLocator {
  Future<void> setup() async {
    getIt.registerFactory(() => Dio());
    getIt.registerFactory(() => ApiProvider(getIt()));

    injectTest();
  }
}
