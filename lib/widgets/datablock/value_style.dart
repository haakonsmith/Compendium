import 'dart:async';

import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class BarValueStyle extends StatelessWidget {
  final String value;

  const BarValueStyle({Key key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final barValue = (value != "") ? int.tryParse(value) : 0;

    if (barValue == null)
      return Text("Datablock value must be int parseable");
    else
      return Container(
        height: 40,
        width: double.infinity,
        child: FAProgressBar(
          currentValue: 2,
          displayText: "%",
        ),
      );
  }
}

class TextAreaValueStyle extends StatelessWidget {
  final Datablock datablock;
  final int index;

  const TextAreaValueStyle({Key key, this.datablock, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  }
}
