import 'package:components/components.dart';
import 'package:flutter/material.dart';

import '../icon/icon_position.dart';

class ButtonLink extends StatelessWidget {
  final String text;
  final BazaarLinkStyle? style;
  final bool enabled;
  final VoidCallback? onTap;
  final ImageHolder? icon;
  final double iconSize;
  final IconPosition iconPosition;
  final Key? keyButtonLink;

  static const keyButtonLinkText = "button-link-text";
  static const keyButtonLinkLeftIcon = "button-link-left-icon";
  static const keyButtonLinkRightIcon = "button-link-right-icon";
  static const keyValueButtonLink = "button-link";

  /// [text] Button link text
  /// [style] Button link style
  /// [enabled] Button link state enabled or disabled
  /// [onTap] Button link listener
  /// [icon] Button link icon
  /// [iconSize] Button link icon size
  /// [iconPosition] Button link icon position left or right
  const ButtonLink(
    this.text, {
    Key? key,
    this.style,
    this.enabled = true,
    this.onTap,
    this.icon,
    this.iconSize = IconXYZ.sizeMinor,
    this.iconPosition = IconPosition.left,
    this.keyButtonLink = const Key(keyValueButtonLink),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final linkStyle =
        style ?? BazaarLinkStyle.primary(style: TypographyToken.body14Bold());
    return Tappable(
      key: keyButtonLink,
      onTap: enabled ? onTap : null,
      borderRadius: CornerToken.radius4,
      child: Padding(
        // add extra padding for better touch areaAV
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (icon != null && iconPosition == IconPosition.left) ...[
              Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconXYZ.imageHolder(
                    icon,
                    color: _getColor(linkStyle),
                    size: iconSize,
                    key: const Key(keyButtonLinkLeftIcon),
                  ))
            ],
            TextXYZ(text,
                style: linkStyle.textStyle.apply(color: _getColor(linkStyle)),
                key: const Key(keyButtonLinkText)),
            if (icon != null && iconPosition == IconPosition.right) ...[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconXYZ.imageHolder(
                  icon,
                  color: _getColor(linkStyle),
                  size: iconSize,
                  key: const Key(keyButtonLinkRightIcon),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Color _getColor(BazaarLinkStyle linkStyle) {
    if (enabled) {
      return linkStyle.textColorEnabled;
    } else {
      return linkStyle.textColorDisabled;
    }
  }
}

/// Link style for [ButtonLinkAV] and hyperlink [TextSpan]
/// * Use [textStyle] to get the [TextStyle] from [BazaarLinkStyle]
class BazaarLinkStyle {
  final TextStyle textStyle;
  final TextDecoration? decoration;
  final Color textColorEnabled;
  final Color textColorDisabled;

  const BazaarLinkStyle(this.textStyle, this.decoration, this.textColorEnabled,
      this.textColorDisabled);

  BazaarLinkStyle apply(TextStyle style) {
    return BazaarLinkStyle(
        style.apply(color: textColorEnabled, decoration: decoration),
        decoration,
        textColorEnabled,
        textColorDisabled);
  }

  static BazaarLinkStyle primary({TextStyle? style}) {
    if (style != null && style != _primary.textStyle) {
      return _primary.apply(style);
    }
    return _primary;
  }

  static BazaarLinkStyle secondary({TextStyle? style}) {
    if (style != null && style != _secondary.textStyle) {
      return _secondary.apply(style);
    }
    return _secondary;
  }

  static BazaarLinkStyle white({TextStyle? style}) {
    if (style != null && style != _white.textStyle) {
      return _white.apply(style);
    }
    return _white;
  }

  static final BazaarLinkStyle _primary = BazaarLinkStyle(
      TypographyToken.body14Bold(color: ColorToken.link01, decoration: null),
      null,
      ColorToken.link01,
      ColorToken.link01Disabled);

  static final BazaarLinkStyle _secondary = BazaarLinkStyle(
      TypographyToken.body14Bold(
          color: ColorToken.textSecondary,
          decoration: TextDecoration.underline),
      null,
      ColorToken.textSecondary,
      ColorToken.textDisabled);

  static final BazaarLinkStyle _white = BazaarLinkStyle(
      TypographyToken.body14Bold(
          color: ColorToken.textInverse, decoration: TextDecoration.underline),
      null,
      ColorToken.textInverse,
      ColorToken.textDisabled);
}
