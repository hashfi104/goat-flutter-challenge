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

  void loadMoreBooks() {
    emit(state.copyWith(loadingState: BookListLoadingState.loadMore));
    loadBooks();
  }

  Future<void> loadBooks() async {
    final prevUrl = state.prevUrl ?? '';
    final nextUrl = state.nextUrl ?? '';

    if (nextUrl.isEmpty && prevUrl.isNotEmpty) {
      return;
    }

    final result = await _fetchBooksUseCase.call(
      url: nextUrl.isEmpty ? null : nextUrl,
      searchQuery: state.currentKeyword,
    );

    result.when(
      onValue: (result) {
        final books = result.results;
        if (result.next == null && result.previous != null) {
          emit(state.copyWith(
            loadingState: BookListLoadingState.stopLoadMore,
            prevUrl: result.previous,
            nextUrl: '',
          ));
        } else {
          emit(state.copyWith(
            books: [
              ...state.books,
              ...books,
            ],
            loadingState: BookListLoadingState.success,
            prevUrl: result.previous,
            nextUrl: result.next,
          ));
        }
      },
      onError: (error) {
        emit(state.copyWith(loadingState: BookListLoadingState.error));
      },
    );
  }

  Future<void> onRefresh() async {
    emit(state.copyWith(prevUrl: '', nextUrl: ''));
    await loadBooks();
  }

  void setKeyword(String keyword) {
    emit(state.copyWith(currentKeyword: keyword));
  }
}
