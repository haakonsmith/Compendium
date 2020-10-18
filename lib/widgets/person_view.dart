import 'package:compendium/BLoC/person_bloc.dart';
import 'package:compendium/data/model.dart';
import 'package:compendium/data/profiles/data_block.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

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
  PersonBloc get bloc =>
      PersonBloc(Provider.of<CompendiumDatabase>(context, listen: false));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Expanded(child: Text("")
          //   child: StreamBuilder<List<DataBlock>>(
          // stream: bloc.viewPerson(personID),
          // builder: ListView.builder(context, snapshot),
          )
    ]));
  }
}
