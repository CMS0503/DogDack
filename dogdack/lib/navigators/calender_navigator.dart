import 'package:dogdack/screens/calendar_main/calendar_main.dart';
import 'package:flutter/material.dart';

import '../screens/calendar_detail/calender_detail.dart';

//screen

class CalenderNavigator extends StatelessWidget {
  const CalenderNavigator({super.key, required this.tabIndex});
  final int tabIndex;
  Map<String, WidgetBuilder> _routeBuilder(BuildContext context) {
    return {
      "/": (context) => CalenderDetail(
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
