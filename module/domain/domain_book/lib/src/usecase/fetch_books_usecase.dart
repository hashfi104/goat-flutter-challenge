// ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:entity_book/entity_book.dart';
import 'package:networking/networking.dart';

class FetchBooksUseCase {
  final FetchBooksInterface _fetchBooks;

  const FetchBooksUseCase(this._fetchBooks);

  Future<Result<GoatResponseArrayModel<Book>>> call({
    String? url,
    String? searchQuery,
  }) {
    return _fetchBooks.fetchBooks(
      url: url,
      searchQuery: searchQuery,
    );
  }
}
