import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompendiumThemeData extends ChangeNotifier {
  BuildContext context;

  CompendiumThemeData(this.context);

  static MaterialColor primaryBlueBlack = MaterialColor(
    blueBlackPrimaryValue,
    <int, Color>{
      50: Color(0xFFe4e9ec),
      100: Color(0xFFbac7d3),
      200: Color(0xFF8fa3b5),
      300: Color(0xFF667f97),
      400: Color(0xFF446584),
      500: Color(0xFF1c4d73),
      600: Color(0xFF14466b),
      700: Color(0xFF0a3d61),
      800: Color(blueBlackPrimaryValue),
      900: Color(0xFF07233c),
    },
  );
  static const int blueBlackPrimaryValue = 0xFF063354;

  static MaterialColor primaryPurple = MaterialColor(
    purplePrimaryValue,
    <int, Color>{
      50: Color(0xFFe9e8f2),
      100: Color(0xFFc8c5df),
      200: Color(0xFFa5a0c9),
      300: Color(0xFF837cb3),
      400: Color(0xFF6c5fa3),
      500: Color(0xFF574393),
      600: Color(0xFF503c8a),
      700: Color(purplePrimaryValue),
      800: Color(0xFF402972),
      900: Color(0xFF33175c)
    },
  );

  static const int purplePrimaryValue = 0xFF48327f;

  bool isDark = false;

  final Color colorPrimary = Color(blueBlackPrimaryValue);

  final BorderRadius borderRadius = BorderRadius.circular(20);

  final lightTheme = ThemeData(
      primarySwatch: primaryBlueBlack,
      textTheme: Typography.blackCupertino,
      typography: Typography.material2018());

  final darkTheme = ThemeData(
      primarySwatch: primaryPurple,
      scaffoldBackgroundColor: Colors.grey.shade900,
      cardColor: Colors.grey.shade900,
      dialogBackgroundColor: Colors.grey.shade900,
      textTheme: Typography.whiteCupertino,
      typography: Typography.material2018());

  ThemeData get materialTheme {
    return isDark ? darkTheme : lightTheme;
  }

  void swapTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}

class CompendiumTheme extends StatelessWidget {
  final Widget child;

  CompendiumTheme({this.child});

  @override
  Widget build(BuildContext context) {
    final themeData = CompendiumThemeData(context);
    return ChangeNotifierProvider.value(value: themeData, child: child);
  }
}

extension BuildContextExtension on BuildContext {
  CompendiumThemeData get appTheme {
    return watch<CompendiumThemeData>();
  }
}
