import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:networking/networking.dart';
import 'package:networking/src/connection_interceptor.dart';
import 'package:service_locator/service_locator.dart';

class NetworkRequestRegistrar implements Registrar {
  final String baseURL;

  NetworkRequestRegistrar({required this.baseURL});

  @override
  Future<void> register(ServiceLocator locator) async {
    locator.registerFactory(() => InternetConnectionChecker());
    locator.registerFactory(() => ConnectionInterceptor(locator()));
    locator.registerFactory<NetworkRequest>(
      () => NetworkRequest(baseURL, connectionInterceptor: locator()),
    );
  }
}
