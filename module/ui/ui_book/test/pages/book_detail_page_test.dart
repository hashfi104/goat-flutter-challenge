// ignore_for_file: depend_on_referenced_packages

import 'package:async/src/result/result.dart';
import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_utils/test_utils.dart';
import 'package:ui_book/src/component/book_error_view.dart';
import 'package:ui_book/src/page/book_detail/views/book_detail_page_view.dart';
import 'package:ui_book/ui_book.dart';

import '../fakes/dummy_book.dart';
import '../fakes/fake_fetch_book_detail_usecase.dart';

void main() {
  final localeDelegate = BookLocaleDelegate();
  late FakeFetchBookDetailUseCase fetchBookDetailUseCase;

  setUp(() {
    fetchBookDetailUseCase = FakeFetchBookDetailUseCase();
  });

  void setUseCase({String bookID = '', required bool isSuccess}) {
    fetchBookDetailUseCase = fetchBookDetailUseCase
      ..stubCall = ({id}) {
        if (isSuccess) {
          return Future.value(Result.value(
            dummyBook(id: int.tryParse(bookID) ?? 1),
          ));
        }
        return Future.value(Result.error(Exception('error')));
      };
  }

  Widget pageBuilder({int id = 1, bool? isRequestSuccess}) {
    if (isRequestSuccess != null) {
      setUseCase(
        bookID: id.toString(),
        isSuccess: isRequestSuccess,
      );
    }

    return BookDetailPage(
      id: id.toString(),
      fetchBookDetailUseCase: fetchBookDetailUseCase,
    );
  }

  groupTest(BookDetailPage, () {
    testPage(
      'given loading state is fetch '
      'when render view '
      'then show loading view',
      pageBuilder: pageBuilder,
      localizationsDelegate: localeDelegate,
      then: (tester) async {
        expect(find.byKey(BookDetailPageView.loadingViewKey), findsOneWidget);
      },
    );

    testPage(
      'given fetch book detail is failed '
      'when render view '
      'then show error view',
      pageBuilder: () => pageBuilder(isRequestSuccess: false),
      localizationsDelegate: localeDelegate,
      then: (tester) async {
        // when
        await tester.pumpAndSettle();

        expect(find.byKey(BookDetailPageView.errorViewKey), findsOneWidget);
      },
    );

    testPage(
      'given fetch book detail is success '
      'when render view '
      'then show correct component',
      pageBuilder: () => pageBuilder(id: 2, isRequestSuccess: true),
      localizationsDelegate: localeDelegate,
      then: (tester) async {
        // when
        await tester.pumpAndSettle();

        // then
        final listView = find.byKey(BookDetailPageView.listViewKey);
        expect(listView, findsOneWidget);

        final expectedBook = dummyBook(id: 2);
        final expectedAuthor = expectedBook.authors.first;
        expect(
          find.descendant(
            of: listView,
            matching: find.byKey(BookDetailPageView.titleKey),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: listView,
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is TextXYZ && widget.text == expectedBook.title,
            ),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: listView,
            matching: find.byKey(
              BookDetailPageView.authorKey(expectedAuthor.name),
            ),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: listView,
            matching: find.byWidgetPredicate(
              (widget) {
                final authorString = expectedAuthor.name;
                return widget is TextXYZ && widget.text == authorString;
              },
            ),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: listView,
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is TextXYZ &&
                  widget.key == BookDetailPageView.downloadCountKey &&
                  widget.text.contains(expectedBook.downloadCount.toString()),
            ),
          ),
          findsOneWidget,
        );
        expect(
          find.byKey(BookDetailPageView.readOnlineButtonKey),
          findsOneWidget,
        );
      },
    );

    testPage(
      'given fetch book detail is failed '
      'when connection back to stable and reload view '
      'then show book detail component',
      pageBuilder: () => pageBuilder(isRequestSuccess: false),
      localizationsDelegate: localeDelegate,
      then: (tester) async {
        // when
        await tester.pumpAndSettle();

        expect(find.byKey(BookDetailPageView.errorViewKey), findsOneWidget);

        // reset connection
        setUseCase(isSuccess: true);
        await tester.tap(find.byKey(BookErrorView.buttonKey));
        await tester.pump();

        // then
        expect(find.byKey(BookDetailPageView.listViewKey), findsOneWidget);
      },
    );

    testPage(
      'given fetch book detail is success '
      'when tap read online button '
      'then launch method is called',
      pageBuilder: () => pageBuilder(id: 2, isRequestSuccess: true),
      localizationsDelegate: localeDelegate,
      then: (tester) async {
        // when
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(BookDetailPageView.readOnlineButtonKey));
        await tester.pump();

        // then
        isMethodCall('launch', arguments: '');
      },
    );
  });
}
