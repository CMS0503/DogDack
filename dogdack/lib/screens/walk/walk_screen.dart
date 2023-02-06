import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './controller/walk_controller.dart';
import './widgets/my_map.dart';
import './widgets/status.dart';
import '../../commons/logo_widget.dart';

class WalkPage extends StatelessWidget {
  WalkPage({super.key, required this.tabIndex});

  final int tabIndex;

  final walkController = Get.put(WalkController());

  Widget mapAreaWidget(w, h) {
    return Container(
      height: h * 0.5,
      width: w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: myMap(),
      ),
    );
  }

  Widget requestBluetoothConnectWidget(w, h, context) {
    return Container(
      height: h * 0.5,
      width: w,
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
                onPressed: () => Navigator.pushNamed(context, '/Ble'),
                child: Text('지금 연결하러 가기'),
              ),
            ],
          ),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  Widget endWalkModal(w, h, context) {
    return Opacity(
      opacity: 0.7,
      child: Container(
        decoration: BoxDecoration(color: Colors.grey),
        height: h * 0.65,
        width: w,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            height: 100,
            width: w * 0.9,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text('산책하기를 종료합니다'),
                Text('산책 거리가 짧으면 기록되지 않습니다.'),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: w * 0.45,
                      // decoration: BoxDecoration(color: Colors.red),
                      child: Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(50, 30)),
                          child: Text(
                            '산책 계속하기',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          onPressed: () {
                            walkController.updateWalkingState();
                            walkController.startTimer();
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: w * 0.45,
                      // decoration: BoxDecoration(color: Colors.blue),
                      child: Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          child: Text(
                            '종료',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          onPressed: () => {},
                        ),
                      ),
                    ),
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
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.12),
        child: const LogoWidget(),
      ),
      body: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Status(),
            SizedBox(height: 10),
            walkController.isBleConnect.value == false
                ? requestBluetoothConnectWidget(
                    screenWidth, screenHeight, context)
                : Stack(
                    children: [
                      mapAreaWidget(screenWidth, screenHeight),
                      (walkController.isRunning.value == walkController.isStart)
                          ? Container()
                          : endWalkModal(screenWidth, screenHeight, context),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
