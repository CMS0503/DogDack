import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/commons/logo_widget.dart';
import 'package:dogdack/controllers/button_controller.dart';
import 'package:dogdack/controllers/input_controller.dart';
import 'package:dogdack/controllers/main_controll.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:dogdack/screens/calendar_main/widgets/calendar.dart';
import 'package:dogdack/screens/calendar_main/widgets/calendar_mark.dart';
import 'package:dogdack/screens/calendar_schedule_edit/calendar_schedule_edit.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarMain extends StatefulWidget {
  const CalendarMain({super.key});

  @override
  State<CalendarMain> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarMain> {
  final userController = Get.put(UserController());

  // late CollectionReference<DogData> userRef;

  // 선택한 날짜 초기화
  DateTime selectedDay = DateTime.utc(
    DateTime.fromMillisecondsSinceEpoch((DateTime.now().millisecondsSinceEpoch +
        DateTime.now().timeZoneOffset.inMilliseconds)
        .toInt())
        .year,
    DateTime.fromMillisecondsSinceEpoch((DateTime.now().millisecondsSinceEpoch +
                DateTime.now().timeZoneOffset.inMilliseconds)
            .toInt())
        .month,
    DateTime.fromMillisecondsSinceEpoch((DateTime.now().millisecondsSinceEpoch +
                DateTime.now().timeZoneOffset.inMilliseconds)
            .toInt())
        .day,
  );

  // 보여줄 월
  DateTime focusedDay = Timestamp.now().toDate();

  @override
  void initState() {
    // TODO: implement initState
    userController.updateUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ButtonController());
    Size screenSize = MediaQuery.of(context).size;
    double height = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.08),
        child: const LogoWidget(),
      ),
      body: GetBuilder<MainController>(builder: (_) {
        return SingleChildScrollView(
          child: StreamBuilder(
              stream: userController.userRef.snapshots(),
              builder: (petContext, petSnapshot) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Calendar(focusedDay: focusedDay),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    const CalendarMark(),
                  ],
                );
              }),
        );
      }),
      floatingActionButton: renderFloatingActionButton(),
    );
  }

  renderFloatingActionButton() {
    final inputController = Get.put(InputController());
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: const Color.fromARGB(255, 100, 92, 170),
            width: 3,
            style: BorderStyle.solid),
      ),
      child: FloatingActionButton.small(
        onPressed: () {
          inputController.imageUrl = [];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CalendarScheduleEdit(
                day: DateTime.fromMillisecondsSinceEpoch(
                    (DateTime.now().millisecondsSinceEpoch +
                        DateTime.now().timeZoneOffset.inMilliseconds)
                        .toInt()),
              ),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          size: 40,
          color: Color.fromARGB(255, 100, 92, 170),
        ),
      ),
    );
  }
}
