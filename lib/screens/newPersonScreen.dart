import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:compendium/data/BLoC/screen_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:compendium/data/person.dart';
import 'package:compendium/vendor/color_picker.dart';
import 'package:compendium/widgets/attributes.dart';
import 'package:compendium/widgets/color_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class PersonScreen extends StatefulWidget {
  static final String routeName = '/person';

  @override
  State<StatefulWidget> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  Box<Datablock> datablocksBox;
  Box<Person> box;
  bool loading = true;
  PersonBloc personBloc;
  ScreenBloc screenBloc;
  Person person;

  Future<void> load() async {
    datablocksBox = await Hive.openBox<Datablock>(person.databoxID);
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    personBloc = Provider.of<PersonBloc>(context);
    screenBloc = Provider.of<ScreenBloc>(context);
    screenBloc.context = context;

    box = Hive.box<Person>('people');
    person = box.get(screenBloc.personId);

    print(person);

    if (person == null) {
      Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
      person = Person.blank();
    }

    if (loading) {
      load();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => screenBloc.clearPerson(),
        ),
        title: Text(person.firstName),
      ),
      body: Center(
        child: loading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              )
            : _buildListView(context, datablocksBox),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        // this is kinda unnecessary because as soon as setState is called it will make a new Attribute
        // so I'm just doing this to avoid copy-pasting the dialog code here too
        onPressed: () => getNewDatablock(context),
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
        return datablockBox.getAt(index).buildPreview(context);
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
            title: Text('Add Datablock'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Enter datablock title'),
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
                      child: ColorFormField(
                        onChanged: (color) => (colourController = color),
                        // Black by default, there's probably a better way to do this
                        intialColor: colourController == null ? Colors.black : colourController,
                      )),
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
                            print(colourController);
                            if (_formKey.currentState.validate()) {
                              item = Datablock(name: nameController.text, colourValue: colourController.value);

                              datablocksBox.add(item);

                              _formKey.currentState.save(); // what does this do?

                              Navigator.of(context, rootNavigator: true).pop('dialog');
                            }
                          },
                        ),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () => Navigator.of(context, rootNavigator: true).pop('dialog'),
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
