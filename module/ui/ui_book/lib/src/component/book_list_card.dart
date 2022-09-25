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

  static const noImageAsset = 'packages/ui_book/asset/image/no_book_image.jpeg';

  @override
  Widget build(BuildContext context) {
    final double textWidth = MediaQuery.of(context).size.width - 162;
    return Tappable(
      onTap: onTapCard,
      child: Container(
        width: MediaQuery.of(context).size.width - 64,
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
                width: 80,
                height: 120,
                fit: BoxFit.fill,
              )
            else
              ImageXYZ.asset(
                noImageAsset,
                width: 80,
                height: 120,
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
                      maxLines: 3,
                    ),
                    const SizedBox(height: 4),
                    TextXYZ(
                      author,
                      maxLines: 2,
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
