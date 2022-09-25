import 'package:components/components.dart';
import 'package:flutter/material.dart';

class BookListLoadingView extends StatelessWidget {
  final int count;

  const BookListLoadingView({
    Key? key,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
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

  @override
  Widget build(BuildContext context) {
    final double textWidth = MediaQuery.of(context).size.width - 162;
    return Container(
      padding: const EdgeInsets.all(16),
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
              width: 80,
              height: 120,
            ),
            const SizedBox(width: 16),
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
