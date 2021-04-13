import 'dart:math';

import 'package:flutter/material.dart';

class MultiColumnListView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  double columnWidth;
  int columnCount;
  int totalRun;

  MultiColumnListView.builder({this.columnCount, this.columnWidth = 250, this.itemCount, this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      debugPrint('Max Width: $constraints.maxWidth');

      totalRun = 0;

      final columns = _calculateColumnCount(constraints.maxWidth);
      final lengths = _generateCols(columns, itemCount);

      final children = Iterable<int>.generate(min(columns, itemCount)).map((column) {
        return _buildColumn(context, constraints.maxWidth / columns, lengths[column]);
      }).toList();

      return Row(
        children: children,
      );
    });
  }

  static List<int> _generateCols(numberCols, itemCount) {
    var it = 0;
    var list = <int>[];

    for (var i = 0; i < numberCols; i++) {
      list.add(0);
    }

    while (it <= itemCount) {
      for (var i = 0; i < numberCols; i++) {
        it++;
        if (it > itemCount) break;
        list[i]++;
      }
    }
    return list;
  }

  Widget _buildColumn(BuildContext context, double width, int limit) {
    final children = Iterable<int>.generate(limit).map((e) => Container(width: width, child: itemBuilder(context, e + totalRun))).toList();

    totalRun += limit;

    return SingleChildScrollView(
        child: Column(
      children: children,
    ));
  }

  int _calculateColumnCount(double width) {
    return columnCount ?? (width / columnWidth).floor();
  }
}
