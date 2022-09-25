import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A widget replacement for [InkWell] or [gestureDetector]
/// Support automatic tracking [UserEventTracker]
class Tappable extends StatelessWidget {
  // InkWell and GestureDetector states & events
  final Widget? child;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;

  // GestureDetector states & events
  final GestureTapUpCallback? onTapUp;
  final GestureTapDownCallback? onTapDown;
  final GestureTapDownCallback? onDoubleTapDown;
  final GestureLongPressDownCallback? onLongPressDown;
  final GestureDragEndCallback? onPanEnd;
  final GestureDragUpdateCallback? onPanUpdate;

  // InkWell states & events
  final BorderRadius? borderRadius;
  final bool _shouldUseInkWell;
  final String? Function()? eventValue;

  /// Trackable [InkWell]
  /// * [eventAttributes] The event attributes
  ///   Used for [UserEventTracker]
  ///   See [EventAttributes] for more info
  const Tappable({
    Key? key,
    this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.borderRadius,
    this.eventValue,
  })  : _shouldUseInkWell = true,
        onTapUp = null,
        onTapDown = null,
        onDoubleTapDown = null,
        onLongPressDown = null,
        onPanEnd = null,
        onPanUpdate = null,
        super(key: key);

  /// Trackable [GestureDetector]
  /// Currently limited for some gesture based on current needs.
  /// * [eventAttributes] The event attributes
  ///   Used for [UserEventTracker]
  ///   See [EventAttributes] for more info
  const Tappable.gestureDetector({
    Key? key,
    this.child,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onDoubleTap,
    this.onDoubleTapDown,
    this.onLongPress,
    this.onLongPressDown,
    this.onPanEnd,
    this.onPanUpdate,
    this.eventValue,
  })  : _shouldUseInkWell = false,
        borderRadius = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_shouldUseInkWell) {
      return InkWell(
        borderRadius: borderRadius,
        onTap: _onTap,
        onDoubleTap: _onDoubleTap,
        onLongPress: _onLongPress,
        child: child,
      );
    }

    return GestureDetector(
      onTapUp: onTapUp,
      onTapDown: onTapDown,
      onTap: (onTap == null && onTapUp == null && onTapDown == null)
          ? null
          : () {
              onTap?.call();
            },
      onDoubleTapDown: onDoubleTapDown,
      onDoubleTap: (onDoubleTap == null && onDoubleTapDown == null)
          ? null
          : () {
              onDoubleTap?.call();
            },
      onLongPressDown: onLongPressDown,
      onLongPress: (onLongPress == null && onLongPressDown == null)
          ? null
          : () {
              onLongPress?.call();
            },
      onPanUpdate: onPanUpdate,
      onPanEnd: (onPanEnd == null && onPanUpdate == null)
          ? null
          : (value) {
              onPanEnd?.call(value);
            },
      child: child,
    );
  }

  get _onTap => onTap != null ? _tap : null;

  get _onDoubleTap => onDoubleTap != null ? _doubleTap : null;

  get _onLongPress => onLongPress != null ? _longPress : null;

  void _tap() {
    onTap?.call();
  }

  void _doubleTap() {
    onDoubleTap?.call();
  }

  void _longPress() {
    onLongPress?.call();
  }
}
