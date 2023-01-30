import 'package:flutter/material.dart';
import './widgets/my_map.dart';
import './widgets/status.dart';
import './widgets/ble_screen.dart';

class WalkPage extends StatelessWidget {
  WalkPage({super.key, required this.tabIndex});

  final int tabIndex;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Walk',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(

          children: [
            SizedBox(height: 10),
            Status(),
            SizedBox(height: 10),
            Container(
              height: screenHeight * 0.5,
              width: screenWidth,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Map(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '00:00:00',
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                Text('play'),
                Column(),
              ],
            ),
            SizedBox(height: 10,),
            TextButton(
              child: Text("Select Bluetooth"),
              onPressed: () {
                Navigator.pushNamed(context, '/Ble');
              },
            ),
          ],
        ),
      ),
    );
  }
}
