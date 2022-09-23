import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../token/color_token.dart';
import '../image/image_xyz.dart';
import '../image/image_holder.dart';

class IconXYZ extends StatelessWidget {
  final String source;
  final ImageHolder? imageHolder;
  final double? size;
  final bool matchTextDirection;
  final AssetBundle? bundle;
  final String? package;
  final BoxFit fit;
  final Alignment alignment;
  final bool allowDrawingOutsideViewBox;
  final Color? color;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final Clip clipBehavior;
  final bool cacheColorFilter;
  final int bleedingArea;

  static const double sizeMajor = 24;
  static const double sizeMinor = 16;

  /// Icon with custom size (not recommended)
  /// * Use [IconComponent.major] or [IconComponent.minor] whenever possible
  /// * [bleedingArea] padding around the icon
  const IconXYZ(this.source,
      {Key? key,
      this.size = sizeMajor,
      this.matchTextDirection = false,
      this.bundle,
      this.package,
      this.fit = BoxFit.contain,
      this.alignment = Alignment.center,
      this.allowDrawingOutsideViewBox = false,
      this.color,
      this.semanticLabel,
      this.excludeFromSemantics = false,
      this.clipBehavior = Clip.hardEdge,
      this.cacheColorFilter = false,
      this.bleedingArea = 0})
      : imageHolder = null,
        super(key: key);

  /// Icon major with fixed size 24x24
  /// * [bleedingArea] padding around the icon
  const IconXYZ.major(this.source,
      {Key? key,
      this.matchTextDirection = false,
      this.bundle,
      this.package,
      this.fit = BoxFit.contain,
      this.alignment = Alignment.center,
      this.allowDrawingOutsideViewBox = false,
      this.color,
      this.semanticLabel,
      this.excludeFromSemantics = false,
      this.clipBehavior = Clip.hardEdge,
      this.cacheColorFilter = false,
      this.bleedingArea = 0})
      : size = sizeMajor,
        imageHolder = null,
        super(key: key);

  /// Icon minor with fixed size 16x16
  /// * [bleedingArea] padding around the icon
  const IconXYZ.minor(this.source,
      {Key? key,
      this.matchTextDirection = false,
      this.bundle,
      this.package,
      this.fit = BoxFit.contain,
      this.alignment = Alignment.center,
      this.allowDrawingOutsideViewBox = false,
      this.color,
      this.semanticLabel,
      this.excludeFromSemantics = false,
      this.clipBehavior = Clip.hardEdge,
      this.cacheColorFilter = false,
      this.bleedingArea = 0})
      : size = sizeMinor,
        imageHolder = null,
        super(key: key);

  /// Display icon from [ImageHolder]
  /// * Support custom size but no recommended
  /// * Use [IconAV.major] or [IconAV.minor] whenever possible
  /// * [bleedingArea] padding around the icon
  const IconXYZ.imageHolder(this.imageHolder,
      {Key? key,
      this.size = sizeMajor,
      this.matchTextDirection = false,
      this.bundle,
      this.package,
      this.fit = BoxFit.contain,
      this.alignment = Alignment.center,
      this.allowDrawingOutsideViewBox = false,
      this.color,
      this.semanticLabel,
      this.excludeFromSemantics = false,
      this.clipBehavior = Clip.hardEdge,
      this.cacheColorFilter = false,
      this.bleedingArea = 0})
      : source = "",
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? (imageHolder?.tint ?? ColorToken.iconPrimary);
    final image = imageHolder;

    if (_isVector(imageHolder) || source.endsWith(".svg")) {
      final imageSource = source.isNotEmpty ? source : image?.source;
      final icon = SvgPicture.asset(imageSource ?? "",
          width: size,
          height: size,
          matchTextDirection: matchTextDirection,
          bundle: bundle,
          fit: fit,
          alignment: alignment,
          allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
          color: iconColor,
          semanticsLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          clipBehavior: clipBehavior,
          cacheColorFilter: cacheColorFilter);
      if (bleedingArea > 0) {
        return Padding(
            padding: EdgeInsets.all(bleedingArea.toDouble()), child: icon);
      }
      return icon;
    }

    // non svg icon
    if (image != null) {
      final icon = ImageXYZ.imageHolder(image,
          width: size,
          height: size,
          matchTextDirection: matchTextDirection,
          bundle: bundle,
          fit: fit,
          alignment: alignment,
          color: iconColor,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics);
      if (bleedingArea > 0) {
        return Padding(
          padding: EdgeInsets.all(bleedingArea.toDouble()),
          child: icon,
        );
      }
      return icon;
    }

    // local asset icon
    final icon = ImageXYZ.asset(source,
        width: size,
        height: size,
        matchTextDirection: matchTextDirection,
        bundle: bundle,
        fit: fit,
        alignment: alignment,
        color: iconColor,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics);
    if (bleedingArea > 0) {
      return Padding(
          padding: EdgeInsets.all(bleedingArea.toDouble()), child: icon);
    }
    return icon;
  }

  bool _isVector(ImageHolder? imageHolder) {
    final source = imageHolder?.getImageProvider();
    if (source is AssetImage) {
      return source.assetName.endsWith(".svg");
    }
    return false;
  }
}
