import 'package:compendium/data/person.dart';
import 'package:compendium/widgets/person_view.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() {
    return _IndexScreenState();
  }
}

class _IndexScreenState extends State<IndexScreen> {
  var box = Hive.box('people');

  var firstnameGetter = TextEditingController();
  var lastnameGetter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Index Screen'),
      ),
      body: Container(
          child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, box, widget) {
                return _buildListView(context, box);
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () => getNewPerson(
                context: context,
                firstnameController: firstnameGetter,
                lastnameController: lastnameGetter)
            .then((val) => box.add(val)),
        child: Icon(Icons.add),
      ),
    );
  }

  ListView _buildListView(context, peopleBox) {
    return ListView.separated(
      itemCount: peopleBox.length,
      itemBuilder: (context, index) {
        Person person = peopleBox.getAt(index);
        return ListTile(
          title: Text(person.firstName + " " + person.lastName),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PersonView(personID: index),
          )),
        );
      },
      separatorBuilder: (context, index) => Divider(
          height: 20,
          indent: MediaQuery.of(context).size.width * 0.05,
          endIndent: MediaQuery.of(context).size.width * 0.05),
    );
  }
}

// Pass the controllers so they can be diposed outside in state manganger widget
Future<Person> getNewPerson({
  @required BuildContext context,
  @required TextEditingController firstnameController,
  @required TextEditingController lastnameController,
}) async {
  TextEditingController firstnameGetter = firstnameController;
  TextEditingController lastnameGetter = lastnameController;

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
                    controller: firstnameGetter,
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
                    controller: lastnameGetter,
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
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Submit"),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        item = Person(
                            firstName: firstnameGetter.text,
                            lastName: lastnameGetter.text);
                        _formKey.currentState.save();

                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        );
      }).then((val) {});

  if (item == null) {
    return Future.error("Dialog closed before data could be retrived");
  } else {
    return Future.value(item);
  }
}
