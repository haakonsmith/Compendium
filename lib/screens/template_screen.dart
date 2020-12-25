import 'package:compendium/data/BLoC/template_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:compendium/theme.dart';
import 'package:compendium/widgets/attributes.dart';
import 'package:compendium/widgets/nav_drawer.dart';
import 'package:compendium/widgets/pill_appbar.dart';
import 'package:flutter/material.dart';

class TemplateScreen extends StatefulWidget {
  static String routeName = "/templates";

  @override
  _TemplateScreenState createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  TemplateBloc templateBloc;

  @override
  Widget build(BuildContext context) {
    templateBloc = TemplateBloc.of(context, listen: true);

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PillAppBar(title: Text("Settings")),
        drawer: NavDrawer(),
        body: Container(
          child: templateBloc.loading ? CompendiumThemeData.of(context).dataLoadingIndicator : _listViewBuilder(templateBloc.templates),
        ));
  }

  ListView _listViewBuilder(List<Datablock> templates) {
    templateBloc.reInit();
    return ListView.builder(
      itemCount: templates.length,
      itemBuilder: (context, index) {
        var attribute = Attribute(
          onChange: () => setState(() => {}),
          onTap: () => templateBloc.reInit(),
          datablock: templates[index],
          index: index,
        );
        return attribute.build(context);
      },
    );
  }
}
