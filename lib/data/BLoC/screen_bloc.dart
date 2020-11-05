import 'package:flutter/material.dart';

class ScreenBloc extends ChangeNotifier {
  ScreenBloc();

  // You may be wondering how this works. Well, let me explain it to you.
  // So, the basic premise is, once the [_personId] is set, it will take you to the personScreen
  // with that person selected.
  // same thing goes for the [_datablockId] and [_attributeId].
  // But it will only work if the level above it is set.
  // So for instance, if [_dataBlockId] is being set but the [_personId] is empty, it won't set the [_dataBlockId]
  // and maybe throw an error or something idk.

  int _personId = -1;
  String _dataBlockId = "";
  String _attributeId = "";
  BuildContext _buildContext;

  int get personId => _personId;
  String get dataBlockId => _dataBlockId;
  String get attributeId => _attributeId;

  /// This just sets the person ID to ""
  /// it doesn't delete the person or anything
  void clearPerson() {
    _personId = -1;
    _dataBlockId = "";
    _attributeId = "";
    notifyListeners();
  }

  /// This just sets the data block ID to ""
  /// it doesn't delete the data block or anything
  void clearDataBlock() {
    _dataBlockId = "";
    _attributeId = "";
    notifyListeners();
  }

  /// This just sets the attribute ID to ""
  /// it doesn't delete the attribute or anything
  void clearAttribute() {
    _attributeId = "";
    notifyListeners();
  }

  set context(BuildContext context) {
    _buildContext = context;
  }

  /// Warning: make sure you set context with the context setter first
  set personId(int newPersonId) {
    _personId = newPersonId;
    // push the new screen if we have a person ID to display
    if (newPersonId > -1) Navigator.of(_buildContext).pushNamed("/person");
    notifyListeners();
  }

  set dataBlockId(String newDataBlockId) {
    if (_personId > -1) {
      _dataBlockId = newDataBlockId;
    } else {
      print("_dataBlockId is trying to be set with $newDataBlockId when _personId is empty.");
    }
    notifyListeners();
  }

  set attributeId(String newAttributeId) {
    if (_personId > -1) {
      if (_dataBlockId.isEmpty) {
        _attributeId = newAttributeId;
      } else {
        print("_attributeId is trying to be set with $newAttributeId when _dataBlockId is empty.");
      }
    } else {
      print("_attributeId is trying to be set with $newAttributeId when _personId is empty.");
    }
    notifyListeners();
  }
}
