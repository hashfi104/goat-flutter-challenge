import 'dart:ui';

import 'package:components/components.dart';
import 'package:entity_book/entity_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:ui_book/src/component/book_error_view.dart';
import 'package:ui_book/src/locale/book_locale.dart';
import 'package:ui_book/src/page/book_detail/book_detail_cubit.dart';
import 'package:ui_book/src/page/book_detail/views/book_detail_loading_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../book_detail_state.dart';

class BookDetailPageView extends StatelessWidget {
  final String id;

  const BookDetailPageView({
    Key? key,
    required this.id,
  }) : super(key: key);

  static const noImageAsset = 'packages/ui_book/asset/image/no_book_image.jpeg';
  static const double imageWidth = 150;
  static const double imageHeight = 200;
  static const double imagePlaceHolderSize = 250;

  // Key
  static const loadingViewKey = Key('loading-view');
  static const errorViewKey = Key('error-view');
  static const listViewKey = Key('list-view');
  static const imageKey = Key('image');
  static const titleKey = Key('title');
  static Key authorKey(String name) => Key('author-$name');
  static const downloadCountKey = Key('download-count');
  static const readOnlineButtonKey = Key('read-online-button');
  static const backButtonKey = Key('back-button');

  @override
  Widget build(BuildContext context) {
    final locale = GoatLocale.of<BookLocale>(context);

    return Scaffold(
      appBar: NavBarXYZ(
        title: locale.bookDetail,
        onNavigationTap: () => GoRouter.of(context).pop(),
        keyNavigationIcon: BookDetailPageView.backButtonKey,
      ),
      body: BlocBuilder<BookDetailCubit, BookDetailState>(
          builder: (context, state) {
        final book = state.book;
        final bookImage = book?.formats.image;

        if (state.loadingState == BookDetailLoadingState.fetch) {
          return const BookDetailLoadingView(
            key: BookDetailPageView.loadingViewKey,
          );
        }

        if (state.loadingState == BookDetailLoadingState.error) {
          return BookErrorView(
            key: BookDetailPageView.errorViewKey,
            title: locale.somethingWrong,
            description: state.errorMessage ?? '',
            buttonTitle: locale.retry,
            onTapButton: () =>
                context.read<BookDetailCubit>().fetchBookDetail(id),
          );
        }

        if (book != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  key: listViewKey,
                  children: [
                    _imageWidget(bookImage),
                    const SizedBox(height: 24),
                    _titleWidget(context, book.title),
                    const SizedBox(height: 16),
                    ..._authorsWidget(context, book.authors),
                    const SizedBox(height: 16),
                    _downloadCountWidget(locale, book.downloadCount),
                  ],
                ),
              ),
              ButtonXYZ.large(
                locale.readOnline,
                key: readOnlineButtonKey,
                onPressed: () async {
                  _launchUrl(book.formats.textHtml ?? '');
                },
              )
            ],
          );
        }

        return const SizedBox.shrink();
      }),
    );
  }

  Widget _imageWidget(String? bookImage) {
    return Container(
      key: imageKey,
      width: double.infinity,
      height: imagePlaceHolderSize,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: bookImage != null
              ? NetworkImage(bookImage)
              : const AssetImage(noImageAsset) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Center(
          child: bookImage != null
              ? ImageXYZ.network(
                  NetworkImage(bookImage),
                  key: UniqueKey(),
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.fill,
                )
              : ImageXYZ.asset(
                  noImageAsset,
                  key: UniqueKey(),
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.fill,
                ),
        ),
      ),
    );
  }

  Widget _titleWidget(BuildContext context, String title) {
    return Tappable(
      key: titleKey,
      onTap: () => _goToSearhPage(context, title),
      child: TextXYZ(
        title,
        style: TypographyToken.body16Bold(),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Widget> _authorsWidget(BuildContext context, List<Person> authors) {
    if (authors.isEmpty) {
      return [
        const SizedBox.shrink(),
      ];
    }

    return authors.map((author) {
      final lifeYear = author.birthYear != null
          ? ' (${author.birthYear} - ${author.deathYear})'
          : '';
      return Column(
        children: [
          Tappable(
            key: authorKey(author.name),
            onTap: () => _goToSearhPage(context, author.name),
            child: TextXYZ(
              '${author.name}$lifeYear',
              style: TypographyToken.body14(),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
        ],
      );
    }).toList();
  }

  Widget _downloadCountWidget(BookLocale locale, int count) {
    return TextXYZ(
      locale.downloadCount(count),
      key: downloadCountKey,
      style: TypographyToken.caption12(),
      textAlign: TextAlign.center,
    );
  }

  void _goToSearhPage(BuildContext context, String keyword) {
    context.pushNamed(
      'search_result',
      queryParams: {'keyword': keyword},
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
