import 'package:flutter/material.dart';

class CalenderPage extends StatelessWidget {
  CalenderPage({super.key, required this.tabIndex});
  final int tabIndex;
  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Calender page")),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Calender page'),
            ],
          )
        ));
  }
}