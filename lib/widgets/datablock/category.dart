import 'dart:math';

import 'package:compendium/data/datablock.dart';
import 'package:flutter/material.dart';

import 'display_style.dart';

class DatablockCategoryPreview extends StatelessWidget {
  final Datablock datablock;

  final VoidCallback onEdit;
  final VoidCallback onTap;

  DatablockCategoryPreview(this.datablock, {this.onEdit, this.onTap});

  @override
  Widget build(BuildContext context) {
    Widget header = Align(
        alignment: Alignment.topLeft,
        child: Text(
          datablock.name,
          style: TextStyle(fontSize: 17),
        ));

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [header, Text('test'), buildContentPreview()],
        ),
        IconButton(icon: Icon(Icons.more_vert_outlined), onPressed: onEdit)
      ],
    );

    return _displayStyleSwitch(child: content);
  }

  Widget buildContentPreview() {
    return Text(
      "Looollll previews aren'",
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _displayStyleSwitch({Row child}) {
    switch (datablock.metadata.displayStyle) {
      case DatablockDisplayStyle.stacked:
        return StackedDisplayStyle(child: child, stackSize: datablock.children.length, onTap: onTap);
      default:
        return _DefaultDisplayStyle(
          child: child,
        );
    }
  }
}

class _DefaultDisplayStyle extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _DefaultDisplayStyle({Key key, this.child, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Container(
          padding: EdgeInsets.all(10),
          constraints: BoxConstraints.loose(Size.fromHeight(100)),
          child: child,
        ),
      ),
    );
  }
}
