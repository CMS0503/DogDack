import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './controller/walk_controller.dart';
import './widgets/my_map.dart';
import './widgets/status.dart';

class WalkPage extends StatelessWidget {
  WalkPage({super.key, required this.tabIndex});

  final walkController = Get.put(WalkController());
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
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 10),
              Status(),
              SizedBox(height: 10),
              walkController.isBleConnect == false
                  ? Container(
                      height: screenHeight * 0.65,
                      width: screenWidth,
                      child: Center(
                        child: Text(
                          '블루투스 연결을 확인해주세요',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: screenHeight * 0.65,
                      width: screenWidth,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: myMap(),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
