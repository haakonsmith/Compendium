import 'package:compendium/BLoC/bloc.dart';
import 'package:compendium/data/model.dart';
import 'package:compendium/data/profiles/data_block.dart';

class PersonBloc extends Bloc {
  final CompendiumDatabase db;
  PersonBloc(CompendiumDatabase database) : db = database {}

  Stream<List<DataBlock>> viewPerson(int personID) {
    
  }
}
