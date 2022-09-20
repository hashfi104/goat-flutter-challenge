import 'package:domain_book/src/usecase/fetch_book_detail_usecase.dart';
import 'package:domain_book/src/usecase/fetch_books_usecase.dart';
import 'package:service_locator/service_locator.dart';

class DomainBookRegistrar implements Registrar {
  @override
  Future<void> register(ServiceLocator locator) async {
    locator.registerFactory(() => FetchBooksUseCase(locator()));
    locator.registerFactory(() => FetchBookDetailUseCase(locator()));
  }
}
