// ignore: depend_on_referenced_packages
import 'package:async/async.dart';

import '../result_util.dart';

T? tryCast<T>(dynamic object) => object is T ? object : null;

extension ResultHandling<T> on Result<T> {
  String loggableInfo() {
    return when(
      onValue: (value) => "Value: ${value.toString()}",
      onError: (error) => "Error: ${error.toString()}",
    );
  }

  Result<R> map<R>(
    Result<R> Function(T t) transformValue, [
    ErrorResult Function(ErrorResult errorResult)? transformError,
  ]) {
    final valueResult = asValue;
    final errorResult = asError;
    if (valueResult != null) {
      return transformValue(valueResult.value);
    } else if (errorResult != null) {
      if (transformError != null) {
        return transformError(errorResult);
      }
      return errorResult;
    }
    return Result.error(Exception("map impossible result"));
  }

  Future<Result<R>> mapAsync<R>(
    Future<Result<R>> Function(T t) transformValue, [
    Future<ErrorResult> Function(ErrorResult errorResult)? transformError,
  ]) async {
    final valueResult = asValue;
    final errorResult = asError;
    if (valueResult != null) {
      return transformValue(valueResult.value);
    } else if (errorResult != null) {
      if (transformError != null) {
        return transformError(errorResult);
      }
      return errorResult;
    }
    return Result.error(Exception("map impossible result"));
  }

  Result<T> mapError(
    ErrorResult Function(ErrorResult errorResult)? transformError,
  ) {
    final valueResult = asValue;
    final errorResult = asError;
    if (valueResult != null) {
      return this;
    } else if (errorResult != null) {
      if (transformError != null) {
        return transformError(errorResult);
      }
      return errorResult;
    }
    return Result.error(Exception("map impossible result"));
  }

  T getValueOrElse(T Function() orElse) {
    final valueResult = asValue;
    if (valueResult != null) {
      return valueResult.value;
    }
    return orElse();
  }

  T getValueOrDefault(T backup) {
    final valueResult = asValue;
    if (valueResult != null) {
      return valueResult.value;
    }
    return backup;
  }

  AsyncValue<T> toAsyncValue() {
    final valueResult = asValue;
    final errorResult = asError;
    if (valueResult != null) {
      return AsyncValue.data(valueResult.value);
    } else if (errorResult != null) {
      return AsyncValue.error(errorResult.error,
          stackTrace: errorResult.stackTrace);
    }
    return const AsyncValue.loading();
  }

  Future<void> onValue(Future<void> Function(T t) lambda) async {
    final valueResult = asValue;
    if (valueResult != null) {
      return await lambda(valueResult.value);
    }
  }

  Future<void> onError<E>(Future<void> Function(E t) lambda) async {
    final errorResult = asError;
    if (errorResult != null) {
      final obj = tryCast<E>(errorResult.error);
      if (obj != null) {
        await lambda(obj);
      }
    }
  }

  Future<Result<T>> passValue(Future<void> Function(T t)? onValue) async {
    final valueResult = asValue;
    if (valueResult != null) {
      await onValue?.call(valueResult.value);
    }
    return this;
  }

  Future<Result<T>> passError<E>(Future<void> Function(E t) lambda) async {
    final errorResult = asError;
    if (errorResult != null) {
      final obj = tryCast<E>(errorResult.error);
      if (obj != null) {
        await lambda(obj);
      }
    }
    return this;
  }

  R when<R>({
    required R Function(T t) onValue,
    required R Function(Object t) onError,
  }) {
    final valueResult = asValue;
    final errorResult = asError;
    if (valueResult != null) {
      return onValue(valueResult.value);
    } else if (errorResult != null) {
      return onError(errorResult.error);
    }
    return throw Exception("when impossible result");
  }

  Future<R> whenAsync<R>({
    required Future<R> Function(T t) onValue,
    required Future<R> Function(Object t) onError,
  }) {
    final valueResult = asValue;
    final errorResult = asError;
    if (valueResult != null) {
      return onValue(valueResult.value);
    } else if (errorResult != null) {
      return onError(errorResult.error);
    }
    return throw Exception("when impossible result");
  }
}
