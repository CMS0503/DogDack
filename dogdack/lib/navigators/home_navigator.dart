import 'package:flutter/material.dart';
import 'package:dogdack/screens/home/home_screen_test.dart';

//screen
import '../screens/home/b_screen.dart';

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
