// ignore_for_file: depend_on_referenced_packages

import 'package:async/src/result/result.dart';
import 'package:domain_book/domain_book.dart';
import 'package:entity_book/entity_book.dart';

import '../extension/nullable_generic.dart';
import 'dummy_book.dart';

class FakeFetchBookDetailUseCase implements FetchBookDetailUseCase {
  Book defaultResult = dummyBook(id: 1);

  Future<Result<Book>> Function({String? id})? stubCall;

  @override
  Future<Result<Book>> call({required String id}) {
    return stubCall.let((it) => it.call(id: id)) ??
        Future.value(Result.value(defaultResult));
  }
}
