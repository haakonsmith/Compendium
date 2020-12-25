import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompendiumThemeData extends ChangeNotifier {
  bool isDark;

  CompendiumThemeData({this.isDark});

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

  final Color colorPrimary = Color(blueBlackPrimaryValue);

  final BorderRadius borderRadius = BorderRadius.circular(20);

  Widget get dataLoadingIndicator => Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
        materialTheme.primaryColor,
      )));
  // White if it's darktheme, else just leave it.
  ListTileTheme listTileTheme({Widget child}) => ListTileTheme(
        iconColor: isDark ? Colors.white : null,
        child: child,
      );

  final lightTheme = ThemeData(
    primarySwatch: primaryBlueBlack,
    textTheme: Typography.blackCupertino,
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    ),
    typography: Typography.material2018(),
  );

  final darkTheme = ThemeData(
    primarySwatch: primaryPurple,
    scaffoldBackgroundColor: Colors.grey.shade900,
    dialogBackgroundColor: Colors.grey.shade900,
    cardColor: Colors.grey.shade900,
    canvasColor: Colors.grey.shade900,
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: Colors.white,
      ),
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      labelStyle: TextStyle(
        decorationColor: Colors.white,
        color: Colors.white,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    ),
    appBarTheme: AppBarTheme(),
    textTheme: Typography.whiteCupertino,
    typography: Typography.material2018(),
  );

  ThemeData get materialTheme {
    return isDark ? darkTheme : lightTheme;
  }

  void swapTheme() {
    isDark = !isDark;
    notifyListeners();
  }

  static CompendiumThemeData of(BuildContext context, {listen: true}) {
    return Provider.of<CompendiumThemeData>(context, listen: listen);
  }
}
