// ignore_for_file: depend_on_referenced_packages

import 'package:async/src/result/result.dart';
import 'package:components/components.dart';
import 'package:networking/src/goat_response_array_model.dart';
import 'package:entity_book/entity_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_utils/test_utils.dart';
import 'package:ui_book/src/component/book_error_view.dart';
import 'package:ui_book/src/page/book_list_search/book_list_search_page_view.dart';
import 'package:ui_book/ui_book.dart';

import '../fakes/dummy_book.dart';
import '../fakes/fake_fetch_book_list_usecase.dart';

const numberOfBooks = 10;

void main() {
  final localeDelegate = BookLocaleDelegate();
  late FakeFetchBookUseCase fetchBooksUseCase;
  late String searchKeyword;

  setUp(() {
    fetchBooksUseCase = FakeFetchBookUseCase();
  });

  GoatResponseArrayModel<Book> successResponse(int count) {
    return GoatResponseArrayModel<Book>(
        count: count,
        results: List.generate(
          count,
          (index) => dummyBook(id: index + 1),
        ));
  }

  void setUseCase(bool isSuccess) {
    fetchBooksUseCase = fetchBooksUseCase
      ..stubCall = ({searchQuery, url}) {
        if (isSuccess) {
          return Future.value(Result.value(successResponse(numberOfBooks)));
        }
        return Future.value(Result.error(Exception('error')));
      };
  }

  Widget pageBuilder({String? keyword, bool? isRequestSuccess}) {
    if (keyword != null) {
      searchKeyword = keyword;
    }

    if (isRequestSuccess != null) {
      setUseCase(isRequestSuccess);
    }

    return BookListSearchPage(
      keyword: keyword,
      fetchBooksUseCase: fetchBooksUseCase,
    );
  }

  groupTest(BookListSearchPage, () {
    testPage(
      'given loading state is fetch '
      'when render view '
      'then show loading view',
      pageBuilder: pageBuilder,
      localizationsDelegate: localeDelegate,
      then: (tester) async {
        expect(
          find.byKey(BookListSearchPageView.loadingViewKey),
          findsOneWidget,
        );
      },
    );

    testPage(
      'given fetch book list is failed '
      'when render view '
      'then show error view',
      pageBuilder: () => pageBuilder(isRequestSuccess: false),
      localizationsDelegate: localeDelegate,
      then: (tester) async {
        // when
        await tester.pumpAndSettle();

        expect(find.byKey(BookListSearchPageView.errorViewKey), findsOneWidget);
      },
    );

    testPage(
      'given fetch book list without keyword is success '
      'when render view '
      'then show book list view',
      pageBuilder: () => pageBuilder(isRequestSuccess: true),
      localizationsDelegate: localeDelegate,
      then: (tester) async {
        // when
        await tester.pumpAndSettle();

        // then
        expect(find.byKey(BookListSearchPageView.listViewKey), findsOneWidget);
        expect(
          find.byKey(BookListSearchPageView.bookContentKey(1)),
          findsOneWidget,
        );
      },
    );

    testPage(
      'given fetch book list with keyword is success '
      'when render view '
      'then show book list view and related keyword search result title',
      pageBuilder: () => pageBuilder(keyword: 'Bear', isRequestSuccess: true),
      localizationsDelegate: localeDelegate,
      then: (tester) async {
        // when
        await tester.pumpAndSettle();

        // then
        expect(find.byKey(BookListSearchPageView.listViewKey), findsOneWidget);
        expect(
          find.byKey(BookListSearchPageView.bookContentKey(1)),
          findsOneWidget,
        );
        expect(
          find.byWidgetPredicate((widget) =>
              widget is TextXYZ &&
              widget.key == BookListSearchPageView.searchResultTitleKey &&
              widget.textSpan!.toPlainText().contains(searchKeyword)),
          findsOneWidget,
        );
        expect(
          find.byWidgetPredicate((widget) =>
              widget is SearchBarXYZ && widget.text == searchKeyword),
          findsOneWidget,
        );
      },
    );

    testPage(
      'given fetch book list is failed '
      'when connection back to stable and reload view '
      'then show book list view',
      pageBuilder: () => pageBuilder(isRequestSuccess: false),
      localizationsDelegate: localeDelegate,
      then: (tester) async {
        // when
        await tester.pumpAndSettle();

        expect(find.byKey(BookListSearchPageView.errorViewKey), findsOneWidget);

        // reset connection
        setUseCase(true);
        await tester.tap(find.byKey(BookErrorView.buttonKey));
        await tester.pump();

        // then
        expect(find.byKey(BookListSearchPageView.listViewKey), findsOneWidget);
        expect(
          find.byKey(BookListSearchPageView.bookContentKey(1)),
          findsOneWidget,
        );
      },
    );
  });
}
