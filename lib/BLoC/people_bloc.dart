import 'dart:async';

import 'package:compendium/BLoC/bloc.dart';
import 'package:compendium/data/model.dart';
import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as developer;

class PersonData {
  final String firstName;

  PersonData({this.firstName});
}

// A bloc for the people overview
class PeopleBloc implements Bloc {
  final CompendiumDatabase db;

  Stream<List<Person>> _currentPeople;

  /// A stream of People that should be displayed on the home screen.
  Stream<List<Person>> get homeScreenPeople => _currentPeople;

  PeopleBloc() : db = CompendiumDatabase() {
    // listen for the category to change. Then display all entries that are in
    // the current category on the home screen.
    _currentPeople = db.watchAllPeople;

    // also watch all categories so that they can be displayed in the navigation
    // drawer.
    // Observable.combineLatest2<List<CategoryWithCount>, Category,
    //     List<CategoryWithActiveInfo>>(
    //   db.categoriesWithCount(),
    //   _activeCategory,
    //   (allCategories, selected) {
    //     return allCategories.map((category) {
    //       final isActive = selected?.id == category.category?.id;

    //       return CategoryWithActiveInfo(category, isActive);
    //     }).toList();
    //   },
    // ).listen(_allCategories.add);
  }

  // void showCategory(Category category) {
  //   _activeCategory.add(category);
  // }

  // Future<void> addCategory(String description) async {
  //   final id = await db.createCategory(description);

  //   showCategory(Category(id: id, description: description));
  // }

  void addPerson(PersonData person) {
    developer.log(person.firstName, name: 'my.app.bloc');
    db.addPerson(PeopleCompanion(firstName: Value(person.firstName)));
  }

  // void updateEntry(TodoEntry entry) {
  //   db.updateEntry(entry);
  // }

  // void deleteEntry(TodoEntry entry) {
  //   db.deleteEntry(entry);
  // }

  // void deleteCategory(Category category) {
  //   // if the category being deleted is the one selected, reset that state by
  //   // showing the entries who aren't in any category
  //   if (_activeCategory.value?.id == category.id) {
  //     showCategory(null);
  //   }

  //   db.deleteCategory(category);
  // }

  // void close() {
  //   db.close();
  //   _allCategories.close();
  // }
  @override
  void dispose() {
    // _personController.close();
  }
}
//   TodoAppBloc() : db = Database() {
//     // listen for the category to change. Then display all entries that are in
//     // the current category on the home screen.
//     _currentEntries = _activeCategory.switchMap(db.watchEntriesInCategory);

//     // also watch all categories so that they can be displayed in the navigation
//     // drawer.
//     Observable.combineLatest2<List<CategoryWithCount>, Category,
//         List<CategoryWithActiveInfo>>(
//       db.categoriesWithCount(),
//       _activeCategory,
//       (allCategories, selected) {
//         return allCategories.map((category) {
//           final isActive = selected?.id == category.category?.id;

//           return CategoryWithActiveInfo(category, isActive);
//         }).toList();
//       },
//     ).listen(_allCategories.add);
//   }
// }
