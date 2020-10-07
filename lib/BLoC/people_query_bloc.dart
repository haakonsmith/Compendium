import 'dart:async';

import 'package:compendium/data/model.dart';

import 'bloc.dart';

// class PeopleQueryBloc implements Bloc {
//   final _controller = StreamController<List<People>>();
//   final CompendiumDatabase _database = CompendiumDatabase();
//   Stream<List<People>> get peopleStream => _controller.stream;

//   void submitQuery(String query) async {
//     final results = await _database.people(query);
//     _controller.sink.add(results);
//   }

//   @override
//   void dispose() {
//     _controller.close();
//   }
// }