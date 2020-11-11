import 'package:flutter/material.dart';

/// iOS style slide-from-the-right transition.
/// 
/// Used to indicate the item is nested
class NestedPageRoute<T> extends MaterialPageRoute<T> {
  NestedPageRoute({WidgetBuilder builder, RouteSettings settings}) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    var begin = Offset(1, 0);
    var end = Offset.zero;
    var curve = CurveTween(curve: Curves.easeOutSine);
    var tween = Tween<Offset>(begin: begin, end: end).chain(curve);

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
