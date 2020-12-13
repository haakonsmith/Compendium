import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:compendium/routers/nested_page_route.dart';
import 'package:compendium/theme.dart';
import 'package:compendium/widgets/attributes.dart';
import 'package:compendium/widgets/pill_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Fundamentally all a datablock screen needs is a list of datablocks. This can either be the root datablock box or datablock.children
class DatablockScreen extends StatefulWidget {
  DatablockScreen({Key key, this.datalistfuture}) : super(key: key);

  static final String routeName = '/datablock';
  Future<List<Datablock>> datalistfuture;

  @override
  State<StatefulWidget> createState() => _DatablockScreenState();
}

class _DatablockScreenState extends State<DatablockScreen> {
  bool _loading = true;
  Datablock datablock;

  @override
  Widget build(BuildContext context) {
    // Good sir please rebuild widget when this changes  \/
    datablock = PersonBloc.of(context, listen: true).activeDatablock ??
        Datablock("Loading...", "",
            colourValue: Theme.of(context).primaryColor.value);

    return Scaffold(
      appBar: PillAppBar(
        title: Text(datablock.name),
        onBackButtonPressed: () {
          PersonBloc.of(context).popNesting();
          Navigator.of(context).pop();
        },
        backgroundColor: Color(datablock.colourValue),
      ),
      body: Container(
        child: PersonBloc.of(context).loading
            ? CompendiumThemeData.of(context).dataLoadingIndicator
            : _buildListView(context, datablock.children),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(datablock.colourValue),
        child: Icon(Icons.add),
        // this is kinda unnecessary because as soon as setState is called it will make a new Attribute
        // so I'm just doing this to avoid copy-pasting the dialog code here too
        onPressed: () => Attribute.fromDialog(
          context,
          onChange: () => setState(() {}),
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context, List<Datablock> datablocks) {
    // if (datablock.attributes == null || datablock.attributes.length == 0) {
    //   return Center(
    //     child: Text(
    //       'No data here :)\nTry adding some with the add button\nin the bottom right corner.',
    //       textAlign: TextAlign.center,
    //     ),
    //   );
    // }

    return ListView.builder(
        itemCount: datablocks.length,
        itemBuilder: (context, index) {
          var attribute = Attribute(
              onChange: () => setState(() => {}),
              onTap: () {
                PersonBloc.of(context).nestFurther(index);
                Navigator.of(context).push(
                    NestedPageRoute(builder: (context) => DatablockScreen()));
              },
              datablock: datablocks[index],
              index: index);
          return attribute.build(context);
          // return InkWell(
          //     onTap: () {
          //       PersonBloc.of(context).nestFurther(index);
          //       Navigator.of(context).push(
          //           NestedPageRoute(builder: (context) => DatablockScreen()));
          //     },
          //     child: Row(
          //       children: [
          //         Text(child.value),
          //       ],
          //     ));
          // .addDatablockToActiveDatablock(
          //     Attribute.fromDialog(context).datablock)),
        });
  }

  // Widget _buildListView(BuildContext context, Datablock datablock) {
  //   if (datablock.children == null || datablock.children.length == 0) {
  //     return Center(
  //       child: Text(
  //         'No data here :)\nTry adding some with the add button\nin the bottom right corner.',
  //         textAlign: TextAlign.center,
  //       ),
  //     );
  //   }

  //   return ListView.builder(
  //     itemCount: datablock.children.length,
  //     itemBuilder: (context, index) {
  //       var attribute = Attribute(
  //           onChange: () => setState(() => {}),
  //           onTap: () {
  //             Navigator.of(context).pushNamed(
  //                 ModalRoute.of(context).settings.name +
  //                     "/datablock/" +
  //                     index.toString());
  //           },
  //           datablock: datablock.children.elementAt(index));
  //       return attribute.build(context);
  //     },
  //   );
  //   // return Text("test");
  // }
}
