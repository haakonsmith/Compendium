// Pass the controllers so they can be diposed outside in state manganger widget
import 'package:compendium/BLoC/people_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<PersonData> getNewPerson({
  @required BuildContext context,
  @required TextEditingController firstnameController,
  @required TextEditingController surnameController,
}) async {
  TextEditingController firstnameGetter = firstnameController;
  TextEditingController surnameGetter = surnameController;

  final _formKey = GlobalKey<FormState>();

  PersonData item;

  final _validator = (value) {
    if (value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  };

  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Enter firstname'),
                    controller: firstnameGetter,
                    // The validator receives the text that the user has entered.
                    validator: (value) => _validator(value),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Enter surname'),
                    controller: surnameGetter,
                    // The validator receives the text that the user has entered.
                    validator: (value) => _validator(value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Submit"),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        item = PersonData(
                            firstName: firstnameGetter.text,
                            surName: surnameGetter.text);
                        _formKey.currentState.save();

                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        );
      }).then((val) {});

  if (item == null) {
    return Future.error("Dialog closed before data could be retrived");
  } else {
    return Future.value(item);
  }
}
