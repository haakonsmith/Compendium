import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// # Attribute
///
/// This is a single attribute of a datablock.
class Attribute extends StatelessWidget {
  Attribute({
    this.name,
    this.value,
    this.icon,
    this.datablockIndex,
    this.onChange,
  });

t  static RegExp findDatablockRegex = RegExp(
    r"^_datablock: .+",
    multiLine: false,
  );

  /// The name of the attribute
  final String name;

  /// The value of the attribute
  final String value;

  // TODO: make icon parser e.g. when attribute has name "medical" make the icon a +
  /// The icon to be displayed before the name of the attribute
  final Icon icon;

  /// The index of the data block this attribute is attached to
  @required
  final int datablockIndex;

  /// This fires off whenever the user adds a new attribute or finishes an edit.
  final void Function() onChange;

  /// Creates a new [Attribute] and immediately calls editData() to bring up the dialog
  static Attribute fromDialog(
    BuildContext context,
    int datablockIndex, {
    void Function() onChange,
  }) {
    Attribute newAttribute = Attribute(datablockIndex: datablockIndex, onChange: onChange);
    newAttribute.editData(context);
    return newAttribute;
  }

  /// Creates a dialog where the user can edit the attribute name and value
  void editData(BuildContext context) {
    Box<Datablock> datablockBox = PersonBloc.of(context).activePersonBox;

    // if datablockBox is null then just leave
    if (datablockBox == null) return;

    TextEditingController attributeController = TextEditingController();
    TextEditingController valueController = TextEditingController();

    if (name != null) attributeController.text = name;
    if (value != null) valueController.text = value;

    Datablock datablock;

    if (datablockBox.length > datablockIndex) {
      datablock = datablockBox.getAt(datablockIndex);
    }

    // if we don't have a datablock, leave
    if (datablock == null) return;

    // if attributes is null, just set it to a blank map
    datablock.attributes ??= {};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: Container(
            height: 240,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField(
                    cursorColor: Color(datablock.colourValue),
                    controller: attributeController,
                    decoration: InputDecoration(
                      labelText: "Attribute Name",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(datablock.colourValue)),
                      ),
                    ),
                  ),
                ),
                TextField(
                  cursorColor: Color(datablock.colourValue),
                  controller: valueController,
                  decoration: InputDecoration(
                    labelText: "Attribute Value",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(datablock.colourValue)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: (datablock.attributes.containsKey(name)) ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                        children: [
                          // if it doesn't exist, don't show delete
                          datablock.attributes.containsKey(name)
                              ? RaisedButton(
                                  color: Color(datablock.colourValue),
                                  onPressed: () {
                                    datablock.attributes.remove(attributeController.text);

                                    datablockBox.putAt(datablockIndex, datablock);
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
                              datablock.attributes ??= {};
                              // if the attribute name changes we need to remove the old one
                              // and add the new one
                              if (attributeController.text != name) {
                                datablock.attributes.remove(name);
                              }
                              datablock.attributes[attributeController.text] = valueController.text;

                              datablockBox.putAt(datablockIndex, datablock);
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
                          (datablock.attributes.containsKey(name)) ? "Cancel" : "Discard",
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
    if (findDatablockRegex.hasMatch(name)) {
      var uriSegments = Uri.parse(ModalRoute.of(context).settings.name).pathSegments;
      Box<Datablock> personBox = PersonBloc.of(context).activePersonBox;
      Datablock val;

      // [
      //   datablock,
      //   datablock,
      //   datablock,
      //   datablock,
      //   datablock,
      //   datablock,
      //   datablock, <====
      // ]

      // [
      //   datablock: { <---- this is item 21
      //     datablock: {
      //       datablock <====
      //     }
      //   }
      // ]

      for (var i = 0; i < uriSegments.length; i += 2) {
        // /datablock/21/datablock/1 
        
        val = personBox.getAt(int.parse(uriSegments.last));
      }

      return val.buildPreview(uriSegments[i]);
    }

    return Card(
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
                  onPressed: () => editData(context),
                ),
              ),
            ],
          ),
        ));
  }
}
