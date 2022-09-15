import 'package:flutter/material.dart';

import '../color/color_token.dart';
import '../icon/icon_xyz.dart';
import '../image/image_holder.dart';
import '../loading/loading_xyz.dart';
import '../text/text_xyz.dart';
import '../text/typography_token.dart';
import 'button_state_style.dart';

class ButtonXYZ extends StatelessWidget {
  final String text;
  final ImageHolder? iconLeft;
  final ImageHolder? iconRight;
  final double? width;
  final ButtonXYZStyle? style;
  final bool isLoading;
  final bool enabled;
  final VoidCallback? onPressed;
  final double _buttonHeight;
  final double _buttonTextSize;
  final double _horizontalPadding;
  final double _iconSize;
  final double _horizontalPaddingWithIcon;
  final double _iconPadding;
  final double _baseLine;
  final Key? buttonKey;

  static const keyButton = "button-button-key";
  static const keyText = "button-text-key";
  static const keyLeftIcon = "button-left-icon-key";
  static const keyRightIcon = "button-right-icon-key";

  @override
  Widget build(BuildContext context) {
    final buttonStyle = style ?? ButtonXYZStyle.primary;
    final outlineColor = buttonStyle.outlineColor;
    final w = width;
    final fixedSize = w == null
        ? null
        : Size(w > _buttonHeight ? w : _buttonHeight, _buttonHeight);

    _onPressed() {
      onPressed?.call();
    }

    if (outlineColor != null) {
      return SizedBox(
        height: _buttonHeight,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              padding: _getPaddingHorizontal(),
              backgroundColor: enabled
                  ? buttonStyle.color.enabled
                  : buttonStyle.color.disabled,
              primary: buttonStyle.color.pressed,
              minimumSize: Size(_buttonHeight, _buttonHeight),
              fixedSize: fixedSize,
              alignment: Alignment.center,
              side: BorderSide(
                  color:
                      enabled ? outlineColor.enabled : outlineColor.disabled)),
          onPressed: enabled ? _onPressed : null,
          key: const Key(keyButton),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (isLoading) ...{
                LoadingXYZ(color: buttonStyle.textColor.enabled),
              } else ...{
                if (iconLeft != null) ...[
                  Padding(
                    padding: EdgeInsets.only(right: _iconPadding),
                    child: IconXYZ.imageHolder(
                      iconLeft,
                      size: _iconSize,
                      key: const Key(keyLeftIcon),
                    ),
                  )
                ],
                TextXYZ(
                  text,
                  style: _getTextStyle(buttonStyle),
                  key: const Key(keyText),
                  maxLines: 1,
                ),
                if (iconRight != null) ...[
                  Padding(
                    padding: EdgeInsets.only(left: _iconPadding),
                    child: IconXYZ.imageHolder(
                      iconRight,
                      size: _iconSize,
                      key: const Key(keyRightIcon),
                    ),
                  )
                ],
              }
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: _buttonHeight,
      key: const Key(keyButton),
      child: TextButton(
        style: TextButton.styleFrom(
            padding: _getPaddingHorizontal(),
            backgroundColor: enabled
                ? buttonStyle.color.enabled
                : buttonStyle.color.disabled,
            primary: buttonStyle.color.pressed,
            minimumSize: Size(_buttonHeight, _buttonHeight),
            fixedSize: fixedSize,
            alignment: Alignment.center),
        onPressed: enabled ? _onPressed : null,
        key: buttonKey,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (isLoading) ...{
              LoadingXYZ(color: buttonStyle.textColor.enabled),
            } else ...{
              if (iconLeft != null) ...[
                Padding(
                  padding: EdgeInsets.only(right: _iconPadding),
                  child: IconXYZ.imageHolder(
                    iconLeft,
                    size: _iconSize,
                    key: const Key(keyLeftIcon),
                  ),
                )
              ],
              Baseline(
                baseline: _baseLine,
                baselineType: TextBaseline.alphabetic,
                child: TextXYZ(
                  text,
                  style: _getTextStyle(buttonStyle),
                  key: const Key(keyText),
                  maxLines: 1,
                ),
              ),
              if (iconRight != null) ...[
                Padding(
                  padding: EdgeInsets.only(left: _iconPadding),
                  child: IconXYZ.imageHolder(
                    iconRight,
                    size: _iconSize,
                    key: const Key(keyRightIcon),
                  ),
                )
              ]
            }
          ],
        ),
      ),
    );
  }

  TextStyle _getTextStyle(ButtonXYZStyle buttonStyle) {
    final textColor = enabled
        ? buttonStyle.textColor.enabled
        : buttonStyle.textColor.disabled;
    if (_buttonTextSize == 16) {
      return TypographyToken.body16Bold(color: textColor);
    } else if (_buttonTextSize == 14) {
      return TypographyToken.body14Bold(color: textColor);
    }
    return TypographyToken.caption12Bold(color: textColor);
  }

  EdgeInsetsGeometry _getPaddingHorizontal() {
    return EdgeInsets.only(
        left:
            iconLeft != null ? _horizontalPaddingWithIcon : _horizontalPadding,
        right: iconRight != null
            ? _horizontalPaddingWithIcon
            : _horizontalPadding);
  }

  const ButtonXYZ.extraSmall(this.text,
      {Key? key,
      this.buttonKey,
      this.width,
      this.style,
      this.isLoading = false,
      this.enabled = true,
      this.onPressed,
      this.iconLeft,
      this.iconRight})
      : _buttonHeight = 28,
        _buttonTextSize = 12,
        _horizontalPadding = 8,
        _iconSize = 14,
        _horizontalPaddingWithIcon = 8,
        _iconPadding = 7,
        _baseLine = 12,
        super(key: key);

  const ButtonXYZ.small(this.text,
      {Key? key,
      this.buttonKey,
      this.width,
      this.style,
      this.isLoading = false,
      this.enabled = true,
      this.onPressed,
      this.iconLeft,
      this.iconRight})
      : _buttonHeight = 36,
        _buttonTextSize = 14,
        _horizontalPadding = 12,
        _iconSize = 20,
        _horizontalPaddingWithIcon = 8,
        _iconPadding = 4,
        _baseLine = 13,
        super(key: key);

  const ButtonXYZ.large(this.text,
      {Key? key,
      this.buttonKey,
      this.width,
      this.style,
      this.isLoading = false,
      this.enabled = true,
      this.onPressed,
      this.iconLeft,
      this.iconRight})
      : _buttonHeight = 44,
        _buttonTextSize = 16,
        _horizontalPadding = 20,
        _iconSize = 20,
        _horizontalPaddingWithIcon = 12,
        _iconPadding = 8,
        _baseLine = 14,
        super(key: key);
}

