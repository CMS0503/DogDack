import 'package:get/get.dart';

class MainController extends GetxController {
  final RxInt _tabIndex = 0.obs;

  int get tabindex => _tabIndex.value;

  void changeTabIndex(idx) {
    _tabIndex.value = idx;
    update();
  }
}
