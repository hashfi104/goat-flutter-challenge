import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../../locale/book_locale.dart';

class BookListPageView extends StatefulWidget {
  const BookListPageView({
    Key? key,
  }) : super(key: key);

  @override
  State<BookListPageView> createState() => _BookListPageViewState();
}

class _BookListPageViewState extends State<BookListPageView> {
  @override
  Widget build(BuildContext context) {
    final locale = GoatLocale.of<BookLocale>(context);

    return Scaffold(
      appBar: NavBarXYZ(title: locale.bookListTitle),
    );
  }
}
