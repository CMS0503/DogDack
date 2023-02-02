import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class WalkController extends GetxController {
  RxBool isBleConnect = false.obs;
  double latitude = 0;
  double longitude = 0;
  BluetoothDevice? _device;

  BluetoothDevice? get device => _device;

  void setCurrentLocation(curLatitude, curLongitude) {
    latitude = curLatitude;
    longitude = curLongitude;
    update();
  }

  void connectBle(device) {
    _device = device;
    // _service = device.discoverServices();
    update();
  }
}