import 'package:compendium/BLoC/people_bloc.dart';
import 'package:compendium/data/model.dart';
import 'package:compendium/widgets/nav_drawer.dart';
import 'package:compendium/widgets/person_view.dart';
import 'package:compendium/widgets/popups/person_creation_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IndexScreen extends StatefulWidget {
  static final String routeName = '/index';

  @override
  _IndexScreenState createState() {
    return _IndexScreenState();
  }
}

class _IndexScreenState extends State<IndexScreen> {
  PeopleBloc get bloc =>
      PeopleBloc(Provider.of<CompendiumDatabase>(context, listen: false));

  var firstnameGetter = TextEditingController();
  var surnameGetter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('People index'),
      ),
      drawer: NavDrawer(),
      body: Column(children: [
        Expanded(
            child: StreamBuilder<List<Person>>(
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

            return ListView.builder(
              itemCount: people.length,
              itemBuilder: (context, index) {
                return Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                        color: Colors.red,
                        child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PersonView())),
                            child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ]),
                                child: Row(children: <Widget>[
                                  Text(people[index].firstName),
                                  SizedBox(width: 10),
                                  Text(
                                    people[index].surName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ])))));
              },
            );
          },
        ))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => getNewPerson(
                context: context,
                firstnameController: firstnameGetter,
                surnameController: surnameGetter)
            .then((val) => bloc.addPerson(val)),
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    firstnameGetter.dispose();
    super.dispose();
  }
}
