import 'package:flutter/material.dart';

//screen
import 'package:dogdack/screens/walk/walk_screen.dart';
import 'package:dogdack/screens/walk/widgets/ble_screen.dart';

class WalkNavigator extends StatelessWidget {
  const WalkNavigator({super.key, required this.tabIndex});

  final int tabIndex;

  Map<String, WidgetBuilder> _routeBuilder(BuildContext context) {
    return {
      "/": (context) => WalkPage(
            tabIndex: tabIndex,
          ),
      "/Ble": (context) => Ble(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilder = _routeBuilder(context);
    return Navigator(
      initialRoute: '/',
      onGenerateRoute: ((settings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilder[settings.name!]!(context),
        );
      }),
    );
  }
}
