import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class InputController extends GetxController {
  DateTime date = DateTime.now();
  String place = '';
  Timestamp startTime = Timestamp.now();
  Timestamp endTime = Timestamp.now();
  String distance = '0';
  String diary = '';
  bool walkCheck = true;
  bool bath = true;
  bool beauty = true;
  List<String> imageUrl = [];
  String imgUrl = '';
  String name = '';
  Map<String, dynamic> dognames = {};
  List<String> valueList = [];
  String selectedValue = '';
  String saveName = '';
  String time = '';
  DateTime today = DateTime.now();

  /////////////////////////여기 한줄 영우 추가/////////////////////
  // Map dog_names = {};
  String selected_id = '';
  void setDate(selectedDate) {
    date = selectedDate;
    update();
  }
}
