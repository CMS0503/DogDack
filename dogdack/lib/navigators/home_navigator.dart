import 'package:flutter/material.dart';
import 'package:dogdack/screens/home_screen.dart';

//screen
import '../screens/b_screen.dart';

class HomeNavigator extends StatelessWidget {
  const HomeNavigator({super.key, required this.tabIndex});
  final int tabIndex;
  Map<String, WidgetBuilder> _routeBuilder(BuildContext context) {
    return {
      "/": (context) => HomePage(
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
