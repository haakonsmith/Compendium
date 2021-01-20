import 'dart:async';

import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import '../data/datablock.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class DatablockPreview extends StatelessWidget {
  DatablockPreview(this.datablock, this.index, {this.onTap, this.onEdit});

  final Datablock datablock;
  final int index;

  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return datablock.metadata.isCategory ? buildCategory(context) : buildAttribute(context);
  }

  Widget buildAttribute(BuildContext context) {
    Widget header = Align(
        alignment: Alignment.topLeft,
        child: Text(
          datablock.name,
          style: TextStyle(fontSize: 17),
        ));

    Row content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              header,
              SizedBox(
                height: 10,
              ),
              valueStyle(context)
            ],
          ),
        ),
        Center(
          child: IconButton(icon: Icon(Icons.more_vert_outlined), onPressed: onEdit),
        )
      ],
    );

    return displayStyle(context: context, child: content);
  }

  Widget buildCategory(BuildContext context) {
    Widget header = Align(
        alignment: Alignment.topLeft,
        child: Text(
          datablock.name,
          style: TextStyle(fontSize: 17),
        ));

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [header, Text('test')],
        ),
        IconButton(icon: Icon(Icons.more_vert_outlined), onPressed: onEdit)
      ],
    );

    final defaultCard = Card(
      elevation: 1,
      color: HSLColor.fromAHSL(1, 1, 0, 1).toColor(),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: onTap,
        child: Container(padding: EdgeInsets.all(10), constraints: BoxConstraints.loose(Size.fromHeight(200)), child: Text("Nothing to preview")),
      ),
    );

    return categoryDisplayStyle(context: context, child: datablock.children.isEmpty ? defaultCard : content);
  }

  Widget valueStyle(BuildContext context) {
    switch (datablock.metadata.valueStyle) {
      case DatablockValueStyle.bar:
        final barValue = (datablock.value != "") ? int.tryParse(datablock.value) : 0;

        print(datablock.metadata.valueStyle);
        if (barValue == null)
          return Text("Datablock value must be int parseable");
        else
          return Container(
            height: 40,
            width: double.infinity,
            child: FAProgressBar(
              currentValue: barValue,
              displayText: "%",
            ),
          );

        break;
      case DatablockValueStyle.textarea:
        TextEditingController controller = TextEditingController(text: datablock.value);
        Timer saveTimer;
        return TextField(
          keyboardType: TextInputType.multiline,
          decoration: null,
          maxLines: null,
          controller: controller,
          onChanged: (text) {
            datablock.value = text;

            saveTimer = Timer(Duration(seconds: 1), () => PersonBloc.of(context, listen: false).updateDatablockFromActive(datablock, index));
          },
        );
        break;
      default:
        return Text(
          datablock.value,
          textAlign: TextAlign.left,
        );
    }
  }

  Widget displayStyle({BuildContext context, Widget child}) {
    switch (datablock.metadata.displayStyle) {
      case DatablockDisplayStyle.stacked:
        final List datablockIndices = Iterable<int>.generate(min(datablock.children.length, 3)).toList();

        final List lightness = [1.0, 0.99, 0.98].toList();

        print(child);

        final stackCards = datablockIndices.reversed.map((index) {
          final card = Card(
            elevation: 1,
            color: HSLColor.fromAHSL(1, 1, 0, lightness[index]).toColor(),
            margin: EdgeInsets.only(top: 7.0 * (index + 1), left: 5, right: 5),
            child: Container(padding: EdgeInsets.all(10), constraints: BoxConstraints.loose(Size.fromHeight(100)), child: child),
          );

          return card;
        }).toList();

        return Container(
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: datablock.children.isEmpty ? [child] : stackCards,
          ),
        );
        break;
      default:
        return Card(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Container(
            padding: EdgeInsets.all(10),
            // constraints: BoxConstraints.tightFor(height: 120),
            child: child,
          ),
        );
    }
  }

  Widget categoryDisplayStyle({BuildContext context, Widget child}) {
    switch (datablock.metadata.displayStyle) {
      case DatablockDisplayStyle.stacked:
        final List datablockIndices = Iterable<int>.generate(min(datablock.children.length, 3)).toList();

        final List lightness = [1.0, 0.99, 0.98].toList();

        print(child);

        final stackCards = datablockIndices.reversed.map((index) {
          final card = Card(
            elevation: 1,
            color: HSLColor.fromAHSL(1, 1, 0, lightness[index]).toColor(),
            margin: EdgeInsets.only(top: 7.0 * (index + 1), left: 5, right: 5),
            child: InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: onTap,
              child: Container(padding: EdgeInsets.all(10), constraints: BoxConstraints.loose(Size.fromHeight(80)), child: child),
            ),
          );

          return card;
        }).toList();

        return Container(
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: datablock.children.isEmpty ? [child] : stackCards,
          ),
        );
        break;
      default:
        return InkWell(
          onTap: onTap,
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Container(
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints.tightFor(height: 60),
              child: child,
            ),
          ),
        );
    }
  }
}
