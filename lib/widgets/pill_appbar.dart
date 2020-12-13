import 'package:compendium/theme.dart';
import 'package:flutter/material.dart';

/// Based off my boy at: https://github.com/ketanchoyal/custom_top_bar

ShapeBorder kBackButtonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(20),
    bottomRight: Radius.circular(20),
  ),
);

Widget kBackBtn = Icon(
  Icons.arrow_back_ios,
  // color: Colors.black54,
);

// Generates a pill appbar contextually
class PillAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget title;
  final Widget leading;
  final Function onPressed;
  final Function onBackButtonPressed;
  final Function onTitleTapped;
  final double elevation;
  final bool automaticallyImplyLeading;
  final Color backgroundColor;
  final TextStyle titleTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white);

  @override
  final Size preferredSize;

  PillAppBar({
    Key key,
    @required this.title,
    this.onPressed,
    this.leading,
    this.onTitleTapped,
    this.elevation = 10,
    this.backgroundColor,
    this.automaticallyImplyLeading = true,
    this.onBackButtonPressed,
  }) : preferredSize = Size.fromHeight(60.0);

  State<StatefulWidget> createState() => _PillAppBarState();
}

class _PillAppBarState extends State<PillAppBar> {
  TextStyle titleTextStyle;
  Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final CompendiumThemeData appTheme = CompendiumThemeData.of(context);
    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);

    final bool canPop = (parentRoute?.canPop ?? false) && !Scaffold.of(context).isDrawerOpen;

    backgroundColor = widget?.backgroundColor ?? appTheme.materialTheme.accentColor;

    titleTextStyle = widget.titleTextStyle.merge(TextStyle(color: (backgroundColor ?? Colors.white).computeLuminance() > 0.5 ? Colors.black : Colors.white));

    Widget leading = widget.leading;

    if (leading == null && widget.automaticallyImplyLeading) {
      if (Scaffold.of(context).hasDrawer) {
        leading = IconButton(
          icon: Icon(Icons.menu),
          onPressed: Scaffold.of(context).openDrawer,
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      } else {
        if (canPop)
          leading = BackButton(
            onPressed: widget.onBackButtonPressed,
          );
      }
    }

    // return _drawSplitAppBar(appTheme, context, leading);
    return canPop ? _buildPillAppBar(appTheme, context, leading) : _buildSplitAppBar(appTheme, context, leading);
  }

  Widget _buildAppBarButton(CompendiumThemeData appTheme, BuildContext context, Widget leading) {
    return MaterialButton(
      height: 50,
      minWidth: 50,
      shape: kBackButtonShape,
      elevation: widget.elevation,
      onPressed: widget.onPressed,
      child: IconTheme.merge(data: appTheme.materialTheme.primaryIconTheme, child: leading),
    );
  }

  Widget flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }

  Widget _buildTitleAlign() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: DefaultTextStyle(child: widget.title, style: titleTextStyle),
      ),
    );
  }

  // Make a rectTween that is centred at the middle of the right main split app bar
  RectTween _createRightCentredRectTween(Rect begin, Rect end) {
    return RectTween(
      begin: Rect.fromCenter(
        center: Offset(
          // Make a rectangle that is centred at the middle of the right main split app bar
          // MediaQuery.of(context).size.width - MediaQuery.of(context).size.width / (1.5 * 2),
          begin.right,
          begin.center.dy,
        ),
        // Make a rectangle that is the width of the right main split app bar
        width: MediaQuery.of(context).size.width / 4,
        height: begin.height,
      ),
      end: end,
    );
  }

  SafeArea _buildPillAppBar(CompendiumThemeData appTheme, BuildContext context, Widget leading) {
    return SafeArea(
      child: Hero(
        tag: "_topBarBtn",
        // This creates the cool animation where it aligns with the main screen bar
        createRectTween: _createRightCentredRectTween,
        transitionOnUserGestures: true,
        child: Card(
          margin: EdgeInsets.only(top: 2, left: 2),
          color: backgroundColor,
          elevation: widget.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: appTheme.borderRadius.bottomLeft,
              topLeft: appTheme.borderRadius.bottomLeft,
            ),
          ),
          child: Container(
            height: 50,
            child: Row(
              children: [
                _buildAppBarButton(appTheme, context, leading),
                Center(
                  child: Card(
                    elevation: 0,
                    color: backgroundColor,
                    child: InkWell(onTap: widget.onTitleTapped, child: _buildTitleAlign()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSplitAppBar(CompendiumThemeData appTheme, BuildContext context, Widget leading) {
    return SafeArea(
      child: IconTheme.merge(
        data: appTheme.materialTheme.primaryIconTheme,
        child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          Hero(
            tag: "_topBarBtn",
            transitionOnUserGestures: true,
            createRectTween: (Rect begin, Rect end) {
              return RectTween(
                begin: Rect.fromCenter(
                  center: Offset(
                    // Make a rectangle that is centred at the middle of the right main split app bar
                    // MediaQuery.of(context).size.width / (1.5 * 2 * 2),
                    // 50 / 2,
                    begin.left,
                    begin.center.dy,
                  ),
                  // Make a rectangle that is the width of the right main split app bar
                  width: MediaQuery.of(context).size.width / (1.5),
                  height: 50,
                ),
                end: end,
              );
            },
            child: Card(
              margin: EdgeInsets.all(0),
              color: backgroundColor,
              elevation: widget.elevation,
              shape: kBackButtonShape,
              child: _buildAppBarButton(appTheme, context, leading),
            ),
          ),
          Hero(
            tag: 'title',
            transitionOnUserGestures: true,
            createRectTween: _createRightCentredRectTween,
            child: Card(
              margin: EdgeInsets.only(top: 2),
              color: backgroundColor,
              elevation: widget.elevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: appTheme.borderRadius.bottomLeft,
                  topLeft: appTheme.borderRadius.bottomLeft,
                ),
              ),
              child: InkWell(
                onTap: widget.onTitleTapped,
                child: Container(width: MediaQuery.of(context).size.width / 1.5, height: 50, child: _buildTitleAlign()),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
