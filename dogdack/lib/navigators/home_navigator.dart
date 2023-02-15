import 'package:dogdack/controllers/main_controll.dart';
import 'package:dogdack/screens/chart/widget/dounut_chart.dart';
import 'package:flutter/material.dart';
import 'package:dogdack/screens/home/home_screen.dart';
import 'package:get/get.dart';

class HomeNavigator extends StatelessWidget {
  final mainController = Get.put(MainController());

  HomeNavigator({super.key});

  Map<String, WidgetBuilder> _routeBuilder(BuildContext context) {
    return {
      "/": (context) => HomePage(),
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
