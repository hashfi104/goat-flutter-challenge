// ignore_for_file: depend_on_referenced_packages

import 'package:async/src/result/result.dart';
import 'package:domain_book/domain_book.dart';
import 'package:networking/src/goat_response_array_model.dart';
import 'package:entity_book/src/models/book.dart';

import '../extension/nullable_generic.dart';

class FakeFetchBookUseCase implements FetchBooksUseCase {
  GoatResponseArrayModel<Book> defaultResult = GoatResponseArrayModel<Book>();

  Future<Result<GoatResponseArrayModel<Book>>> Function(
      {String? url, String? searchQuery})? stubCall;

  @override
  Future<Result<GoatResponseArrayModel<Book>>> call({
    String? url,
    String? searchQuery,
  }) {
    return stubCall.let((it) => it.call(url: url, searchQuery: searchQuery)) ??
        Future.value(Result.value(defaultResult));
  }
}
