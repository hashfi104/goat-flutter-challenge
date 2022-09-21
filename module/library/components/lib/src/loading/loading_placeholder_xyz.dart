import 'package:components/components.dart';
import 'package:flutter/material.dart';

import '../structure/separator_line.dart';
import '../token/corner_token.dart';

class LoadingPlaceholderXYZ extends StatelessWidget {
  final PlaceholderType placeholderType;
  final BazaarPlaceholderStyle? style;
  final double width;
  final double height;
  final BorderRadius? radius;
  final String image;
  final TextStyle? textStyle;
  final int lines;
  final Axis orientation;

  // space between text line
  static const int _lineBreak = 8;

  const LoadingPlaceholderXYZ.circle({
    required double size,
    Key? key,
    this.style,
  })  : placeholderType = PlaceholderType.circle,
        radius = null,
        image = "",
        textStyle = null,
        width = size,
        height = size,
        lines = 0,
        orientation = Axis.horizontal,
        super(key: key);

  /// Create loading placeholder for image
  /// * Does not support vector
  const LoadingPlaceholderXYZ.image({
    required this.width,
    required this.height,
    Key? key,
    this.image = '',
    this.radius,
  })  : placeholderType = PlaceholderType.image,
        textStyle = null,
        lines = 0,
        orientation = Axis.horizontal,
        style = null,
        super(key: key);

  const LoadingPlaceholderXYZ.rectangle({
    required this.width,
    required this.height,
    Key? key,
    this.style,
    this.radius,
  })  : placeholderType = PlaceholderType.rectangle,
        image = "",
        textStyle = null,
        lines = 0,
        orientation = Axis.horizontal,
        super(key: key);

  const LoadingPlaceholderXYZ.text({
    required this.width,
    this.lines = 1,
    Key? key,
    this.style,
    this.textStyle,
  })  : placeholderType = PlaceholderType.text,
        radius = null,
        image = "",
        height = 0,
        orientation = Axis.horizontal,
        super(key: key);

  const LoadingPlaceholderXYZ.separatorLine({
    required double length,
    Key? key,
    this.style,
    this.orientation = Axis.horizontal,
  })  : placeholderType = PlaceholderType.separatorLine,
        radius = null,
        image = "",
        textStyle = null,
        width = length,
        height = 0,
        lines = 0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeholderStyle = style ?? BazaarPlaceholderStyle.primary;

    switch (placeholderType) {
      case PlaceholderType.circle:
        return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: placeholderStyle.color));
      case PlaceholderType.rectangle:
        return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: placeholderStyle.color,
                borderRadius: radius));
      case PlaceholderType.image:
        final imageRadius = radius ?? BorderRadius.zero;
        return ClipRRect(
            borderRadius: imageRadius,
            child: ImageXYZ.asset(image,
                width: width, height: height, fit: BoxFit.scaleDown));
      case PlaceholderType.text:
        final typographyToken = textStyle ?? TypographyToken.body14();
        final fontSize = typographyToken.fontSize ?? 0;
        final lineHeight = (fontSize * lines) + ((lines - 1) * _lineBreak);

        return CustomPaint(
          painter: _TextPainter(
              lines, _lineBreak, placeholderStyle, typographyToken),
          size: Size(width, lineHeight),
        );
      case PlaceholderType.separatorLine:
        return SeparatorLine(
            length: width,
            color: placeholderStyle.color,
            orientation: orientation);
    }
  }
}

class _TextPainter extends CustomPainter {
  final BazaarPlaceholderStyle style;
  final int lines;
  final int lineBreak;
  final TextStyle textStyle;

  const _TextPainter(this.lines, this.lineBreak, this.style, this.textStyle);

  @override
  void paint(Canvas canvas, Size size) {
    final textHeight = textStyle.fontSize ?? 0;
    final paint = Paint()
      ..color = style.color
      ..style = PaintingStyle.fill;
    double currentLine = 1;
    double y = 0;
    while (currentLine <= lines) {
      final double x = currentLine == lines && lines > 1
          ? size.width * 70 / 100
          : size.width;

      RRect fullRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, y, x, textHeight),
        CornerToken.radius4.bottomRight,
      );
      canvas.drawRRect(fullRect, paint);

      final space = currentLine == lines ? 0 : lineBreak;
      y += textHeight + space;
      currentLine += 1;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BazaarPlaceholderStyle {
  final Color color;

  const BazaarPlaceholderStyle(this.color);

  static final primary = BazaarPlaceholderStyle(ColorToken.backgroundSubtle);
  static final secondary = BazaarPlaceholderStyle(ColorToken.backgroundLow);
}

enum PlaceholderType { circle, image, rectangle, text, separatorLine }
