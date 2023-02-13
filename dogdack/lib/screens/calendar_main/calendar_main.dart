import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/commons/logo_widget.dart';
import 'package:dogdack/controllers/button_controller.dart';
import 'package:dogdack/models/dog_data.dart';
import 'package:dogdack/screens/calendar_main/widgets/calendar.dart';
import 'package:dogdack/screens/calendar_main/widgets/calendar_mark.dart';
import 'package:dogdack/screens/calendar_schedule_edit/calendar_schedule_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';

class CalendarMain extends StatefulWidget {
  const CalendarMain({super.key});

  @override
  State<CalendarMain> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarMain> {
  final userController = Get.put(UserController());

  var userRef = FirebaseFirestore.instance
      .collection('Users/${FirebaseAuth.instance.currentUser!.email}/Pets')
      .withConverter(
          fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!),
          toFirestore: (dogData, _) => dogData.toJson());

  // 선택한 날짜 초기화
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  // 보여줄 월
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    userRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets')
        .withConverter(
        fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!),
        toFirestore: (dogData, _) => dogData.toJson());
  }
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ButtonController());
    Size screenSize = MediaQuery.of(context).size;
    double height = screenSize.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.1),
        child: const LogoWidget(),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: userRef.snapshots(),
            builder: (petContext, petSnapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const CalendarDrop(),
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
      ),
      floatingActionButton: renderFloatingActionButton(),
    );
  }

  renderFloatingActionButton() {
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CalendarScheduleEdit(
                day: DateTime.now(),
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
