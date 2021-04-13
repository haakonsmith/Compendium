import 'package:flutter/material.dart';

class DefaultDatablockPreview extends StatelessWidget {
  final String name;
  final VoidCallback onEdit;
  final VoidCallback onTap;

  DefaultDatablockPreview(this.name, this.onEdit, this.onTap);

  @override
  Widget build(BuildContext context) {
    Widget header = Align(
        alignment: Alignment.topLeft,
        child: Text(
          name,
          style: TextStyle(fontSize: 17),
        ));

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [header, Text('test')],
        ),
        IconButton(icon: Icon(Icons.more_vert_outlined), onPressed: onEdit)
      ],
    );

    final defaultCard = Card(
      elevation: 1,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: onTap,
        child: Container(padding: EdgeInsets.all(10), width: double.infinity, constraints: BoxConstraints.loose(Size.fromHeight(200)), child: Text("Nothing to preview")),
      ),
    );

    return defaultCard;
  }
}
