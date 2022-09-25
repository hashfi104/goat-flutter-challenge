import 'package:components/components.dart';
import 'package:flutter/material.dart';

class EmptyStateXYZ extends StatelessWidget {
  final ImageHolder image;
  final String title;
  final String description;
  final TextSpan? customDescription;
  final int titleMaxLines;
  final int descriptionMaxLines;
  final ButtonXYZ? positiveAction;
  final ButtonXYZ? negativeAction;

  const EmptyStateXYZ({
    required this.image,
    required this.title,
    this.description = '',
    this.customDescription,
    Key? key,
    this.positiveAction,
    this.negativeAction,
    this.titleMaxLines = 2,
    this.descriptionMaxLines = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasAction = positiveAction != null || negativeAction != null;
    final positive = positiveAction;
    final negative = negativeAction;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageXYZ.imageHolder(image, width: 200, height: 124),
            const SizedBox(height: 24),
            TextXYZ(
              title,
              style: TypographyToken.subheading18(),
              maxLines: titleMaxLines,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            _descriptionWidget,
            hasAction ? const SizedBox(height: 32) : const SizedBox.shrink(),
            positive != null ? _getAction(positive) : const SizedBox.shrink(),
            positive != null && negative != null
                ? const SizedBox(height: 8)
                : const SizedBox.shrink(),
            negative != null ? _getAction(negative) : const SizedBox.shrink(),
          ],
        ));
  }

  Widget _getAction(ButtonXYZ button) {
    if (button.width != null) {
      return button;
    }
    return SizedBox(width: double.infinity, child: button);
  }

  Widget get _descriptionWidget {
    if (customDescription != null) {
      return TextXYZ.rich(
        customDescription,
        maxLines: descriptionMaxLines,
        textAlign: TextAlign.center,
      );
    }
    return TextXYZ(
      description,
      style: TypographyToken.body14(),
      maxLines: descriptionMaxLines,
      textAlign: TextAlign.center,
    );
  }
}
