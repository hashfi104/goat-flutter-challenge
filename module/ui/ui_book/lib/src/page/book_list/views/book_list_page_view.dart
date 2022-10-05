import 'package:assets/assets.dart';
import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:ui_book/src/page/book_list/views/book_list_loading_view.dart';

import '../../../component/book_error_view.dart';
import '../../../component/book_list_card.dart';
import '../../../locale/book_locale.dart';
import '../book_list_cubit.dart';
import '../book_list_state.dart';

class BookListPageView extends StatefulWidget {
  const BookListPageView({
    Key? key,
  }) : super(key: key);

  static const loadingItemCount = 5;
  static const extraLoadingCount = 1;
  static const nonExtraLoadingCount = 0;

  // Push named
  static const searchResult = 'search_result';
  static const bookDetail = 'book_detail';

  // Key
  static const loadingViewKey = Key('loading-view');
  static const errorViewKey = Key('error-view');
  static const listViewKey = Key('list-view');
  static Key bookContentKey(int id) {
    return Key('book-$id');
  }

  static const loadMoreKey = Key('load-more');
  static const searchMenuKey = 'search-menu';

  @override
  State<BookListPageView> createState() => _BookListPageViewState();
}

class _BookListPageViewState extends State<BookListPageView> {
  late ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
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

    return Scaffold(
      appBar: NavBarXYZ(
        title: locale.bookListTitle,
        menus: [
          MenuBarItem(
            id: BookListPageView.searchMenuKey,
            icon: XYZIcons.search,
          ),
        ],
        onMenuTap: (menu) {
          if (menu.id == BookListPageView.searchMenuKey) {
            context.pushNamed(BookListPageView.searchResult);
          }
        },
      ),
      body: BlocBuilder<BookListCubit, BookListState>(
        builder: (context, state) {
          return _childWidget(context, locale, state);
        },
      ),
    );
  }

  Widget _childWidget(
    BuildContext context,
    BookLocale locale,
    BookListState state,
  ) {
    final loadMore = state.loadingState != BookListLoadingState.stopLoadMore;

    if (state.loadingState == BookListLoadingState.fetch) {
      return const BookListLoadingView(
        key: BookListPageView.loadingViewKey,
        count: BookListPageView.loadingItemCount,
      );
    }

    if (state.loadingState == BookListLoadingState.error) {
      return BookErrorView(
        key: BookListPageView.errorViewKey,
        title: locale.somethingWrong,
        description: locale.checkConnection,
        buttonTitle: locale.retry,
        onTapButton: () => context.read<BookListCubit>().onRefresh(),
      );
    }

    return RefreshIndicator(
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          return loadMore ? _onScrolled(context, notification) : false;
        },
        child: ListView.separated(
          key: BookListPageView.listViewKey,
          controller: controller,
          padding: const EdgeInsets.all(16),
          itemBuilder: ((context, index) {
            if (index == state.books.length) {
              return const BookListPlaceholder(
                key: BookListPageView.loadMoreKey,
              );
            }

            final book = state.books[index];
            final authors = book.authors;
            return BookListCard(
              key: BookListPageView.bookContentKey(book.id),
              imageURL: book.formats.image ?? '',
              title: book.title,
              author: authors.isNotEmpty ? authors.first.name : '',
              onTapCard: () => context.pushNamed(
                BookListPageView.bookDetail,
                params: {'id': book.id.toString()},
              ),
            );
          }),
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemCount: state.books.length +
              (state.loadingState == BookListLoadingState.loadMore
                  ? BookListPageView.extraLoadingCount
                  : BookListPageView.nonExtraLoadingCount),
        ),
      ),
      onRefresh: () => context.read<BookListCubit>().onRefresh(),
    );
  }
}
