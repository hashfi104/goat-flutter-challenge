import 'package:components/components.dart';
import 'package:components/src/snackbar/snackbar_xyz.dart';
import 'package:flutter/material.dart';

class Snackbar {
  static void showError(BuildContext context, String text, {Key? key}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          key: key,
          padding: const EdgeInsets.all(12),
          content: SnackbarXYZ(text),
          backgroundColor: ColorToken.backgroundError01,
          behavior: SnackBarBehavior.floating,
          duration: _getDuration(text)),
    );
  }

  static void showNeutral(BuildContext context, String text,
      {Key? key, String? action, VoidCallback? onActionTap}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          key: key,
          padding: const EdgeInsets.all(12),
          content: SnackbarXYZ(text, action: action, onActionTap: onActionTap),
          backgroundColor: ColorToken.backgroundHigh,
          behavior: SnackBarBehavior.floating,
          duration: _getDuration(text)),
    );
  }

  static Duration _getDuration(String text) {
    // snackbar duration automatically set based on text length
    return text.length <= 40
        ? const Duration(milliseconds: 2000)
        : const Duration(milliseconds: 3200);
  }
}
