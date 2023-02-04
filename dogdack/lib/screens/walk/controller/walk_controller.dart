import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class WalkController extends GetxController {
  RxBool isBleConnect = false.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  String name = "Gong";
  BluetoothDevice? _device;

  BluetoothDevice? get device => _device;

  double get lat => latitude.toDouble();

  double get lon => latitude.toDouble();

  void setCurrentLocation(curLatitude, curLongitude) {
    latitude = curLatitude;
    longitude = curLongitude;
  }

  void connectBle(device) {
    _device = device;
    // _service = device.discoverServices();
    update();
  }
}