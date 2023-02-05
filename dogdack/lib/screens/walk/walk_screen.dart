import 'package:flutter/material.dart';
import './widgets/my_map.dart';
import './widgets/status.dart';
import './widgets/ble_screen.dart';

class WalkPage extends StatelessWidget {
  const WalkPage({super.key, required this.tabIndex});

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
            const SizedBox(height: 10),
            const Status(),
            const SizedBox(height: 10),
            SizedBox(
              height: screenHeight * 0.65,
              width: screenWidth,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Map(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
