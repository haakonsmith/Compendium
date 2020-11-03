// import 'package:compendium/data/datablock.dart';
// import 'package:compendium/data/person.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';

// /// # Attribute
// ///
// /// This is a single attribute of a person.
// class Attribute extends StatelessWidget {
//   Attribute({
//     this.name,
//     this.value,
//     this.icon,
//     this.datablockIndex,
//     this.onChange,
//     this.boxName,
//   });

//   /// The name of the attribute
//   final String name;

//   /// The value of the attribute
//   final String value;

//   /// The icon to be displayed before the name of the attribute
//   final Icon icon;

//   /// The index of the data block this attribute is attached to
//   @required
//   final int datablockIndex;

//   /// This fires off whenever the user adds a new attribute or finishes an edit.
//   final void Function() onChange;

//   /// The name of the box that the data block sits within
//   final String boxName;

//   /// Creates a new [Attribute] and immediately calls editData() to bring up the dialog
//   static Attribute fromDialog(
//     BuildContext context,
//     String boxName,
//     int datablockIndex,
//     void Function() onChange,
//   ) {
//     Attribute newAttribute =
//         Attribute(datablockIndex: datablockIndex, onChange: onChange);
//     newAttribute.editData(context, boxName);
//     return newAttribute;
//   }

//   /// Creates a dialog where the user can edit the attribute name and value
//   void editData(BuildContext context, String boxName) {
//     Box<Datablock> datablockBox = Hive.box<Datablock>(boxName);

//     TextEditingController attributeController = TextEditingController();
//     TextEditingController valueController = TextEditingController();

//     if (name != null) attributeController.text = name;
//     if (value != null) valueController.text = value;

//     Datablock datablock;

//     if (datablockBox.length < datablockIndex) {
//       datablock = datablockBox.getAt(datablockIndex);
//     } else {
//       datablock = Datablock();
//     }

//     Datablock datablock = (name != null)
//         ? datablockBox.getAt(datablockIndex)
//         : datablockBox.putAt(datablockIndex);
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//           content: Container(
//             height: 250,
//             child: Column(
//               children: [
//                 TextField(
//                   controller: attributeController,
//                   decoration: InputDecoration(labelText: "Attribute Name"),
//                 ),
//                 TextField(
//                   controller: valueController,
//                   decoration: InputDecoration(labelText: "Attribute Value"),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(top: 30),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment:
//                             (datablock.attributes.containsKey(name))
//                                 ? MainAxisAlignment.spaceEvenly
//                                 : MainAxisAlignment.center,
//                         children: [
//                           RaisedButton(
//                             color: Theme.of(context).primaryColor,
//                             onPressed: () {
//                               datablock.attributes ??= {};
//                               // if the attribute name changes we need to remove the old one
//                               // and add the new one
//                               if (attributeController.text != name) {
//                                 datablock.attributes.remove(name);
//                               }
//                               datablock.attributes[attributeController.text] =
//                                   valueController.text;

//                               datablockBox.putAt(datablockIndex, datablock);
//                               Navigator.of(context, rootNavigator: true)
//                                   .pop('dialog');

//                               onChange();
//                             },
//                             child: Text(
//                               "Save",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                           // if it doesn't exist, don't show delete
//                           (datablock.attributes.containsKey(name))
//                               ? RaisedButton(
//                                   color: Theme.of(context).primaryColor,
//                                   onPressed: () {
//                                     datablock.attributes
//                                         .remove(attributeController.text);

//                                     datablockBox.putAt(
//                                         datablockIndex, datablock);
//                                     Navigator.of(context, rootNavigator: true)
//                                         .pop('dialog');

//                                     onChange();
//                                   },
//                                   child: Text(
//                                     "Delete",
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 )
//                               : Container()
//                         ],
//                       ),
//                       RaisedButton(
//                         color: Theme.of(context).primaryColor,
//                         onPressed: () =>
//                             Navigator.of(context, rootNavigator: true)
//                                 .pop('dialog'),
//                         child: Text(
//                           (datablock.attributes.containsKey(name))
//                               ? "Cancel"
//                               : "Discard",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//           color: Colors.blueGrey[50],
//           borderRadius: BorderRadius.circular(10.0)),
//       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.only(left: 10, right: 15),
//             child: icon == null ? Container() : icon,
//           ),
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   name == null ? "" : name,
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                 ),
//                 Text(
//                   value == null ? "" : value,
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                 )
//               ],
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.only(left: 15, right: 10),
//             child: IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: () => editData(context, boxName),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
