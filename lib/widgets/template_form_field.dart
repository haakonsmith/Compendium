import 'package:compendium/data/BLoC/template_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TemplateFormField extends StatefulWidget {
  final void Function(int value) onChange;

  TemplateFormField({this.onChange});

  @override
  _TemplateFormFieldState createState() => _TemplateFormFieldState();
}

class _TemplateFormFieldState extends State<TemplateFormField> {
  int selectedTemplateIndex = 0;
  List<Datablock> templates;

  @override
  Widget build(BuildContext context) {
    templates = TemplateBloc.of(context, listen: true).templates;

    return Row(children: [
      Text('Template: '),
      DropdownButton<int>(
        value: selectedTemplateIndex,
        icon: Icon(Icons.arrow_right_rounded),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: templates[selectedTemplateIndex].color),
        underline: Container(
          height: 2,
          color: templates[selectedTemplateIndex].color,
        ),
        onChanged: (int newValue) => setState(() {
          widget.onChange(newValue);
          selectedTemplateIndex = newValue;
        }),
        items: List<int>.generate(TemplateBloc.of(context).templates.length, (i) => i).map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(TemplateBloc.of(context, listen: true).templates[value].name),
          );
        }).toList(),
      )
    ]);
  }
}
