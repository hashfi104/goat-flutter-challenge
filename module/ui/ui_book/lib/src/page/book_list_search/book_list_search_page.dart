import 'package:domain_book/domain_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../book_list/book_list_cubit.dart';
import 'book_list_search_page_view.dart';

class BookListSearchPage extends StatelessWidget {
  final String? keyword;
  final FetchBooksUseCase fetchBooksUseCase;

  const BookListSearchPage({
    Key? key,
    this.keyword,
    required this.fetchBooksUseCase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookListCubit(fetchBooksUseCase: fetchBooksUseCase)
        ..setKeyword(keyword),
      child: const BookListSearchPageView(),
    );
  }
}
