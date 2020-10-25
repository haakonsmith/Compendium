import 'package:compendium/data/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PersonView extends StatefulWidget {
  static final String routeName = '/person';
  final int personID;

  PersonView({Key key, @required this.personID}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PersonViewState();
  }
}

class _PersonViewState extends State<PersonView> {
  var peopleBox = Hive.box('people');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(peopleBox.getAt(widget.personID).firstName),
      ),
      body: Container(
          alignment: Alignment.center,
          child: ValueListenableBuilder(
            valueListenable: peopleBox.listenable(),
            builder: (context, box, widget) => _buildListView(context, box),
          )),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add)),
    );
  }

  Widget _buildListView(context, peopleBox) {
    var person = peopleBox.getAt(widget.personID);
    if (person.datablocks == null) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('No data here :)'),
          ]);
    }

    return ListView.builder(
      itemCount: person.datablocks,
      itemBuilder: (context, index) {
        return ListTile(title: Text(person.firstName + " " + person.lastName));
      },
    );
  }
}
