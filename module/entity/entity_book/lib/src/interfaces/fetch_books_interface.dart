// ignore: depend_on_referenced_packages
import 'package:async/async.dart';

import 'package:networking/networking.dart';

import '../models/book.dart';

abstract class FetchBooksInterface {
  static const defaultPath = '/books';

  Future<Result<GoatResponseArrayModel<Book>>> fetchBooks({
    String? url,
    String? searchQuery,
  });
}
