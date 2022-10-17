import 'package:components/components.dart';
import 'package:flutter/material.dart';

class SnackbarXYZ extends StatelessWidget {
  final String text;
  final String? action;
  final VoidCallback? onActionTap;
  final Key? keyAction;

  static const keyValueText = "Snackbar_Text";
  static const keyValueAction = "Snackbar_Action";

  const SnackbarXYZ(
    this.text, {
    Key? key,
    this.action,
    this.onActionTap,
    this.keyAction = const Key(keyValueAction),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actionText = action;
    final content = TextXYZ(
      text,
      key: const Key(keyValueText),
      style: TypographyToken.body14(color: ColorToken.textInverse),
      maxLines: 3,
    );

    if (actionText != null) {
      return Row(
        children: [
          Expanded(child: content),
          const SizedBox(width: 12),
          Tappable(
            key: keyAction,
            borderRadius: CornerToken.radius4,
            onTap: onActionTap,
            child: Padding(
              // add extra padding for better touch areaAV
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 80),
                child: TextXYZ(
                  actionText,
                  maxLines: 1,
                  style: TypographyToken.body14Bold(
                      color: ColorToken.link01Inverse),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return content;
  }
}
