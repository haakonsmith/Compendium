import 'package:compendium/data/person.dart';
import 'package:compendium/screens/personScreen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  Box<Person> box;

  @override
  Widget build(BuildContext context) {
    box = Provider.of<Box<Person>>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('People'),
      ),
      body: Container(
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, box, widget) {
            return _buildListView(context, box);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => getNewPerson(
          context: context,
        ).then((val) {
          val.databoxID = box.length.toString();
          box.add(val);
        }),
        child: Icon(Icons.add),
      ),
    );
  }

  ListView _buildListView(BuildContext context, Box<Person> peopleBox) {
    return ListView.separated(
      itemCount: peopleBox.length,
      itemBuilder: (context, index) {
        Person person = peopleBox.getAt(index);
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(person.firstName + " " + person.lastName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      title: Text('Are you sure?'),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              box.deleteAt(index);
                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');
                            },
                          ),
                          RaisedButton(
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PersonView(personIndex: index),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
          height: 20,
          indent: MediaQuery.of(context).size.width * 0.05,
          endIndent: MediaQuery.of(context).size.width * 0.05),
    );
  }
}

Future<Person> getNewPerson({
  @required BuildContext context,
}) async {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Person item;

  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('Add person'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Enter firstname'),
                    controller: firstnameController,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Enter lastname'),
                    controller: lastnameController,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            item = Person(
                              firstName: firstnameController.text,
                              lastName: lastnameController.text,
                              databoxID: "",
                            );

                            item.firstName =
                                "${item.firstName[0].toUpperCase()}${item.firstName.substring(1)}";
                            item.lastName =
                                "${item.lastName[0].toUpperCase()}${item.lastName.substring(1)}";

                            // Keep form state incase user wants to go back to form
                            _formKey.currentState.save();

                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');
                          }
                        },
                      ),
                      RaisedButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () =>
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog'),
                        child: Text(
                          "Discard",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });

  if (item == null) {
    return Future.error("Dialog closed before data could be retrieved");
  } else {
    return Future.value(item);
  }
}
