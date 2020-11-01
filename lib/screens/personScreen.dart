import 'package:compendium/data/person.dart';
import 'package:compendium/widgets/attributes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class PersonView extends StatefulWidget {
  static final String routeName = '/person';
  final int personID;

  PersonView({Key key, @required this.personID}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {
  Person person;

  @override
  Widget build(BuildContext context) {
    person ??= Hive.box<Person>('people').getAt(widget.personID);
    return Scaffold(
      // probably need to add a top selecting thing kinda like channel page in the Youtube app
      appBar: AppBar(
        title: Text(person.firstName),
      ),
      body: Center(
        child: _buildListView(context),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        // this is kinda unnecessary because as soon as setState is called it will make a new Attribute
        // so I'm just doing this to avoid copy-pasting the dialog code here too
        onPressed: () => Attribute.fromDialog(context, widget.personID, () => setState(() {})),
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    if (person.datablocks == null) {
      return Center(
        child: Text(
          'No data here :)\nTry adding some with the add button\nin the bottom right corner.',
          textAlign: TextAlign.center,
        ),
      );
    }

    List<Widget> attributes = [];
    person.datablocks.forEach((key, value) {
      attributes.add(Attribute(
        name: key,
        value: value,
        personID: widget.personID,
        onChange: () => setState(() {}),
      ));
    });

    return ListView(
      children: attributes,
    );
  }
}
