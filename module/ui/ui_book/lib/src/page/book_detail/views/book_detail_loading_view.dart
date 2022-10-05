import 'package:components/components.dart';
import 'package:flutter/material.dart';

class BookDetailLoadingView extends StatelessWidget {
  static const double imagePlaceHolderSize = 250;
  static const double paddingLeftRight = 32;
  static const double placeholderDetailHeight = 32;
  static const detailCount = 4;

  const BookDetailLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const XYZShimmer(
          child: LoadingPlaceholderXYZ.rectangle(
            width: double.infinity,
            height: imagePlaceHolderSize,
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return XYZShimmer(
                child: LoadingPlaceholderXYZ.rectangle(
                  width: MediaQuery.of(context).size.width - paddingLeftRight,
                  height: placeholderDetailHeight,
                  radius: CornerToken.radius8,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 16);
            },
            itemCount: detailCount,
          ),
        ),
      ],
    );
  }
}
