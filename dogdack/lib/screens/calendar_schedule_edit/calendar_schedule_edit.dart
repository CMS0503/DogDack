import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/button_controller.dart';
import 'package:dogdack/models/calender_data.dart';
import 'package:dogdack/models/walk_data.dart';
import 'package:dogdack/controllers/input_controller.dart';
import 'package:dogdack/screens/calendar_main/calendar_main.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/calendar_snackbar.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_date_picker.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_diary_text.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_edit_bollean.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_edit_walk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarScheduleEdit extends StatefulWidget {
  final DateTime day;
  const CalendarScheduleEdit({super.key, required this.day});

  @override
  State<CalendarScheduleEdit> createState() => _CalendarScheduleEditState();
}

class _CalendarScheduleEditState extends State<CalendarScheduleEdit> {
  final inputController = TextEditingController();
  final controller = Get.put(InputController());
  final buttonController = Get.put(ButtonController());

  void fbstoreWrite() async {
    controller.saveName = controller.selectedValue;
    final petsRef = FirebaseFirestore.instance
        .collection('Users/${'imcsh313@naver.com'.toString()}/Pets');
    final walkCheck = (int.parse(controller.endTime.seconds.toString()) -
            int.parse(controller.startTime.seconds.toString())) /
        60;
    if (walkCheck == 0) {
      controller.walkCheck = false;
    }
    var result =
        await petsRef.where("name", isEqualTo: controller.saveName).get();
    if (result.docs.isNotEmpty) {
      String dogId = result.docs[0].id;
      petsRef
          .doc(dogId)
          .collection('Calendar')
          .doc(DateFormat('yyMMdd').format(controller.date).toString())
          .withConverter(
            fromFirestore: (snapshot, options) =>
                CalenderData.fromJson(snapshot.data()!),
            toFirestore: (value, options) => value.toJson(),
          )
          .set(CalenderData(
            diary: controller.diary,
            bath: controller.bath,
            beauty: controller.beauty,
            isWalk: controller.walkCheck,
            imageUrl: controller.imageUrl,
          ))
          .then((value) => print("document added"))
          .catchError((error) => print("Fail to add doc $error"));

      petsRef
          .doc(dogId)
          .collection('Walk')
          .doc()
          .withConverter(
            fromFirestore: (snapshot, options) =>
                WalkData.fromJson(snapshot.data()!),
            toFirestore: (value, options) => value.toJson(),
          )
          .set(
            WalkData(
              place: controller.place,
              startTime: controller.startTime,
              endTime: controller.endTime,
              totalTimeMin: (int.parse(controller.endTime.seconds.toString()) -
                      int.parse(controller.startTime.seconds.toString())) /
                  60,
              distance: int.parse(controller.distance),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return GestureDetector(
      onTap: () {
        // 암기, 아무데나 눌러도 키보드 닫히게
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: const Text(
            '캘린더 스케줄 관리',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const SizedBox(height: 20),
              const DatePicker(),
              const ScheduleEditWalk(),
              const SizedBox(
                height: 30,
              ),
              const ScheduleEditBollean(),
              // const ScheduleEditImage(),
              const ScheduleDiaryText(),
              SizedBox(
                width: width * 0.8,
                child: ElevatedButton(
                  onPressed: () {
                    // setState(() {});
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (controller.selectedValue == '') {
                      CalendarSnackBar().notfoundCalendarData(
                          context, CalendarSnackBarErrorType.NoDog);
                      return;
                    }
                    if (int.parse(controller.startTime.seconds.toString()) >
                        int.parse(controller.endTime.seconds.toString())) {
                      CalendarSnackBar().notfoundCalendarData(
                          context, CalendarSnackBarErrorType.TimeError);
                      return;
                    }
                    if (controller.startTime.seconds != '0' &&
                        controller.endTime.seconds == '0') {
                      CalendarSnackBar().notfoundCalendarData(
                          context, CalendarSnackBarErrorType.TimeError);
                    }
                    if (controller.startTime.seconds == '0' &&
                        controller.endTime.seconds != '0') {
                      CalendarSnackBar().notfoundCalendarData(
                          context, CalendarSnackBarErrorType.TimeError);
                    }
                    fbstoreWrite();

                    Navigator.pop(context);
                    // buttonController.btn += 1;
                    // buttonController.changeButtonIndex(buttonController.btn);
                    setState(() {});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CalendarMain()));

                    // print(controller.date);
                    // setState(() {});
                    // controller.bath = true;
                    // controller.beauty = true;
                    // controller.imageUrl = [];
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color.fromARGB(255, 100, 92, 170),
                  ),
                  child: const Text(
                    "완료",
                    style: TextStyle(
                      fontFamily: 'bmjua',
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
