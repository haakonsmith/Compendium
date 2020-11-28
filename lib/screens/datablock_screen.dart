import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:compendium/theme.dart';
import 'package:compendium/widgets/attributes.dart';
import 'package:compendium/widgets/pill_appbar.dart';
import 'package:flutter/material.dart';

class DatablockScreen extends StatefulWidget {
  DatablockScreen({Key key, this.datablockIndex}) : super(key: key);

  static final String routeName = '/datablock';
  final int datablockIndex;

  @override
  State<StatefulWidget> createState() => _DatablockScreenState();
}

class _DatablockScreenState extends State<DatablockScreen> {
  Datablock datablock;

  @override
  Widget build(BuildContext context) {
    datablock = PersonBloc.of(context).activePersonBox.getAt(widget.datablockIndex);

    return Scaffold(
      appBar: PillAppBar(
        title: Text(datablock.name),
        backgroundColor: Color(datablock.colourValue),
      ),
      body: Container(
        child: PersonBloc.of(context).loading ? CompendiumThemeData.of(context).dataLoadingIndicator : _buildListView(context, datablock),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(datablock.colourValue),
        child: Icon(Icons.add),
        // this is kinda unnecessary because as soon as setState is called it will make a new Attribute
        // so I'm just doing this to avoid copy-pasting the dialog code here too
        onPressed: () => Attribute.fromDialog(
          context,
          widget.datablockIndex,
          onChange: () => setState(() {}),
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context, Datablock datablock) {
    if (datablock.attributes == null || datablock.attributes.length == 0) {
      return Center(
        child: Text(
          'No data here :)\nTry adding some with the add button\nin the bottom right corner.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: datablock.attributes.length,
      itemBuilder: (context, index) {
        var attribute = datablock.attributes.entries.elementAt(index);
        return Attribute(
          name: attribute.key,
          value: attribute.value,
          datablockIndex: widget.datablockIndex,
          onChange: () => setState(() {}),
        );
      },
    );
  }
}
