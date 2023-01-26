import 'package:flutter/material.dart';
import './widgets/my_map.dart';

class WalkPage extends StatelessWidget {
  WalkPage({super.key, required this.tabIndex});

  final int tabIndex;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Walk'),
        // ),
        body: Column(
          children: [
            Container(
              height: ,
              child: Map(),
            ),
            // SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
