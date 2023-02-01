import 'package:dogdack/commons/logo_widget.dart';
import 'package:flutter/material.dart';

class CalenderPage extends StatelessWidget {
  CalenderPage({super.key, required this.tabIndex});
  final int tabIndex;
  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const LogoWidget(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text('Calender detail page'),
          ],
        ));
  }
}
