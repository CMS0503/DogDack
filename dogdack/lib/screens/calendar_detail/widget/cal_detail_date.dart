import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/input_controller.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:dogdack/controllers/walk_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalDetailDateWidget extends StatefulWidget {
  final time;

  CalDetailDateWidget({
    super.key,
    required this.time,
  });

  final walkController = Get.put(WalkController());
  final inputController = Get.put(InputController());
  final userController = Get.put(UserController());

  Future<void> setDate() async {
    String docId =
        inputController.dognames[inputController.selectedValue.toString()];
    // walk 경로
    CollectionReference walkRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets/$docId/Walk');

    await walkRef.get().then(
      (value) async {
        print('cal_walk_card 안 : ${userController.loginEmail}');
        // 달력에서 선택한 날짜
        var selectedDay = inputController.date;
        var startOfToday = Timestamp.fromDate(selectedDay);
        var endOfToday =
            Timestamp.fromDate(selectedDay.add(const Duration(days: 1)));

        // 선택한 날짜의 산책 데이터를 내림차순 정렬(최신 데이터가 위로 오게)
        await walkRef
            .where("startTime",
                isGreaterThanOrEqualTo: startOfToday, isLessThan: endOfToday)
            .orderBy("startTime", descending: true)
            .get()
            .then(
          (QuerySnapshot snapshot) async {
            print('cal_walk_card 안 snapshot: ${snapshot.docs}');
            // 장소, 거리, 시간 데이터
            inputController.startTime = snapshot.docs[0]['startTime'];
            inputController.endTime = snapshot.docs[0]['endTime'];

            // 여기 geodata 수정해야 될 거 같은데, 송빈님이랑 상의하기
          },
        );
      },
    );
    // .then((value) {
    //   setState(() {});
    // });
  }

  @override
  State<CalDetailDateWidget> createState() => _CalDetailDateWidget();
}

class _CalDetailDateWidget extends State<CalDetailDateWidget> {
  final controller = Get.put(InputController());
  @override
  Widget build(BuildContext context) {
    return Text(
      "${DateTime.fromMicrosecondsSinceEpoch(controller.endTime.microsecondsSinceEpoch)}",
      style: const TextStyle(
          fontFamily: 'bmjua',
          fontSize: 16,
          color: Color.fromARGB(255, 80, 78, 91)),
    );
  }
}
