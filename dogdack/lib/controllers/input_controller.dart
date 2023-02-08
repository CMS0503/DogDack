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
<<<<<<< HEAD:dogdack/lib/screens/calendar_schedule_edit/controller/input_controller.dart
  String name = '';
  List<String> dognames = [];
  List<String> valueList = [];
  String selectedValue = '';
  String saveName = '';

  // void input() {
  //   update();
  // }
=======
  DateTime today = DateTime.now();

  void setDate(selectedDate) {
    date = selectedDate;
    update();
  }
>>>>>>> eb8daeae3be34c8e71403a4ef1c8ac52e5d4d2d2:dogdack/lib/controllers/input_controller.dart
}
