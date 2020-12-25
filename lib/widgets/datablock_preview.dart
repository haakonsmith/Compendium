import '../data/datablock.dart';
import 'package:flutter/material.dart';

class DatablockPreview extends StatelessWidget {
  final Datablock datablock;

  DatablockPreview(this.datablock);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: datablock.children.isEmpty
            ? Text("Nothing to preview")
            : ListView.builder(
                itemCount: datablock.children.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(datablock.children[index].name),
                  );
                }));
  }
}
