// ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:entity_book/src/models/book.dart';

abstract class FetchBookDetailInterface {
  static const path = '/books/:id';

  Future<Result<Book>> fetchBookDetail({
    required String id,
  });
}
