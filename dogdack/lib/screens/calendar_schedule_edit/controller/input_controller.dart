import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class InputController extends GetxController {
  DateTime date = DateTime.now();
  String place = '';
  Timestamp startTime = Timestamp.now();
  Timestamp endTime = Timestamp.now();
  String distance = '';
  String diary = '';
  bool bath = true;
  bool beauty = true;
  List<String> imageUrl = [];
  String name = '';
  RxList<dynamic> dognames = [].obs;

  // void input() {
  //   update();
  // }
}
