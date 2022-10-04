import 'package:assets/assets.dart';
import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:ui_book/src/page/book_list/views/book_list_error_view.dart';
import 'package:ui_book/src/page/book_list/views/book_list_loading_view.dart';

import '../../../component/book_list_card.dart';
import '../../../locale/book_locale.dart';
import '../book_list_cubit.dart';
import '../book_list_state.dart';

class BookListPageView extends StatefulWidget {
  const BookListPageView({
    Key? key,
  }) : super(key: key);

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
          MenuBarItem(id: 'search', icon: XYZIcons.search),
        ],
        onMenuTap: (menu) {
          if (menu.id == 'search') {
            context.pushNamed('search_result');
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
      return const BookListLoadingView(count: 5);
    }

    if (state.loadingState == BookListLoadingState.error) {
      return const BookListErrorView();
    }

    return RefreshIndicator(
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          return loadMore ? _onScrolled(context, notification) : false;
        },
        child: ListView.separated(
          controller: controller,
          padding: const EdgeInsets.all(16),
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
              (state.loadingState == BookListLoadingState.loadMore ? 1 : 0),
        ),
      ),
      onRefresh: () => context.read<BookListCubit>().onRefresh(),
    );
  }
}
