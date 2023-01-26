import 'package:flutter/material.dart';

//screen
import '../screens/mypage_screen.dart';

class MyPageNavigator extends StatelessWidget {
  const MyPageNavigator({super.key, required this.tabIndex});
  final int tabIndex;
  Map<String, WidgetBuilder> _routeBuilder(BuildContext context) {
    return {
      "/": (context) => MyPage(
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