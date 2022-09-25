import 'package:flutter/material.dart';

import '../../../components.dart';
import 'shimmer_animate.dart';
import 'sliding_gradient_transform.dart';

class XYZShimmer extends StatefulWidget {
  final Widget child;
  final List<Color>? colors;

  static _XYZShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<_XYZShimmerState>();
  }

  /// [child] Widget child
  /// [colors] Colors shimmer
  const XYZShimmer({
    Key? key,
    required this.child,
    this.colors,
  }) : super(key: key);

  @override
  _XYZShimmerState createState() => _XYZShimmerState();
}

class _XYZShimmerState extends State<XYZShimmer>
    with SingleTickerProviderStateMixin {
  static const _animationDuration = 1500;

  late AnimationController _shimmerController;
  late LinearGradient _shimmerGradient;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(
        min: -0.5,
        max: 1.5,
        period: const Duration(milliseconds: _animationDuration),
      );

    final colors = widget.colors ??
        [
          ColorToken.backgroundWashedout,
          ColorToken.ui02,
          ColorToken.backgroundWashedout,
        ];
    _shimmerGradient = LinearGradient(
      colors: colors,
      stops: const [
        0.1,
        0.2,
        0.4,
      ],
      begin: const Alignment(-1.0, 0.0),
      end: const Alignment(1.0, 0.0),
      tileMode: TileMode.clamp,
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  LinearGradient get gradient => LinearGradient(
        colors: _shimmerGradient.colors,
        stops: _shimmerGradient.stops,
        begin: _shimmerGradient.begin,
        end: _shimmerGradient.end,
        transform: SlidingGradientTransform(
          slidePercent: _shimmerController.value,
        ),
      );

  bool get isSized =>
      (context.findRenderObject() as RenderBox?)?.hasSize ?? false;

  Size get size =>
      (context.findRenderObject() as RenderBox?)?.size ?? const Size(0, 0);

  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final shimmerBox = context.findRenderObject() as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  Listenable get shimmerChanges => _shimmerController;

  @override
  Widget build(BuildContext context) {
    return ShimmerAnimate(
      child: widget.child,
    );
  }
}
