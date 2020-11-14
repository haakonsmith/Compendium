import 'package:compendium/vendor/color_picker.dart';
import 'package:flutter/material.dart';

class ColorFormField extends StatefulWidget {
  ColorFormField({Key key, this.onChanged, @required this.initialColor});

  final Color initialColor;
  final void Function(Color) onChanged;

  @override
  State<StatefulWidget> createState() => _ColorFormFieldState();
}

class _ColorFormFieldState extends State<ColorFormField> {
  Color colorController;
  @override
  Widget build(BuildContext context) {
    colorController ??= widget.initialColor;

    return InkWell(
      onTap: () {
        getColor(context: context, initialColor: colorController).then((value) {
          widget.onChanged(value);
          setState(() => colorController = value);
        });
      },
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: colorController,
          ),
          SizedBox(width: 10),
          Text("Pick a colour")
        ],
      ),
    );
  }

  static Future<Color> getColor(
      {@required BuildContext context, @required Color initialColor}) async {
    Color colorController = initialColor;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Colour Picker"),
        content: Container(
          height: 300,
          child: Column(
            children: [
              CircleColorPicker(
                initialColor: initialColor,
                onChanged: (color) => (colorController = color),
                size: Size(240, 240),
                strokeWidth: 4,
                thumbSize: 36,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      // Make it null so we don't update anything if discarded
                      colorController = null;
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                    child: Text(
                      "Discard",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => Navigator.of(context, rootNavigator: true)
                        .pop('dialog'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

    if (colorController == null) {
      return Future.error("Dialog closed before data could be retrieved");
    } else {
      return Future.value(colorController);
    }
  }
}
