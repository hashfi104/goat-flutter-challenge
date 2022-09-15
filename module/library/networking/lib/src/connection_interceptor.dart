import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:networking/src/no_internet_exception.dart';

class ConnectionInterceptor implements Interceptor {
  final InternetConnectionChecker internetConnectionChecker;

  ConnectionInterceptor(this.internetConnectionChecker);

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (await internetConnectionChecker.hasConnection) {
      handler.next(options);
    } else {
      final error = DioError(
        requestOptions: options,
        type: DioErrorType.connectTimeout,
        error: const NoInternetException(),
      );
      handler.reject(error);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
