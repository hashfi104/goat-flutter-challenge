import 'package:cubit_utils/cubit_utils.dart';
import 'package:domain_book/domain_book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_book/src/page/book_detail/book_detail_state.dart';
import 'package:result_util/result_util.dart';

class BookDetailCubit extends Cubit<BookDetailState> with SafeEmitCubit {
  final FetchBookDetailUseCase _fetchBookDetailUseCase;

  BookDetailCubit({
    BookDetailState initialState = const BookDetailState(),
    required FetchBookDetailUseCase fetchBookDetailUseCase,
  })  : _fetchBookDetailUseCase = fetchBookDetailUseCase,
        super(initialState);

  Future<void> fetchBookDetail(String id) async {
    final result = await _fetchBookDetailUseCase.call(id: id);

    result.when(
      onValue: (book) {
        List<BookDetailDataType> dataTypes = [BookDetailDataType.title];

        // Add authors if not empty
        if (book.authors.isNotEmpty) {
          dataTypes.add(BookDetailDataType.authors);
        }

        // Add bookshelves if not empty
        if (book.bookshelves.isNotEmpty) {
          dataTypes.add(BookDetailDataType.bookshelves);
        }

        // Add downloads
        dataTypes.add(BookDetailDataType.download);

        emit(state.copyWith(
          loadingState: BookDetailLoadingState.success,
          book: book,
          dataTypes: dataTypes,
        ));
      },
      onError: (error) {
        if (error is Exception) {
          emit(state.copyWith(
            loadingState: BookDetailLoadingState.error,
            errorMessage: error.toString(),
          ));
        }
      },
    );
  }

  void updateSelectedType(BookDetailDataType type) {
    emit(state.copyWith(selectedType: type));
  }
}
