import 'dart:math';

import 'package:flutter/material.dart';

class StackedDisplayStyle extends StatelessWidget {
  final Widget child;
  final int stackSize;
  final VoidCallback onTap;

  const StackedDisplayStyle({Key key, this.stackSize, this.onTap, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultCard = Card(
      elevation: 1,
      color: HSLColor.fromAHSL(1, 1, 0, 1).toColor(),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: onTap,
        child: Container(padding: EdgeInsets.all(10), width: double.infinity, constraints: BoxConstraints.loose(Size.fromHeight(100)), child: child),
      ),
    );

    final List datablockIndices = Iterable<int>.generate(min(stackSize, 3)).toList();

    final List lightness = [1.0, 0.99, 0.98].toList();

    final stackCards = datablockIndices.reversed.map((index) {
      final card = Card(
        elevation: 1,
        color: HSLColor.fromAHSL(1, 1, 0, lightness[index]).toColor(),
        margin: EdgeInsets.only(top: 7.0 * (index + 1), left: 5, right: 5),
        child: InkWell(onTap: onTap, child: Container(padding: EdgeInsets.all(10), constraints: BoxConstraints.loose(Size.fromHeight(100)), child: child)),
      );

      return card;
    }).toList();

    return Container(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: stackSize == 0 ? [defaultCard] : stackCards,
      ),
    );
  }
}
