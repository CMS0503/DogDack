import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CalendarWorkController extends GetxController {
  RxList<LatLng> latlng = <LatLng>[].obs;

  RxInt timeData = 0.obs;
  RxInt distData = 0.obs;

  //
  updateState() {
    update();
  }
}