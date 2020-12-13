import 'package:compendium/data/datablock.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class TemplateBloc extends ChangeNotifier {
  static Future<String> getTemplateJsonString() async {
    return await rootBundle.loadString(templatesPath);
  }

  /// This must reflect the asset path in pubspec.yaml
  static const String templatesPath = "assets/templates.json";
  static const String templatesBoxName = 'templates';

  static Datablock defaultTemplate = Datablock("None", "");

  Box _templatesBox;
  List<Datablock> _templateCache;

  bool _loading = true;
  bool get loading => _loading;

  static Future<List<Datablock>> _loadTemplates() async {
    String jsonString = await getTemplateJsonString();
    var templatesJson = jsonDecode(jsonString);

    assert(templatesJson is List);

    List<Datablock> templates = [defaultTemplate];
    templates.addAll(templatesJson.map((d) => Datablock.fromJson(d)).toList().cast<Datablock>());

    print(templates.map((e) => e.toJson()));

    return templates;
  }

  Future<void> _init() async {
    _loading = true;
    // set defaults
    if (!(await Hive.boxExists(templatesBoxName))) {
      _templatesBox = await Hive.openBox<Datablock>(templatesBoxName);
      await _templatesBox.clear();

      await _templatesBox.addAll(await _loadTemplates());
    } else {
      _templatesBox = await Hive.openBox<Datablock>(templatesBoxName);
    }

    _loading = false;

    notifyListeners();
  }

  /// Debug purposes
  Future<void> reInit() async {
    _loading = true;
    await _templatesBox.clear();
    await _templatesBox.addAll(await _loadTemplates());

    _loading = false;

    notifyListeners();
  }

  TemplateBloc() {
    _init();
  }

  static TemplateBloc of(BuildContext context, {listen: false}) {
    return Provider.of<TemplateBloc>(context, listen: listen);
  }

  // ////////////////////////////////////////////////////////////////
  // //////////////// Getters and Setters //////////////////////////
  // /////////////////////////////////////////////////////////////

  List<Datablock> get templates {
    if (_loading) return [Datablock.blank()];

    return _templatesBox.values.toList();
  }
}
