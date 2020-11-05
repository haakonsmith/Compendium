import 'package:compendium/vendor/color_picker.dart';
import 'package:flutter/material.dart';

class ColorFormField extends StatefulWidget {
  final Color intialColor;
  Color colorController;
  dynamic onChanged;

  ColorFormField({Key key, this.onChanged, @required this.intialColor}) : super(key: key) {
    colorController = intialColor;
  }

  @override
  State<StatefulWidget> createState() => _ColorFormFieldState();
}

class _ColorFormFieldState extends State<ColorFormField> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        getColor(context: context, intialColor: widget.intialColor).then((value) {
          widget.onChanged(value);
          setState(() => widget.colorController = value);
        });
      },
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: widget.colorController,
          ),
          SizedBox(width: 10),
          Text("Pick a colour")
        ],
      ),
    );
  }

  static Future<Color> getColor({@required BuildContext context, @required Color intialColor}) async {
    Color colorController = intialColor;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Colour Picker"),
        content: Column(
          children: [
            CircleColorPicker(
              initialColor: intialColor,
              onChanged: (color) => (colorController = color),
              size: const Size(240, 240),
              strokeWidth: 4,
              thumbSize: 36,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => Navigator.of(context, rootNavigator: true).pop('dialog'),
                ),
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
              ],
            )
          ],
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
