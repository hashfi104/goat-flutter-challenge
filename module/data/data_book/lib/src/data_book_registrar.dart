import 'package:data_book/src/book_repository.dart';
import 'package:entity_book/entity_book.dart';
import 'package:service_locator/service_locator.dart';

class DataBookRegistrar implements Registrar {
  @override
  Future<void> register(ServiceLocator locator) async {
    locator.registerFactory<BookRepository>(
      () => BookRepository(locator()),
    );
    locator.registerFactory<FetchBooksInterface>(
      () => locator<BookRepository>(),
    );
    locator.registerFactory<FetchBookDetailInterface>(
      () => locator<BookRepository>(),
    );
  }
}
