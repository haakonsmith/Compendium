import 'package:compendium/BLoC/people_bloc.dart';
import 'package:compendium/data/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() {
    return _IndexScreenState();
  }
}

class _IndexScreenState extends State<IndexScreen> {
  PeopleBloc get bloc => Provider.of<PeopleBloc>(context, listen: false);

  var firstnameGetter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    developer.log('log me', name: 'my.app.category');

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo list'),
      ),
      body: StreamBuilder<List<Person>>(
        stream: bloc.homeScreenPeople,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Align(
              alignment: Alignment.center,
              child: Text('Loading...'),
            );
          }

          final people = snapshot.data;

          if (people.length == 0) {
            return const Align(
              alignment: Alignment.center,
              child: Text('Try adding a person'),
            );
          }
          developer.log(people.length.toString(), name: 'my.app.category');

          return ListView.builder(
            itemCount: people.length,
            itemBuilder: (context, index) {
              return Text(people[index].firstName);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => getNewPerson(
                      context: context, firstnameController: firstnameGetter)
                  .then((val) {
                developer.log(val.firstName + "adding",
                    name: 'my.app.category');
                bloc.addPerson(val);
                developer.log(val.firstName + " adding 2",
                    name: 'my.app.category');
              })),
    );
  }

  @override
  void dispose() {
    firstnameGetter.dispose();
    super.dispose();
  }
}

// Pass the controllers so they can be diposed outside in state manganger widget
Future<PersonData> getNewPerson({
  @required BuildContext context,
  @required TextEditingController firstnameController,
}) async {
  TextEditingController firstnameGetter = firstnameController;

  final _formKey = GlobalKey<FormState>();

  PersonData item;

  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Submit"),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        item = PersonData(firstName: firstnameGetter.text);
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

  developer.log(item.firstName, name: 'my.app.category');

  if (item == null) {
    developer.log(item.firstName + "Error", name: 'my.app.category');
    return Future.error("Dialog closed before data could be retrived");
  } else {
    return Future.value(item);
  }
}
