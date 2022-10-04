import 'dart:async';
import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:ui_book/src/page/book_list/views/book_list_error_view.dart';
import 'package:ui_book/src/page/book_list/views/book_list_loading_view.dart';

import '../../component/book_list_card.dart';
import '../../locale/book_locale.dart';
import '../book_list/book_list_cubit.dart';
import '../book_list/book_list_state.dart';

class BookListSearchPageView extends StatefulWidget {
  const BookListSearchPageView({
    Key? key,
  }) : super(key: key);

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
                  const Duration(seconds: 2),
                  () => {
                    context.read<BookListCubit>().setKeyword(keyword),
                    FocusScope.of(context).unfocus()
                  },
                );
              },
              cancelSearchText: locale.cancel,
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
      return const BookListLoadingView(count: 5);
    }

    if (state.loadingState == BookListLoadingState.error) {
      return const BookListErrorView();
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
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                return loadMore ? _onScrolled(context, notification) : false;
              },
              child: ListView.separated(
                controller: controller,
                padding: EdgeInsets.fromLTRB(
                    16, keyword.isNotEmpty ? 0 : 16, 16, 16),
                itemBuilder: ((context, index) {
                  if (index == state.books.length) {
                    return const BookListPlaceholder();
                  }

                  final book = state.books[index];
                  final authors = book.authors;
                  return BookListCard(
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
                        ? 1
                        : 0),
              ),
            ),
            onRefresh: () => context.read<BookListCubit>().onRefresh(),
          ),
        ),
      ],
    );
  }
}
