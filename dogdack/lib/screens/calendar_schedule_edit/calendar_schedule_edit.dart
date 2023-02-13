import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/button_controller.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:dogdack/models/calender_data.dart';
import 'package:dogdack/models/walk_data.dart';
import 'package:dogdack/controllers/input_controller.dart';
import 'package:dogdack/screens/calendar_main/calendar_main.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/calendar_snackbar.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_date_picker.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_diary_text.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_edit_bollean.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_edit_image.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_edit_walk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarScheduleEdit extends StatefulWidget {
  // 모슨요일인지 받기
  const CalendarScheduleEdit({super.key, required this.day});
  final DateTime day;

  @override
  State<CalendarScheduleEdit> createState() => _CalendarScheduleEditState();
}

class _CalendarScheduleEditState extends State<CalendarScheduleEdit> {
  final inputController = TextEditingController();
  final controller = Get.put(InputController());
  final buttonController = Get.put(ButtonController());
  final userController = Get.put(UserController());

  // 완료 버튼 클릭 시 데이터 저장
  void fbstoreWrite() async {
    // 현재 선택한 강아지 이름으로 강아지 저장
    controller.saveName = controller.selectedValue;
    // Pet Collection 접근
    final petsRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets');
    // 산책했는지 확인하는 변수(분)
    final walkCheck = (int.parse(controller.endTime.seconds.toString()) -
            int.parse(controller.startTime.seconds.toString())) /
        60;

    // walkCheck이 0이면 산책을 안한 것임
    if (walkCheck == 0) {
      controller.walkCheck = false;
    }

    // 선택된 강아지 이름으로 해당 강아지 문서 가져오기
    var result =
        await petsRef.where("name", isEqualTo: controller.saveName).get();

    // 문서의 data중 권장 산책량 data 가져오기
    var recommend = result.docs[0]['recommend'];

    // 이 if 문은 빼도 되나?
    if (result.docs.isNotEmpty) {
      // 선택한 강아지 문서 id 가져오기
      String dogId = result.docs[0].id;

      // Calendar data 입력하기
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
            // distance: controller.distance,
          ))
          .then((value) => print("document added"))
          .catchError((error) => print("Fail to add doc $error"));

      // Walk data 입력하기
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
              goal: recommend,
              isAuto: false,
              geolist: [],
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
              const DatePicker(),
              const ScheduleEditWalk(),
              const SizedBox(
                height: 30,
              ),
              const ScheduleEditBollean(),
              const ScheduleEditImage(),
              const ScheduleDiaryText(),
              SizedBox(
                width: width * 0.8,
                child: ElevatedButton(
                  onPressed: () {
                    // setState(() {});
                    FocusManager.instance.primaryFocus?.unfocus();

                    // 입력값 잘못되면 막기
                    // 선택한 강아지가 없으면 입력 못하게
                    if (controller.selectedValue == '') {
                      CalendarSnackBar().notfoundCalendarData(
                          context, CalendarSnackBarErrorType.NoDog);
                      return;
                    }
                    // 시작시간이 종료시간 보다 크면 입력 못하게
                    if (int.parse(controller.startTime.seconds.toString()) >
                        int.parse(controller.endTime.seconds.toString())) {
                      CalendarSnackBar().notfoundCalendarData(
                          context, CalendarSnackBarErrorType.TimeError);
                      return;
                    }
                    // 시작이나 종료 시간 중 하나만 입력할 때
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

                    // 문제 없으면 db에 입력하기
                    fbstoreWrite();

                    // 입력 완료하면 달력화면으로 돌아가기 위해 pop
                    Navigator.pop(context);
                    // 화면 reset하기
                    setState(() {});
                    // calendar push
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CalendarMain()));
                  },
                  // 완료 버튼 스타일
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color.fromARGB(255, 100, 92, 170),
                  ),
                  // 완료 버튼 텍스트
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
