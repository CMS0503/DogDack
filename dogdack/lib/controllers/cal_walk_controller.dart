import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CalendarWorkController extends GetxController {
  List<LatLng> latlng = [];
  num timeData = 0;
  num distData = 0;

  updateState() {
    update();
  }
}