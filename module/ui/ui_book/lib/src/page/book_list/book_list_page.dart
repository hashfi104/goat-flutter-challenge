import 'package:domain_book/domain_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_book/src/page/book_list/book_list_cubit.dart';

import 'views/book_list_page_view.dart';

class BookListPage extends StatelessWidget {
  final FetchBooksUseCase fetchBooksUseCase;

  const BookListPage({
    Key? key,
    required this.fetchBooksUseCase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BookListCubit(fetchBooksUseCase: fetchBooksUseCase)..loadBooks(),
      child: const BookListPageView(),
    );
  }
}
