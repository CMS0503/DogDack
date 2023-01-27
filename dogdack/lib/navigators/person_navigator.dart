import 'package:flutter/material.dart';

import '../screens/home/a_screen.dart';
import '../screens/home/b_screen.dart';

class PersonNavigator extends StatelessWidget {
  const PersonNavigator({super.key, required this.tabIndex});
  final int tabIndex;
  Map<String, WidgetBuilder> _routeBuilder(BuildContext context) {
    return {
      "/": (context) => ScreenA(
        tabIndex: tabIndex,
      ),
      "/ScreenB": (context) => ScreenB(
        tabIndex: tabIndex,
      ),
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