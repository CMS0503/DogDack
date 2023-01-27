import 'package:flutter/material.dart';

class ScreenB extends StatelessWidget {
  const ScreenB({super.key, required this.tabIndex});
  final int tabIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("ScreenB")),
        body: Center(
          child: Column(
            children: <Widget>[
              Text("From tab: ${tabIndex.toString()}"),
              TextButton(
                onPressed: (() {
                  Navigator.pop(context);
                }),
                child: Text("Go back"),
              ),
            ],
          ),
        ));
  }
}