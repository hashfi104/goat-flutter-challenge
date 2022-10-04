// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:entity_book/entity_book.dart';

enum BookDetailLoadingState {
  fetch,
  success,
  error,
}

enum BookDetailDataType {
  title,
  authors,
  bookshelves,
  download,
}

class BookDetailState {
  final Book? book;
  final BookDetailDataType selectedType;
  final List<BookDetailDataType> dataTypes;
  final BookDetailLoadingState loadingState;
  final String? errorMessage;

  const BookDetailState({
    this.book,
    this.selectedType = BookDetailDataType.title,
    this.dataTypes = const [],
    this.loadingState = BookDetailLoadingState.fetch,
    this.errorMessage,
  });

  BookDetailState copyWith({
    Book? book,
    BookDetailDataType? selectedType,
    List<BookDetailDataType>? dataTypes,
    BookDetailLoadingState? loadingState,
    String? errorMessage,
  }) {
    return BookDetailState(
      book: book ?? this.book,
      selectedType: selectedType ?? this.selectedType,
      dataTypes: dataTypes ?? this.dataTypes,
      loadingState: loadingState ?? this.loadingState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
