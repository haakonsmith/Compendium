import 'package:flutter/material.dart';

/// Transitions instantly
class InstantPageRoute<T> extends MaterialPageRoute<T> {
  InstantPageRoute({WidgetBuilder builder, RouteSettings settings}) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
