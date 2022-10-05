import 'package:components/components.dart';
import 'package:flutter/material.dart';

class BookListCard extends StatelessWidget {
  final String imageURL;
  final String title;
  final String author;
  final VoidCallback? onTapCard;

  const BookListCard({
    Key? key,
    required this.imageURL,
    required this.title,
    required this.author,
    this.onTapCard,
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
  static const titleMaxLines = 2;
  static const authorMaxLines = 3;

  static const noImageAsset = 'packages/ui_book/asset/image/no_book_image.jpeg';

  @override
  Widget build(BuildContext context) {
    final double textWidth = MediaQuery.of(context).size.width -
        (outerPaddingLeft +
            outerPaddingRight +
            containerPaddingLeft +
            containerPaddingRight +
            imageWidth +
            borderLeftRightWidth);

    final double contentWidth = MediaQuery.of(context).size.width -
        (outerPaddingLeft +
            outerPaddingRight +
            containerPaddingLeft +
            containerPaddingRight);

    return Tappable(
      onTap: onTapCard,
      child: Container(
        width: contentWidth,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorToken.borderSubtle,
          ),
          borderRadius: CornerToken.radius8,
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageURL.isNotEmpty)
              ImageXYZ.network(
                NetworkImage(imageURL),
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.fill,
              )
            else
              ImageXYZ.asset(
                noImageAsset,
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.fill,
              ),
            const SizedBox(width: 16),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                width: textWidth,
                height: 108,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextXYZ(
                      title,
                      style: TypographyToken.body16Bold(),
                      maxLines: titleMaxLines,
                    ),
                    const SizedBox(height: 4),
                    TextXYZ(
                      author,
                      maxLines: authorMaxLines,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