class ButtonXYZStyle {
  final ButtonStateStyle color;
  final ButtonStateStyle textColor;
  final ButtonStateStyle? outlineColor;

  const ButtonXYZStyle(
      {required this.color, required this.textColor, this.outlineColor});

  static final ButtonXYZStyle primary = ButtonXYZStyle(
      color: ButtonStateStyle(
          enabled: ColorToken.brand01,
          disabled: ColorToken.backgroundPlayfulDisabled02,
          pressed: ColorToken.backgroundPlayfulPressed01),
      textColor: ButtonStateStyle(
          enabled: ColorToken.textInverse,
          disabled: ColorToken.textInverse.withOpacity(0.4),
          pressed: ColorToken.textInverse.withOpacity(0.6)));

  static final ButtonXYZStyle secondary = ButtonXYZStyle(
      color: ButtonStateStyle(
          enabled: ColorToken.backgroundSubtle,
          disabled: ColorToken.backgroundDisabled,
          pressed: ColorToken.backgroundLow),
      textColor: ButtonStateStyle(
          enabled: ColorToken.textSecondary,
          disabled: ColorToken.textSecondary.withOpacity(0.4),
          pressed: ColorToken.textSecondary.withOpacity(0.6)));

  static final ButtonXYZStyle outline = ButtonXYZStyle(
      color: ButtonStateStyle(
          enabled: ColorToken.theBackground,
          disabled: ColorToken.theBackground,
          pressed: ColorToken.backgroundSubtle),
      textColor: ButtonStateStyle(
          enabled: ColorToken.textSecondary,
          disabled: ColorToken.textSecondary.withOpacity(0.4),
          pressed: ColorToken.textSecondary.withOpacity(0.6)),
      outlineColor: ButtonStateStyle(
          enabled: ColorToken.borderMedium,
          disabled: ColorToken.borderMedium,
          pressed: ColorToken.borderMedium));

  static final ButtonXYZStyle outlineGreen = ButtonXYZStyle(
      color: ButtonStateStyle(
          enabled: ColorToken.theBackground,
          disabled: ColorToken.theBackground,
          pressed: ColorToken.backgroundSubtle),
      textColor: ButtonStateStyle(
          enabled: ColorToken.success30,
          disabled: ColorToken.success30.withOpacity(0.4),
          pressed: ColorToken.success30.withOpacity(0.6)),
      outlineColor: ButtonStateStyle(
          enabled: ColorToken.success30,
          disabled: ColorToken.success30,
          pressed: ColorToken.success30));
}
