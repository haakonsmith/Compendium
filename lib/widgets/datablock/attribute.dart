import 'package:compendium/data/datablock.dart';
import 'package:compendium/widgets/datablock/value_style.dart';
import 'package:flutter/material.dart';

class DatablockAttributePreivew extends StatelessWidget {
  final Datablock datablock;
  final int index;

  final VoidCallback onEdit;

  DatablockAttributePreivew(this.datablock, {this.onEdit, this.index});

  @override
  Widget build(BuildContext context) {
    Widget header = Align(
        alignment: Alignment.topLeft,
        child: Text(
          datablock.name,
          style: TextStyle(fontSize: 17),
        ));

    Row content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              header,
              SizedBox(
                height: 10,
              ),
              _valueStyleSwitch()
            ],
          ),
        ),
        Center(
          child: IconButton(icon: Icon(Icons.more_vert_outlined), onPressed: onEdit),
        )
      ],
    );

    return _displayStyleSwitch(child: content);
  }

  Widget _displayStyleSwitch({Row child}) {
    return _DefaultDisplayStyle(
      child: child,
    );
  }

  Widget _valueStyleSwitch() {
    print(datablock.metadata.toJson());
    switch (datablock.metadata.valueStyle) {
      case DatablockValueStyle.bar:
        return BarValueStyle(value: datablock.value);
      case DatablockValueStyle.textarea:
        return TextAreaValueStyle(
          datablock: datablock,
          index: index,
        );
      default:
        return Container(
            width: 100,
            child: Text(
              datablock.value,
              textAlign: TextAlign.left,
            ));
    }
  }
}

class _DefaultDisplayStyle extends StatelessWidget {
  final Widget child;

  _DefaultDisplayStyle({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
        width: 100,
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints.tightFor(height: 120),
        child: child,
      ),
    );
  }
}
