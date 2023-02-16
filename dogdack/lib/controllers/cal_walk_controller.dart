import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CalendarWorkController extends GetxController {
  RxList<LatLng> latlng = <LatLng>[].obs;

  // Rxint timedata = 0.obs

  updateState() {
    update();
  }
}