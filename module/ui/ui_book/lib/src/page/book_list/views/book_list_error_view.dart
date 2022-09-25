import 'package:assets/assets.dart';
import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import 'package:ui_book/src/locale/book_locale.dart';
import 'package:ui_book/src/page/book_list/book_list_cubit.dart';

class BookListErrorView extends StatelessWidget {
  const BookListErrorView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = GoatLocale.of<BookLocale>(context);
    return Container(
      color: Colors.white,
      child: Center(
        child: EmptyStateXYZ(
          image: ImageHolder.asset(XYZIllustrations.noInternet),
          title: locale.somethingWrong,
          description: locale.checkConnection,
          positiveAction: ButtonXYZ.large(
            locale.retry,
            onPressed: () {
              context.read<BookListCubit>().onRefresh();
            },
          ),
        ),
      ),
    );
  }
}
