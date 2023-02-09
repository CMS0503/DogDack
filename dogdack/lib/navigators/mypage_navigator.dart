import 'package:flutter/material.dart';

//screen
import '../screens/my/mypage_screen.dart';

class MyPageNavigator extends StatelessWidget {
  const MyPageNavigator({super.key});

  Map<String, WidgetBuilder> _routeBuilder(BuildContext context) {
    return {
      "/": (context) => MyPage(),
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