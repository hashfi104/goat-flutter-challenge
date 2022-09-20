import 'package:cubit_utils/cubit_utils.dart';
import 'package:domain_book/domain_book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_util/result_util.dart';
import 'package:ui_book/src/page/book_list/book_list_state.dart';

class BookListCubit extends Cubit<BookListState> with SafeEmitCubit {
  final FetchBooksUseCase _fetchBooksUseCase;

  BookListCubit({
    BookListState initialState = const BookListState(),
    required FetchBooksUseCase fetchBooksUseCase,
  })  : _fetchBooksUseCase = fetchBooksUseCase,
        super(initialState);

  void loadMoreBooks() {}

  Future<void> loadBooks({String? keyword}) async {
    final result = await _fetchBooksUseCase.call(
      url: state.nextUrl,
      searchQuery: keyword,
    );

    result.when(
      onValue: (result) {
        final books = result.results;
        if (state.loadingState == BookListLoadingState.loadMore) {
          if (result.next == null && result.previous != null) {
            emit(state.copyWith(
              loadingState: BookListLoadingState.stopLoadMore,
            ));
          } else {
            emit(state.copyWith(
              books: [
                ...state.books,
                ...books,
              ],
              loadingState: BookListLoadingState.stopLoadMore,
            ));
          }
        } else {
          emit(state.copyWith(
            books: books,
            loadingState: BookListLoadingState.success,
          ));
        }
      },
      onError: (error) {},
    );
  }
}
