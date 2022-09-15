import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:networking/src/connection_interceptor.dart';
import 'package:networking/src/goat_response_array_model.dart';

class NetworkRequest extends DioForNative {
  final String baseUrl;
  final ConnectionInterceptor connectionInterceptor;

  NetworkRequest(
    this.baseUrl, {
    required this.connectionInterceptor,
  }) {
    options.baseUrl = baseUrl;
    interceptors.add(connectionInterceptor);
  }

  Future<Result<T>> getRequest<T>(
    T Function(Map<String, dynamic>) decoder, {
    String path = "",
    Map<String, dynamic>? queryParameters,
    Options? options,
    String? errorPayloadKey,
  }) async {
    try {
      final response = await get<String>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      if (response.data != null) {
        final json = jsonDecode(response.data!);
        if (json is T) {
          return Result.value(json);
        } else {
          if (errorPayloadKey?.isNotEmpty == true &&
              json[errorPayloadKey] != null) {
            return Result.error(Exception(json[errorPayloadKey]));
          }
          return Result.value(decoder(json));
        }
      } else {
        // if response is null then return error
        return Result.error(Exception());
      }
    } on DioError catch (e) {
      return Result.error(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<GoatResponseArrayModel<T>>> getRequestArray<T>(
    T Function(Map<String, dynamic>) decoder, {
    String path = "",
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final rawResponse = await get<String>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      if (rawResponse.data != null) {
        final json = jsonDecode(rawResponse.data!);
        final response = GoatResponseArrayModel<T>.fromJson(json, decoder);
        return Result.value(response);
      } else {
        // if response is null then return empty Response Array
        return Result.value(GoatResponseArrayModel());
      }
    } on DioError catch (e) {
      return Result.error(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
