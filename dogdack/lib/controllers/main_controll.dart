import 'package:dogdack/controllers/input_controller.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import 'mypage_floatingbtn_controller.dart';

class MainController extends GetxController {
  RxInt _tabIndex = 0.obs;

  int get tabindex => _tabIndex.value;

  Future<void> changeTabIndex(idx) async {
    final inputController = Get.put(InputController());
    inputController.date = DateTime.fromMillisecondsSinceEpoch(
        (DateTime.now().millisecondsSinceEpoch +
                DateTime.now().timeZoneOffset.inMilliseconds)
            .toInt());
    _tabIndex.value = idx;
    FocusManager.instance.primaryFocus?.unfocus();

    if (Get.put(MyPageFloatingBtnController())
            .floatBtnKey
            .currentState
            ?.isOpened ==
        true)
      Get.put(MyPageFloatingBtnController())
          .floatBtnKey
          .currentState
          ?.closeFABs();

    update();
  }
}
