// ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:entity_book/entity_book.dart';

class FetchBookDetailUseCase {
  final FetchBookDetailInterface _fetchBookDetailInterface;

  FetchBookDetailUseCase(this._fetchBookDetailInterface);

  Future<Result<Book>> call({
    required String id,
  }) {
    return _fetchBookDetailInterface.fetchBookDetail(id: id);
  }
}
