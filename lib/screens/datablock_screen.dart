import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:compendium/routers/nested_page_route.dart';
import 'package:compendium/theme.dart';
import 'package:compendium/widgets/attributes.dart';
import 'package:compendium/widgets/contextual_floating_action_button.dart';
import 'package:compendium/widgets/pill_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Fundamentally all a datablock screen needs is a list of datablocks. This can either be the root datablock box or datablock.children
class DatablockScreen extends StatefulWidget {
  DatablockScreen({Key key, this.dataListFuture}) : super(key: key);

  static final String routeName = '/datablock';
  Future<List<Datablock>> dataListFuture;

  @override
  State<StatefulWidget> createState() => _DatablockScreenState();
}

class _DatablockScreenState extends State<DatablockScreen> {
  Datablock datablock;

  @override
  Widget build(BuildContext context) {
    // Good sir please rebuild widget when this changes  \/
    datablock = PersonBloc.of(context, listen: true).activeDatablock ?? Datablock("Loading...", "", colorValue: Theme.of(context).primaryColor.value);

    return Scaffold(
      appBar: PillAppBar(
        title: Text(datablock.name),
        onBackButtonPressed: () {
          PersonBloc.of(context).popNesting();
          Navigator.of(context).pop();
        },
        backgroundColor: Color(datablock.colorValue),
      ),
      body: Container(
        child: PersonBloc.of(context).loading ? CompendiumThemeData.of(context).dataLoadingIndicator : _buildListView(context, datablock.children),
      ),
      floatingActionButton: ContextualFloatingActionBar(
        backgroundColor: Color(datablock.colorValue),
        children: [
          ContextualFloatingActionButton(
              icon: Icon(Icons.add),
              onPressed: () => Attribute.fromDialog(
                    context,
                    onChange: () => setState(() {}),
                  )),
          if (datablock.metadata.suggestedChild != null)
            ContextualFloatingActionButton(
              icon: Icon(Icons.add_chart),
              onPressed: () => PersonBloc.of(context).addDatablockToActive(datablock.metadata.suggestedChild),
            )
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context, List<Datablock> datablocks) {
    return ListView.builder(
        itemCount: datablocks.length,
        itemBuilder: (context, index) {
          var attribute = Attribute(
            onTap: () {
              PersonBloc.of(context).nestFurther(index);
              Navigator.of(context).push(NestedPageRoute(builder: (context) => DatablockScreen()));
            },
            datablock: datablocks[index],
            index: index,
          );
          return attribute.build(context);
        });
  }
}
