import 'package:compendium/widgets/datablock/category.dart';
import 'package:compendium/widgets/datablock/attribute.dart';

import '../data/datablock.dart';
import 'package:flutter/material.dart';

class DatablockPreview extends StatelessWidget {
  DatablockPreview(this.datablock, this.index, {this.onTap, this.onEdit});

  final Datablock datablock;
  final int index;

  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    if (datablock.name == "Event Log2") {
      print(datablock.toJson());
    }
    return datablock.metadata.isCategory
        ? DatablockCategoryPreview(
            datablock,
            onEdit: onEdit,
            onTap: onTap,
          )
        : DatablockAttributePreivew(
            datablock,
            index: index,
            onEdit: onEdit,
          );
  }
}
