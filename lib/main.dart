import 'package:compendium/widgets/index_screen.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:compendium/data/person.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(PersonAdapter());

  await Hive.openBox('settings');
  await Hive.openBox('people');

  runApp(CompendiumApp());
}

class CompendiumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Compendium",
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        typography: Typography.material2018(),
      ),
      home: IndexScreen(),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Demo Settings',
//       home: Scaffold(
//         backgroundColor:
//             Hive.box('settings').get('darkMode') ? Colors.white : Colors.black,
//         body: ValueListenableBuilder(
//           valueListenable: Hive.box('settings').listenable(),
//           builder: (context, box, widget) {
//             return Center(
//               child: Switch(
//                 value: box.get('darkMode', defaultValue: false),
//                 onChanged: (val) {
//                   box.put('darkMode', val);
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
