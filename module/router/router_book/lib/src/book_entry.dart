import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_locator/service_locator.dart';
import 'package:ui_book/ui_book.dart';

class BookEntry implements RouteBase {
  final ServiceLocator locator;

  BookEntry({
    required this.locator,
  });

  @override
  List<RouteBase> get routes {
    return [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => BookListPage(
          fetchBooksUseCase: locator(),
        ),
      ),
      GoRoute(
        name: 'search_result',
        path: '/search',
        builder: (
          BuildContext context,
          GoRouterState state,
        ) {
          return BookListSearchPage(
            fetchBooksUseCase: locator(),
            keyword: state.queryParams['keyword'] ?? '',
          );
        },
      ),
      GoRoute(
        name: 'book_detail',
        path: '/detail/:id',
        builder: (
          BuildContext context,
          GoRouterState state,
        ) {
          return BookDetailPage(
            id: state.params['id'] ?? '',
            fetchBookDetailUseCase: locator(),
          );
        },
      ),
    ];
  }
}
