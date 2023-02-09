import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class InputController extends GetxController {
  DateTime date = DateTime.now();
  String place = '';
  Timestamp startTime = Timestamp.now();
  Timestamp endTime = Timestamp.now();
  String distance = '';
  String diary = '';
  bool walkCheck = true;
  bool bath = true;
  bool beauty = true;
  List<String> imageUrl = [];
  String name = '';
  List<String> dognames = [];
  List<String> valueList = [];
  String selectedValue = '';
  String saveName = '';

  // void input() {
  //   update();
  // }
  DateTime today = DateTime.now();

  void setDate(selectedDate) {
    date = selectedDate;
    update();
  }
}
