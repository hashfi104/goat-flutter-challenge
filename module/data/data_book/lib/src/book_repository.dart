import 'package:data_book/src/book_api_datasource.dart';
import 'package:entity_book/entity_book.dart';
import 'package:networking/src/network_request.dart';

class BookRepository
    with BookApiDataSource
    implements FetchBooksInterface, FetchBookDetailInterface {
  @override
  NetworkRequest networkRequest;

  BookRepository(this.networkRequest);
}
