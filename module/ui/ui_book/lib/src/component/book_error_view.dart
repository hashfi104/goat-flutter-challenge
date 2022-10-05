import 'package:assets/assets.dart';
import 'package:components/components.dart';
import 'package:flutter/material.dart';

class BookErrorView extends StatelessWidget {
  final String title;
  final String description;
  final String buttonTitle;
  final VoidCallback? onTapButton;

  const BookErrorView({
    Key? key,
    required this.title,
    required this.description,
    required this.buttonTitle,
    this.onTapButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: EmptyStateXYZ(
          image: ImageHolder.asset(XYZIllustrations.noInternet),
          title: title,
          description: description,
          positiveAction: ButtonXYZ.large(
            buttonTitle,
            onPressed: onTapButton,
          ),
        ),
      ),
    );
  }
}
