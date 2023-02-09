import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/input_controller.dart';
import 'package:dogdack/screens/calendar_main/widgets/calendar.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ButtonController extends GetxController {
  final RxInt _buttonIndex = 0.obs;
  var btn = 0;

  int get buttonindex => _buttonIndex.value;

  void changeButtonIndex(idx) {
    _buttonIndex.value = idx;
    update();
  }

  getName() async {
    final controller = Get.put(InputController());
    final petsRef = FirebaseFirestore.instance
        .collection('Users/${FirebaseAuth.instance.currentUser!.email}/Pets');
    var dogDoc = await petsRef.get();
    List<String> dogs = [];
    // 자.. 여기다가 등록된 강아지들 다 입력하는거야
    for (int i = 0; i < dogDoc.docs.length; i++) {
      dogs.insert(0, dogDoc.docs[i]['name']);
    }
    controller.valueList = dogs;

    // 근데 강아지들이 없으면?
    if (dogs.isEmpty) {
      '그냥 넘어가야지 뭐';
    } else {
      // 강아지들이 있는데 처음 들어왔을 때 강아지 선택을 안한 상태면
      if (controller.selectedValue == '') {
        // 그냥 처음 강아지로 가져오기
        controller.selectedValue = dogs[0];
        var result = await petsRef
            .where("name", isEqualTo: controller.selectedValue)
            .get();
        if (result.docs.isNotEmpty) {
          String dogId = result.docs[0].id;
          final calRef = petsRef.doc(dogId).collection('Calendar');
          var data = await calRef.get();
          for (int i = 0; i < data.docs.length; i++) {
            Calendar.events[
                '${data.docs[i].reference.id}/${controller.selectedValue}'] = [
              data.docs[i]['isWalk'],
              data.docs[i]['bath'],
              data.docs[i]['beauty'],
            ];
          }
          // setState(() {});
        }
      } else {
        // 그게 아니면 selectedValue로 데이터 가져오기
        var result = await petsRef
            .where("name", isEqualTo: controller.selectedValue)
            .get();
        if (result.docs.isNotEmpty) {
          String dogId = result.docs[0].id;
          final calRef = petsRef.doc(dogId).collection('Calendar');
          var data = await calRef.get();
          for (int i = 0; i < data.docs.length; i++) {
            Calendar.events[
                '${data.docs[i].reference.id}/${controller.selectedValue}'] = [
              data.docs[i]['isWalk'],
              data.docs[i]['bath'],
              data.docs[i]['beauty'],
            ];
          }
          print(Calendar.events);
          print('hi');
          // setState(() {});
          // print(Calendar.events);
        }
      }
    }
  }
}
