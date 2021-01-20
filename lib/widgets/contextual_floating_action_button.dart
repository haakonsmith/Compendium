import 'package:flutter/material.dart';

/// This widget is like the floating action button and provides extra functionality.
/// Such as expanding to show contextual interface elements.
/// As well as animations.
class ContextualFloatingActionBar extends StatelessWidget {
  ContextualFloatingActionBar(
      {this.onPressed,
      this.backgroundColor,
      children,
      this.shape,
      this.elevation,
      this.focusElevation,
      this.hoverElevation})
      : assert(elevation == null || elevation >= 0.0),
        assert(focusElevation == null || focusElevation >= 0.0),
        assert(hoverElevation == null || hoverElevation >= 0.0),
        children = children ?? [];

  final VoidCallback onPressed;
  final Color backgroundColor;
  final List<Widget> children;
  final ShapeBorder shape;
  final double elevation;
  final double focusElevation;
  final double hoverElevation;

  static const double _defaultElevation = 6;
  static const double _defaultFocusElevation = 6;
  static const double _defaultHoverElevation = 8;
  static const double _defaultHighlightElevation = 12;
  static const ShapeBorder _defaultShape = CircleBorder();
  static const ShapeBorder _defaultExtendedShape = StadiumBorder();

  @override
  Widget build(BuildContext context) {
    var floatingActionButtonTheme = Theme.of(context).floatingActionButtonTheme;
    final double elevation = this.elevation ??
        floatingActionButtonTheme.elevation ??
        _defaultElevation;
    final double focusElevation = this.focusElevation ??
        floatingActionButtonTheme.focusElevation ??
        _defaultFocusElevation;
    final double hoverElevation = this.hoverElevation ??
        floatingActionButtonTheme.hoverElevation ??
        _defaultHoverElevation;
    ShapeBorder shape;

    if (children.length == 1) shape = _defaultShape;
    if (children.length > 1) shape = _defaultExtendedShape;
    // if (this.shape == null) shape = this.shape;
    const double buttonSize = 66;

    Widget result = SizedBox(
        height: buttonSize,
        width: children.length * buttonSize - 10,
        child: Card(
            color: backgroundColor,
            shape: shape,
            elevation: elevation,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: children
                  .map((child) => Expanded(
                        child: IconTheme(
                            data: IconTheme.of(context), child: child),
                      ))
                  .toList(),
            )));

    return MergeSemantics(child: result);
  }
}

class ContextualFloatingActionButton extends StatelessWidget {
  ContextualFloatingActionButton(
      {this.label, this.icon, this.onPressed, this.constraints, this.style});

  final Widget label;
  final Widget icon;
  final VoidCallback onPressed;
  ButtonStyle style;
  final BoxConstraints constraints;

  static const ShapeBorder _defaultShape = CircleBorder();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      icon: icon,
      constraints: constraints,
      onPressed: onPressed,
      splashRadius: 28,
    );
  }
}
