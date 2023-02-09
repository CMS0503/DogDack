import 'package:get/get.dart';

class ButtonController extends GetxController {
  final RxInt _buttonIndex = 0.obs;

  int get buttonindex => _buttonIndex.value;

  void changeButtonIndex() {
    update();
  }
}
