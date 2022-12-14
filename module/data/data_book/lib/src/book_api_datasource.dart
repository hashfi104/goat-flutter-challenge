import 'package:entity_book/entity_book.dart';
import 'package:networking/networking.dart';

// ignore: depend_on_referenced_packages
import 'package:async/async.dart';

mixin BookApiDataSource
    implements FetchBooksInterface, FetchBookDetailInterface {
  NetworkRequest get networkRequest;

  @override
  Future<Result<GoatResponseArrayModel<Book>>> fetchBooks({
    String? url,
    String? searchQuery,
  }) async {
    final finalUrl = Uri.parse(
      url ?? '${networkRequest.baseUrl}${FetchBooksInterface.defaultPath}',
    );
    final Map<String, String> queryParam = Map.of(finalUrl.queryParameters);

    if (searchQuery != null) {
      queryParam['search'] = searchQuery;
    }

    return networkRequest.getRequestArray(
      Book.fromJson,
      path: FetchBooksInterface.defaultPath,
      queryParameters: queryParam,
    );
  }

  @override
  Future<Result<Book>> fetchBookDetail({required String id}) {
    final finalPath = FetchBookDetailInterface.path.replaceAll(':id', id);
    return networkRequest.getRequest(
      Book.fromJson,
      path: finalPath,
      errorPayloadKey: 'detail',
    );
  }
}
