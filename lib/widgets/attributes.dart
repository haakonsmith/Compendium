import 'package:compendium/data/person.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// # Attribute
///
/// This is a single attribute of a person.
class Attribute extends StatelessWidget {
  Attribute({this.name, this.value, this.icon, this.personID, this.onChange});

  /// The name of the attribute
  final String name;

  /// The value of the attribute
  final String value;

  /// The icon to be displayed before the name of the attribute
  final Icon icon;

  /// The ID of the person this attribute is attached to
  @required
  final int personID;

  /// This fires off whenever the user adds a new attribute or finishes an edit.
  final void Function() onChange;

  /// Creates a new [Attribute] and immediately calls editData() to bring up the dialog
  static Attribute fromDialog(BuildContext context, int personID, void Function() onChange) {
    Attribute newAttribute = Attribute(personID: personID, onChange: onChange);
    newAttribute.editData(context);
    return newAttribute;
  }

  /// Creates a dialog where the user can edit the attribute name and value
  void editData(BuildContext context) {
    Person person = Hive.box<Person>('people').getAt(personID);

    TextEditingController attributeController = TextEditingController();
    TextEditingController valueController = TextEditingController();

    if (name != null) attributeController.text = name;
    if (value != null) valueController.text = value;

    person.datablocks ??= {};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: Container(
            height: 250,
            child: Column(
              children: [
                TextField(
                  controller: attributeController,
                  decoration: InputDecoration(labelText: "Attribute Name"),
                ),
                TextField(
                  controller: valueController,
                  decoration: InputDecoration(labelText: "Attribute Value"),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: (person.datablocks.containsKey(name)) ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              person.datablocks ??= {};
                              // if the attribute name changes we need to remove the old one
                              // and add the new one
                              if (attributeController.text != name) {
                                person.datablocks.remove(name);
                              }
                              person.datablocks[attributeController.text] = valueController.text;

                              Hive.box<Person>('people').putAt(personID, person);
                              Navigator.of(context, rootNavigator: true).pop('dialog');

                              onChange();
                            },
                            child: Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          // if it doesn't exist, don't show delete
                          (person.datablocks.containsKey(name))
                              ? RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    person.datablocks.remove(attributeController.text);

                                    Hive.box<Person>('people').putAt(personID, person);
                                    Navigator.of(context, rootNavigator: true).pop('dialog');

                                    onChange();
                                  },
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                      RaisedButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () => Navigator.of(context, rootNavigator: true).pop('dialog'),
                        child: Text(
                          (person.datablocks.containsKey(name)) ? "Cancel" : "Discard",
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
    return Container(
      height: 50,
      decoration: BoxDecoration(color: Colors.blueGrey[50], borderRadius: BorderRadius.circular(10.0)),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name == null ? "" : name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  value == null ? "" : value,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
    );
  }
}
