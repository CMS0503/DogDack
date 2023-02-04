import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class WalkController extends GetxController {
  RxBool isBleConnect = false.obs;
  RxDouble latitude = 37.500735.obs;
  RxDouble longitude = 127.036845.obs;

  final String serviceUuid = '0000ffe0-0000-1000-8000-00805f9b34fb';
  final String characteristicUuid = '0000ffe1-0000-1000-8000-00805f9b34fb';

  String name = "Gong";
  BluetoothDevice? _device;
  List<BluetoothService>? services;

  BluetoothDevice? get device => _device;

  double get lat => latitude.value.toDouble();

  double get lon => longitude.value.toDouble();

  void setCurrentLocation(curLatitude, curLongitude) {
    latitude.value = curLatitude.toDouble();
    longitude.value = curLongitude.toDouble();
  }

  void connectBle(device) {
    _device = device;
    isBleConnect.value = true;
    // _service = device.discoverServices();
    update();
  }
}
