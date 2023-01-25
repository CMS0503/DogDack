import 'package:flutter/material.dart';

class WalkPage extends StatelessWidget {
  WalkPage({super.key, required this.tabIndex});
  final int tabIndex;
  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Walk page")),
        body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Walk page'),
              ],
            )
        ));
  }
}