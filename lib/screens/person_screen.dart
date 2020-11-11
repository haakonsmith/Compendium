import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:compendium/data/person.dart';
import 'package:compendium/theme.dart';
import 'package:compendium/vendor/color_picker.dart';
import 'package:compendium/widgets/attributes.dart';
import 'package:compendium/widgets/color_form_field.dart';
import 'package:compendium/widgets/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class PersonScreen extends StatefulWidget {
  static final String routeName = '/person';
  final int personIndex;

  PersonScreen({Key key, this.personIndex}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  Box<Datablock> datablocksBox;
  bool loading = true;
  PersonBloc personBloc;

  @override
  Widget build(BuildContext context) {
    personBloc = PersonBloc.of(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(personBloc.activePerson.firstName),
      ),
      // drawer: NavDrawer(),
      body: Container(
        child: personBloc.loading
            ? CompendiumThemeData.of(context).dataLoadingIndicator
            : ValueListenableBuilder(
                valueListenable: personBloc.listenForDatablocks(),
                builder: (context, box, widget) {
                  return _buildListView(context, box);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        // this is kinda unnecessary because as soon as setState is called it will make a new Attribute
        // so I'm just doing this to avoid copy-pasting the dialog code here too
        onPressed: () => getNewDatablock(context).then(
          (val) => personBloc.addDatablockToActivePerson(val),
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context, Box<Datablock> datablockBox) {
    if (datablockBox.length == 0) {
      return Center(
        child: Text(
          'No data here :)\nTry adding some with the add button\nin the bottom right corner.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: datablockBox.length,
      itemBuilder: (context, index) {
        return datablockBox.getAt(index).buildPreview(context, index);
      },
    );
  }

  Future<Datablock> getNewDatablock(BuildContext context) async {
    TextEditingController nameController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    Datablock item;
    var colourController = Colors.black;

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            title: Text('Add Category'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(labelText: 'Enter category title'),
                      controller: nameController,
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: ColorFormField(
                      onChanged: (color) => colourController = color,
                      // Black by default, there's probably a better way to do this
                      initialColor: colourController == null ? Colors.black : colourController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () => Navigator.of(context, rootNavigator: true).pop('dialog'),
                          child: Text(
                            "Discard",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        RaisedButton(
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              item = Datablock(
                                name: "${nameController.text[0].toUpperCase()}${nameController.text.substring(1)}",
                                colourValue: colourController.value,
                              );

                              _formKey.currentState.save(); // what does this do?

                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          },
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
}
