import 'package:service_locator/src/service_locator.dart';

abstract class Registrar {
  Future<void> register(ServiceLocator locator);
}

abstract class Initiator implements Registrar {
  @override
  Future<void> register(ServiceLocator locator) {
    return init(locator);
  }

  Future<void> init(ServiceLocator locator);
}
