import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:compendium/data/person.dart';
import 'package:compendium/widgets/attributes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class PersonView extends StatefulWidget {
  static final String routeName = '/person';
  final int personIndex;

  PersonView({Key key, @required this.personIndex}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {
  Box<Datablock> datablocksBox;
  bool loading = true;
  PersonBloc personInterface;
  Person person;

  Future<void> loadData() async {
    personInterface = Provider.of<PersonBloc>(context);
    await personInterface.setActivePerson(person);

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    person = Provider.of<Box<Person>>(context).getAt(widget.personIndex);

    if (loading) {
      loadData();
    }

    return Scaffold(
      // probably need to add a top selecting thing kinda like channel page in the Youtube app
      appBar: AppBar(
        title: Text(person.firstName),
      ),
      body: Center(
        child: loading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              )
            : ValueListenableBuilder(
                valueListenable: personInterface.listenForDatablocks(),
                builder: (context, box, widget) {
                  return _buildListView(context, box);
                }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        // this is kinda unnecessary because as soon as setState is called it will make a new Attribute
        // so I'm just doing this to avoid copy-pasting the dialog code here too
        onPressed: () => getNewDatablock(
          context: context,
        ).then((val) => personInterface.addDatablockToActivePerson(val)),
      ),
    );
  }

  Widget _buildListView(BuildContext context, Box datablockBox) {
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
        return datablockBox.getAt(index).build(context);
      },
    );
  }

// Pass the controllers so they can be disposed outside in state manager widget
  Future<Datablock> getNewDatablock({
    @required BuildContext context,
  }) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController colourController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    Datablock item;

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Add person'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Enter datablock title'),
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
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Enter colour'),
                      controller: colourController,
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
                              item = Datablock(
                                name: nameController.text,
                                // TODO implement proper colour picker
                                colourValue: Colors.black.value,
                              );

                              _formKey.currentState
                                  .save(); // what does this do?

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
}
