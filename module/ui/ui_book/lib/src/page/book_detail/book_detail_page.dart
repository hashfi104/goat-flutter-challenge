import 'package:domain_book/domain_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_book/src/page/book_detail/book_detail_cubit.dart';
import 'package:ui_book/src/page/book_detail/views/book_detail_page_view.dart';

class BookDetailPage extends StatelessWidget {
  final String id;
  final FetchBookDetailUseCase fetchBookDetailUseCase;

  const BookDetailPage({
    Key? key,
    required this.id,
    required this.fetchBookDetailUseCase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            BookDetailCubit(fetchBookDetailUseCase: fetchBookDetailUseCase)
              ..fetchBookDetail(id),
        child: const BookDetailPageView());
  }
}
