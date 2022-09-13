import 'package:service_locator/src/service_locator.dart';

class ServiceLocatorFactoryNotSetError extends Error {}

class ServiceLocatorInitiator {
  static void setServiceLocatorFactory(ServiceLocator Function() generator) {
    _generator = generator;
  }

  static ServiceLocator newServiceLocator() {
    final generator = _generator;
    if (generator == null) {
      throw ServiceLocatorFactoryNotSetError();
    }
    return generator();
  }

  static ServiceLocator Function()? _generator;
}
