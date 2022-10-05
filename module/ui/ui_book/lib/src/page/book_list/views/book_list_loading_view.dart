import 'package:components/components.dart';
import 'package:flutter/material.dart';

class BookListLoadingView extends StatelessWidget {
  final int count;

  static const listViewPadding = EdgeInsets.all(16);

  const BookListLoadingView({
    Key? key,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: listViewPadding,
      itemBuilder: ((context, index) {
        return const BookListPlaceholder();
      }),
      separatorBuilder: ((context, index) {
        return const SizedBox(height: 8);
      }),
      itemCount: count,
    );
  }
}

class BookListPlaceholder extends StatelessWidget {
  const BookListPlaceholder({
    Key? key,
  }) : super(key: key);

  static const containerAllPadding = EdgeInsets.all(16);
  static const double outerPaddingLeft = 16;
  static const double outerPaddingRight = 16;
  static const double containerPaddingLeft = 16;
  static const double containerPaddingRight = 16;
  static const double imageWidth = 80;
  static const double imageHeight = 120;
  static const double separatorWidth = 16;
  static const double borderLeftRightWidth = 2;

  @override
  Widget build(BuildContext context) {
    final double textWidth = MediaQuery.of(context).size.width -
        (outerPaddingLeft +
            outerPaddingRight +
            containerPaddingLeft +
            containerPaddingRight +
            imageWidth +
            borderLeftRightWidth);
    return Container(
      padding: containerAllPadding,
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorToken.borderSubtle,
        ),
        borderRadius: CornerToken.radius8,
        color: Colors.white,
      ),
      child: XYZShimmer(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LoadingPlaceholderXYZ.rectangle(
              width: imageWidth,
              height: imageHeight,
            ),
            const SizedBox(width: separatorWidth),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoadingPlaceholderXYZ.text(
                    width: textWidth,
                    textStyle: TypographyToken.body16Bold(),
                  ),
                  const SizedBox(height: 4),
                  LoadingPlaceholderXYZ.text(width: textWidth),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
