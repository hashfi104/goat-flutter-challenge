import 'package:lazy_evaluation/lazy_evaluation.dart';
import 'package:service_locator/src/service_locator.dart';

extension ServiceLocatorX on ServiceLocator {
  /// registers a type alias, so whenever the first type [A] is requested,
  /// It redirects it to as type B
  void alias<A extends Object, B extends A>() {
    assert(A != Object && B != A,
        "The Generics must be specified, also A & B must be different");
    final locator = this;
    locator.registerFactory<A>(
      () => locator<B>(),
    );
  }

  /// shorthand for providing optional dependency
  T? getOrNull<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) {
    if (isRegistered<T>()) {
      return get<T>(instanceName: instanceName, param1: param1, param2: param2);
    }
    return null;
  }

  Factory<T> factory<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) {
    final locator = this;
    return () =>
        locator(instanceName: instanceName, param1: param1, param2: param2);
  }

  FactoryAsync<T> factoryAsync<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) {
    final locator = this;
    return () => locator.getAsync(
        instanceName: instanceName, param1: param1, param2: param2);
  }

  Lazy<T> lazy<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) {
    return Lazy(
        factory(instanceName: instanceName, param1: param1, param2: param2));
  }

  Lazy<Future<T>> lazyAsync<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) {
    final locator = this;
    return Lazy(() => locator.getAsync(
        instanceName: instanceName, param1: param1, param2: param2));
  }
}
