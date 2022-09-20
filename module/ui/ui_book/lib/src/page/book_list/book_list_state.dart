// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:entity_book/entity_book.dart';

enum BookListLoadingState {
  fetch,
  success,
  error,
  loadMore,
  stopLoadMore,
}

class BookListState {
  final List<Book> books;
  final BookListLoadingState loadingState;
  final String? currentKeyword;
  final String? nextUrl;

  const BookListState({
    this.books = const [],
    this.loadingState = BookListLoadingState.fetch,
    this.currentKeyword,
    this.nextUrl,
  });

  BookListState copyWith({
    List<Book>? books,
    BookListLoadingState? loadingState,
    String? currentKeyword,
    String? nextUrl,
  }) {
    return BookListState(
      books: books ?? this.books,
      loadingState: loadingState ?? this.loadingState,
      currentKeyword: currentKeyword ?? this.currentKeyword,
      nextUrl: nextUrl ?? this.nextUrl,
    );
  }
}
