import 'package:dogdack/screens/calendar_main/calendar_main.dart';
import 'package:dogdack/screens/chart/chart_screen.dart';
import 'package:flutter/material.dart';

import '../screens/calendar_detail/calender_detail.dart';

//screen

class ChartNavigator extends StatelessWidget {
  const ChartNavigator({super.key});

  Map<String, WidgetBuilder> _routeBuilder(BuildContext context) {
    return {
      "/": (context) => Chart(),
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
