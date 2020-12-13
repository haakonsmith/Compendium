import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:flutter/material.dart';
import 'package:compendium/widgets/color_form_field.dart';

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
  final Datablock datablock;

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

    TextEditingController attributeController = TextEditingController();
    TextEditingController valueController = TextEditingController();
    Color colorController = datablock.color ?? parentDatablock.color;

    if (name != null) attributeController.text = name;
    if (value != null) valueController.text = value;

    // if we don't have a datablock, leave
    if (datablock == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: Container(
            height: 330,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField(
                    cursorColor: parentDatablock.color,
                    controller: attributeController,
                    decoration: InputDecoration(
                      labelText: "Attribute Name",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: parentDatablock.color),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField(
                    cursorColor: Color(datablock.colourValue),
                    controller: valueController,
                    decoration: InputDecoration(
                      labelText: "Attribute Value",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: parentDatablock.color),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: ColorFormField(
                    onChanged: (color) => colorController = color,
                    initialColor: colorController,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: !creation ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                        children: [
                          // if it doesn't exist, don't show delete
                          !creation
                              ? RaisedButton(
                                  color: Color(datablock.colourValue),
                                  onPressed: () {
                                    PersonBloc.of(context).removeDatablockFromActive(index);
                                    Navigator.of(context, rootNavigator: true).pop('dialog');

                                    onChange();
                                  },
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Container(),

                          RaisedButton(
                            color: Color(datablock.colourValue),
                            onPressed: () {
                              datablock.name = attributeController.text;
                              datablock.value = valueController.text;
                              datablock.colourValue = colorController.value;

                              print(index);
                              print(datablock);

                              if (creation) {
                                PersonBloc.of(context).addDatablockToActive(datablock);
                              } else {
                                PersonBloc.of(context).updateDatablockFromActive(datablock, index);
                              }

                              Navigator.of(context, rootNavigator: true).pop('dialog');

                              onChange();
                            },
                            child: Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
                        color: Color(datablock.colourValue),
                        onPressed: () => Navigator.of(context, rootNavigator: true).pop('dialog'),
                        child: Text(
                          !creation ? "Cancel" : "Discard",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 0,
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 15),
                child: icon == null ? Container() : icon,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      name == null ? "" : name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      ":",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      value == null ? "" : value,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15, right: 10),
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => editData(context, creation: false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
