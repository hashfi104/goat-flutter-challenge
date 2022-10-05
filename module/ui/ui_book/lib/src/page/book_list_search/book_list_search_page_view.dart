import 'dart:async';
import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:ui_book/src/component/book_error_view.dart';
import 'package:ui_book/src/page/book_list/views/book_list_loading_view.dart';

import '../../component/book_list_card.dart';
import '../../locale/book_locale.dart';
import '../book_list/book_list_cubit.dart';
import '../book_list/book_list_state.dart';

class BookListSearchPageView extends StatefulWidget {
  const BookListSearchPageView({
    Key? key,
  }) : super(key: key);

  static const searchDebounceTime = 2;
  static const loadingItemCount = 5;
  static const extraLoadingCount = 1;
  static const nonExtraLoadingCount = 0;

  // Push named
  static const searchResult = 'search_result';
  static const bookDetail = 'book_detail';

  // Key
  static const backButtonKey = Key('back-button');
  static const searchResultTitleKey = Key('search-result-title');
  static const loadingViewKey = Key('loading-view');
  static const errorViewKey = Key('error-view');
  static const listViewKey = Key('list-view');
  static Key bookContentKey(int id) {
    return Key('book-$id');
  }

  static const loadMoreKey = Key('load-more');

  @override
  State<BookListSearchPageView> createState() => _BookListSearchPageViewState();
}

class _BookListSearchPageViewState extends State<BookListSearchPageView> {
  late ScrollController controller;
  Timer? _searchDebounce;

  @override
  void initState() {
    controller = ScrollController();
    if (_searchDebounce?.isActive == true) {
      _searchDebounce?.cancel();
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool _onScrolled(BuildContext context, ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (controller.position.extentAfter == 0) {
        context.read<BookListCubit>().loadMoreBooks();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final locale = GoatLocale.of<BookLocale>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: BlocBuilder<BookListCubit, BookListState>(
        builder: ((context, state) {
          final keyword = state.currentKeyword ?? '';
          return Scaffold(
            appBar: NavBarSearchXYZ(
              onNavigationTap: () => GoRouter.of(context).pop(),
              searchAutoFocus: keyword.isEmpty,
              searchPlaceholder: locale.searchBooks,
              searchText: keyword,
              onSearchTextChanged: (keyword) {
                if (_searchDebounce?.isActive == true) {
                  _searchDebounce?.cancel();
                }
                _searchDebounce = Timer(
                  const Duration(
                    seconds: BookListSearchPageView.searchDebounceTime,
                  ),
                  () => {
                    context.read<BookListCubit>().setKeyword(keyword),
                    FocusScope.of(context).unfocus()
                  },
                );
              },
              cancelSearchText: locale.cancel,
              keyNavigationIcon: BookListSearchPageView.backButtonKey,
            ),
            body: _childWidget(context, locale, state),
          );
        }),
      ),
    );
  }

  Widget _childWidget(
    BuildContext context,
    BookLocale locale,
    BookListState state,
  ) {
    final loadMore = state.loadingState != BookListLoadingState.stopLoadMore;
    final keyword = state.currentKeyword ?? '';

    if (state.loadingState == BookListLoadingState.fetch) {
      return const BookListLoadingView(
        key: BookListSearchPageView.loadingViewKey,
        count: BookListSearchPageView.loadingItemCount,
      );
    }

    if (state.loadingState == BookListLoadingState.error) {
      return BookErrorView(
        key: BookListSearchPageView.errorViewKey,
        title: locale.somethingWrong,
        description: locale.checkConnection,
        buttonTitle: locale.retry,
        onTapButton: () => context.read<BookListCubit>().onRefresh(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (keyword.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextXYZ.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: locale.searchResult,
                    style: TypographyToken.caption12(),
                  ),
                  TextSpan(
                    text: '"${state.currentKeyword}"',
                    style: TypographyToken.caption12Bold(),
                  )
                ],
              ),
              key: BookListSearchPageView.searchResultTitleKey,
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                return loadMore ? _onScrolled(context, notification) : false;
              },
              child: ListView.separated(
                key: BookListSearchPageView.listViewKey,
                controller: controller,
                padding: EdgeInsets.fromLTRB(
                    16, keyword.isNotEmpty ? 0 : 16, 16, 16),
                itemBuilder: ((context, index) {
                  if (index == state.books.length) {
                    return const BookListPlaceholder(
                      key: BookListSearchPageView.loadMoreKey,
                    );
                  }

                  final book = state.books[index];
                  final authors = book.authors;
                  return BookListCard(
                    key: BookListSearchPageView.bookContentKey(book.id),
                    imageURL: book.formats.image ?? '',
                    title: book.title,
                    author: authors.isNotEmpty ? authors.first.name : '',
                    onTapCard: () => context.pushNamed(
                      'book_detail',
                      params: {'id': book.id.toString()},
                    ),
                  );
                }),
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: state.books.length +
                    (state.loadingState == BookListLoadingState.loadMore
                        ? BookListSearchPageView.extraLoadingCount
                        : BookListSearchPageView.nonExtraLoadingCount),
              ),
            ),
            onRefresh: () => context.read<BookListCubit>().onRefresh(),
          ),
        ),
      ],
    );
  }
}
