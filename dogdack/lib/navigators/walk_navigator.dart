//screen
import 'package:dogdack/screens/walk/walk_screen.dart';
import 'package:dogdack/screens/walk/widgets/ble_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/walk/controller/walk_controller.dart';

class WalkNavigator extends StatelessWidget {
  WalkNavigator({super.key});

  final walkController = Get.put(WalkController());

  Map<String, WidgetBuilder> _routeBuilder(BuildContext context) {
    return {
      "/": (context) => WalkPage(
          ),
      "/Ble": (context) => BleList(),
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
