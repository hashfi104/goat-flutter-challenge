import 'package:flutter/material.dart';

import '../text/text_xyz.dart';
import '../token/color_token.dart';
import '../token/corner_token.dart';
import '../token/typography_token.dart';

class BadgeGeneralXYZ extends StatelessWidget {
  final int badgeCount;
  final BazaarBadgeStyle? style;
  final BazaarBadgeBorderStyle? borderStyle;
  final double _badgeSize;

  static const keyValueBadgeGeneral = "badge-general";
  static const keyValueBadgeGeneralCount = "badge-general-count";

  static const double _sizeMedium = 20;
  static const double _sizeRegular = 18;
  static const double _sizeDot = 12;
  static const String badgeMax = "99+";

  const BadgeGeneralXYZ.regular(this.badgeCount,
      {Key? key = const Key(keyValueBadgeGeneral),
      this.style,
      this.borderStyle})
      : _badgeSize = _sizeRegular,
        super(key: key);

  const BadgeGeneralXYZ.medium(this.badgeCount,
      {Key? key = const Key(keyValueBadgeGeneral),
      this.style,
      this.borderStyle})
      : _badgeSize = _sizeMedium,
        super(key: key);

  const BadgeGeneralXYZ.dot(
      {Key? key = const Key(keyValueBadgeGeneral),
      this.style,
      this.borderStyle})
      : _badgeSize = _sizeDot,
        badgeCount = 0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final badgeStyle = style ?? BazaarBadgeStyle.primary;
    final badgeBorderStyle = borderStyle ?? BazaarBadgeBorderStyle.light;
    final borderColor = badgeBorderStyle.borderColor;
    final border = borderColor != null
        ? BoxDecoration(
            color: borderColor,
            border: Border.all(
                color: borderColor, width: badgeBorderStyle.borderSize),
            borderRadius: CornerToken.radiusCircle)
        : null;

    if (border != null && badgeBorderStyle.borderSize > 0) {
      return Container(
          height: _badgeSize,
          decoration: border,
          constraints: _getBadgeSize(),
          child: Container(
            decoration: BoxDecoration(
                color: badgeStyle.color,
                borderRadius: CornerToken.radiusCircle),
            alignment: Alignment.center,
            child: _badgeSize == _sizeDot
                ? _getBadgeDot()
                : _getBadgeText(badgeStyle),
          ));
    }
    return Container(
      height: _badgeSize,
      decoration: BoxDecoration(
          color: badgeStyle.color, borderRadius: CornerToken.radiusCircle),
      constraints: _getBadgeSize(),
      alignment: Alignment.center,
      child:
          _badgeSize == _sizeDot ? _getBadgeDot() : _getBadgeText(badgeStyle),
    );
  }

  BoxConstraints _getBadgeSize() {
    if (badgeCount < 10) {
      return BoxConstraints(
          minHeight: _badgeSize, minWidth: _badgeSize, maxWidth: _badgeSize);
    }

    // horizontal padding = 5, total 10 (left 5 and right 5)
    const padding = 10;
    final maxWidth = _badgeSize + padding;
    return BoxConstraints(
        minHeight: _badgeSize, minWidth: _badgeSize, maxWidth: maxWidth);
  }

  Widget _getBadgeDot() {
    return const SizedBox.shrink(key: Key(keyValueBadgeGeneralCount));
  }

  Widget _getBadgeText(BazaarBadgeStyle style) {
    final count = _getBadgeCount();
    final textStyle = _badgeSize == _sizeMedium
        ? TypographyToken.caption12Medium(color: style.textColor)
        : TypographyToken.caption10Medium(color: style.textColor);
    return TextXYZ(count,
        key: const Key(keyValueBadgeGeneralCount),
        style: textStyle,
        textAlign: TextAlign.center);
  }

  String _getBadgeCount() {
    if (badgeCount >= 100) return badgeMax;
    if (badgeCount <= 0) return "";
    return "$badgeCount";
  }
}

class BazaarBadgeStyle {
  final Color color;
  final Color textColor;

  const BazaarBadgeStyle(this.color, this.textColor);

  static final BazaarBadgeStyle primary =
      BazaarBadgeStyle(ColorToken.brand01, ColorToken.textInverse);

  static final BazaarBadgeStyle secondary =
      BazaarBadgeStyle(ColorToken.backgroundAttention, ColorToken.textInverse);

  static final BazaarBadgeStyle whiteActive = BazaarBadgeStyle(
      ColorToken.theBackground, ColorToken.textInformational02);
}

class BazaarBadgeBorderStyle {
  final double borderSize;
  final Color? borderColor;

  const BazaarBadgeBorderStyle(this.borderSize, this.borderColor);

  static final BazaarBadgeBorderStyle light =
      BazaarBadgeBorderStyle(2, ColorToken.borderInverse);

  static final BazaarBadgeBorderStyle dark =
      BazaarBadgeBorderStyle(2, ColorToken.borderForeground);

  static BazaarBadgeBorderStyle adaptive(Color borderColor) {
    return BazaarBadgeBorderStyle(2, borderColor);
  }
}
