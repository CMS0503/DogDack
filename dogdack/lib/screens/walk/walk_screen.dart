import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './controller/walk_controller.dart';
import './widgets/my_map.dart';
import './widgets/status.dart';

class WalkPage extends StatelessWidget {
  WalkPage({super.key, required this.tabIndex});

  final int tabIndex;

  final walkController = Get.put(WalkController());

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
        () => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 10),
            Status(),
            SizedBox(height: 10),
            walkController.isBleConnect == false
                ? Container(
                    height: screenHeight * 0.65,
                    width: screenWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '블루투스 연결을 확인해주세요',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bluetooth_outlined,
                              color: Colors.blue,
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/Ble'),
                              child: Text('지금 연결하러 가기'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      Container(
                        height: screenHeight * 0.65,
                        width: screenWidth,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: myMap(),
                        ),
                      ),
                      (walkController.isRunning == walkController.isStart)
                          ? Container()
                          : Opacity(
                              opacity: 0.7,
                              child: Container(
                                decoration: BoxDecoration(color: Colors.grey),
                                height: screenHeight * 0.65,
                                width: screenWidth * 1.2,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 100,
                                    width: screenWidth * 0.9,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('산책하기를 종료합니다'),
                                        Text('산책 거리가 짧으면 기록되지 않습니다.'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.red),
                                              child: TextButton(
                                                child: Text('산책 계속하기'),
                                                onPressed: () {
                                                  walkController
                                                      .updateWalkingState();
                                                  walkController.startTimer();
                                                },
                                              ),
                                            ),
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.blue),
                                                child: Text('종료')),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
