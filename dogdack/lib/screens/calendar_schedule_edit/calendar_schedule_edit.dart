import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/models/calender_data.dart';
import 'package:dogdack/models/walk_data.dart';
import 'package:dogdack/screens/calendar_schedule_edit/controller/input_controller.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_date_picker.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_diary_text.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_edit_bollean.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_edit_image.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_edit_walk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarScheduleEdit extends StatefulWidget {
  const CalendarScheduleEdit({super.key});

  @override
  State<CalendarScheduleEdit> createState() => _CalendarScheduleEditState();
}

class _CalendarScheduleEditState extends State<CalendarScheduleEdit> {
  final inputController = TextEditingController();
  final controller = Get.put(InputController());

  void fbstoreWrite() {
    // print(controller.place);
    // print(controller.place);
    FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.email.toString())
        .withConverter(
          fromFirestore: (snapshot, options) =>
              CalenderData.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        )
        .add(CalenderData(
          diary: controller.diary,
        ))
        .then((value) => print("document added"))
        .catchError((error) => print("Fail to add doc $error"));

    FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.email.toString())
        .withConverter(
          fromFirestore: (snapshot, options) =>
              WalkData.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        )
        .add(WalkData(
          place: controller.place,
          time: int.parse(controller.time),
          distance: int.parse(controller.distance),
        ))
        .then((value) => print("document added"))
        .catchError((error) => print("Fail to add doc $error"));
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
                    fbstoreWrite();
                    Navigator.pop(context);
                    controller.bath = true;
                    controller.beauty = true;
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
              //   ElevatedButton(
              //       onPressed: () => fbstoreWrite(), child: Text("Text Upload")),
            ],
          ),
        ),
      ),
    );
  }
}
