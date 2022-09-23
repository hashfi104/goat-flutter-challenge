import 'package:flutter/material.dart';

import '../token/color_token.dart';
import 'loading_builder/loading_animation_linear.dart';
import 'loading_builder/loading_animation_wave.dart';
import 'loading_builder/loading_decorate.dart';

enum LoadingStyle { linear, wave }

class LoadingXYZ extends StatelessWidget {
  final LoadingStyle style;
  final Color? color;

  static const keyLoadingLinear = "loading-linear";
  static const keyLoadingWave = "loading-wave";

  /// Loading animation, source: https://pub.dev/packages/loading_indicator
  /// * [style] Loading animation style option: [wave, linear]
  /// * [color] Loading color
  const LoadingXYZ({
    Key? key,
    this.style = LoadingStyle.linear,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingDecorateContext(
      decorateData: LoadingDecorateData(
          indicator: style, colors: [color ?? ColorToken.backgroundMedium]),
      child: SizedBox(
        height: 32,
        width: 32,
        child: _loadingIndicator(),
      ),
    );
  }

  Widget _loadingIndicator() {
    switch (style) {
      case LoadingStyle.linear:
        return const LoadingAnimationLinear(
            key: Key(LoadingXYZ.keyLoadingLinear));
      case LoadingStyle.wave:
        return const LoadingAnimationWave(key: Key(LoadingXYZ.keyLoadingWave));
      default:
        throw Exception("no related indicator type:$style");
    }
  }
}
