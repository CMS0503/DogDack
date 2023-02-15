import 'package:dogdack/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class MainController extends GetxController {
  RxInt _tabIndex = 0.obs;

  int get tabindex => _tabIndex.value;

  Future<void> changeTabIndex(idx) async {
    _tabIndex.value = idx;
    FocusManager.instance.primaryFocus?.unfocus();

    update();
  }
}
