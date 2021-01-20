import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:compendium/data/BLoC/template_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:compendium/widgets/template_form_field.dart';
import 'package:flutter/material.dart';
import 'package:compendium/widgets/color_form_field.dart';

import 'datablock_preview.dart';

/// # Attribute
///
/// This is a single attribute of a datablock.
class Attribute extends StatelessWidget {
  Attribute({this.icon, this.datablock, this.onChange, this.onTap, this.index})
      : name = datablock.name,
        value = datablock.value;

  /// The name of the attribute
  final String name;

  /// The value of the attribute
  final String value;

  final void Function() onTap;

  // TODO: make icon parser e.g. when attribute has name "medical" make the icon a +
  /// The icon to be displayed before the name of the attribute
  final Icon icon;

  /// The datablock this is attached to
  @required
  Datablock datablock;

  @required
  final int index;

  /// This fires off whenever the user adds a new attribute or finishes an edit.
  final void Function() onChange;

  /// Creates a new [Attribute] (and [Datablock]) and immediately calls editData() to bring up the dialog
  static Attribute fromDialog(
    BuildContext context, {
    void Function() onChange,
  }) {
    Attribute newAttribute = Attribute(datablock: Datablock.blank(), onChange: onChange);
    newAttribute.editData(context, creation: true);
    return newAttribute;
  }

  /// Creates a dialog where the user can edit the attribute name and value
  void editData(BuildContext context, {@required bool creation}) {
    var parentDatablock = PersonBloc.of(context).activeDatablock;

    // if we don't have a datablock, leave
    if (datablock == null) return;

    showDialog(context: context, builder: (BuildContext context) => AttributeDialog(datablock, index, parentDatablock, editing: !creation, onChange: onChange));
  }

  @override
  Widget build(BuildContext context) {
    return DatablockPreview(datablock, index, onTap: onTap, onEdit: () => editData(context, creation: false));
  }
}

class AttributeDialog extends StatefulWidget {
  AttributeDialog(this.datablock, this.index, this.parentDatablock, {this.editing = false, this.onChange});

  final bool editing;
  final void Function() onChange;

  @required
  final Datablock datablock;

  @required
  final Datablock parentDatablock;

  @required
  final int index;

  @override
  _AttributeDialogState createState() => _AttributeDialogState(datablock);
}

class _AttributeDialogState extends State<AttributeDialog> {
  Datablock datablock;

  @override
  _AttributeDialogState(this.datablock);

  @override
  Widget build(BuildContext context) {
    int selectedTemplateIndex = 0;

    TextEditingController attributeController = TextEditingController(text: datablock.name);
    TextEditingController valueController = TextEditingController(text: datablock.value);
    Color colorController = datablock.color ?? widget.parentDatablock.color;

    var dismissButton = RaisedButton(
      color: Color(datablock.colorValue),
      onPressed: () => Navigator.of(context, rootNavigator: true).pop('dialog'),
      child: Text(
        widget.editing ? "Cancel" : "Discard",
        style: TextStyle(color: Colors.white),
      ),
    );

    var deleteButton = RaisedButton(
        color: Color(datablock.colorValue),
        child: Text("delete", style: TextStyle(color: Colors.white)),
        onPressed: () {
          PersonBloc.of(context).removeDatablockFromActive(widget.index);
          Navigator.of(context, rootNavigator: true).pop('dialog');

          widget.onChange();
        });

    var saveButton = RaisedButton(
      color: datablock.color,
      onPressed: () {
        datablock.name = attributeController.text;
        if (!datablock.isCategory) datablock.value = valueController.text;
        datablock.colorValue = colorController.value;

        if (!widget.editing) {
          PersonBloc.of(context).addDatablockToActive(datablock);
          selectedTemplateIndex = 0;
        } else {
          PersonBloc.of(context).updateDatablockFromActive(datablock, widget.index);
        }

        Navigator.of(context, rootNavigator: true).pop('dialog');

        widget.onChange();
      },
      child: Text(
        "Save",
        style: TextStyle(color: Colors.white),
      ),
    );

    var buttonPanel = Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: widget.editing ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
            children: [
              // if it doesn't exist, don't show delete
              if (widget.editing) deleteButton,

              saveButton,
            ],
          ),
          SizedBox(height: 20),
          dismissButton,
        ],
      ),
    );

    var nameComponent = Container(
      margin: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        cursorColor: widget.parentDatablock.color,
        controller: attributeController,
        // initialValue: "Attribute Value",
        decoration: InputDecoration(
          labelText: "Attribute Name",
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.parentDatablock.color),
          ),
        ),
      ),
    );

    var valueComponent = Container(
      margin: EdgeInsets.only(bottom: 20),
      child: TextField(
        cursorColor: Color(datablock.colorValue),
        controller: valueController,
        decoration: InputDecoration(
          labelText: "Attribute Value",
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.parentDatablock.color),
          ),
        ),
      ),
    );

    var colorComponent = Container(
      padding: EdgeInsets.all(8.0),
      child: ColorFormField(
        onChanged: (color) => colorController = color,
        initialColor: colorController,
      ),
    );

    var templateComponent = Container(
        alignment: Alignment.centerLeft,
        child: TemplateFormField(
          onChange: (val) => setState(() {
            selectedTemplateIndex = val;
            print(TemplateBloc.of(context).templates[selectedTemplateIndex].toJson());
            datablock = TemplateBloc.of(context).templates[selectedTemplateIndex].copy();

            print(datablock.metadata.toJson());
            // attributeController.value = TextEditingValue(text: datablock.name);
          }),
        ));

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            nameComponent,
            if (!datablock.isCategory) valueComponent,
            if (datablock.isCategory) colorComponent,
            if (!widget.editing) templateComponent,
            buttonPanel,
          ],
        ),
      ),
    );
  }
}
