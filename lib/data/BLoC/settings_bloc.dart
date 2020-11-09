import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class SettingsBloc extends ChangeNotifier {
  static const Map<String, String> defaultSettings = {
    "datablockCounter": "0",
    "theme": "light",
  };

  Box _settingsBox;

  bool _loading = true;
  bool get loading => _loading;

  Future<void> _init() async {
    _loading = true;
    // set defaults
    if (!(await Hive.boxExists('settings'))) {
      _settingsBox = await Hive.openBox('settings');

      await _settingsBox.putAll(defaultSettings);
    } else {
      _settingsBox = await Hive.openBox('settings');
    }

    _loading = false;

    notifyListeners();
  }

  SettingsBloc() {
    _init();
  }

  static SettingsBloc of(BuildContext context, {listen: false}) {
    return Provider.of<SettingsBloc>(context, listen: listen);
  }

  //////////////////////////////////////////////////////////////////
  ////////////////// Getters and Setters //////////////////////////
  ///////////////////////////////////////////////////////////////

  bool get darkTheme {
    if (loading) {
      return false;
    }

    // In the future there may be more than a light or dark theme, but for now we'll convert a string to a bool.
    return _settingsBox.get("theme") == "light" ? false : true;
  }

  set darkTheme(bool value) {
    // In the future there may be more than a light or dark theme, but for now we'll convert a bool to a string.
    _settingsBox.put("theme", value ? "dark" : "light");
    notifyListeners();
  }
}
