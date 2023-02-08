import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/screens/calendar_schedule_edit/controller/input_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarDrop extends StatefulWidget {
  const CalendarDrop({super.key});

  @override
  State<CalendarDrop> createState() => _CalendarDropState();
}

class _CalendarDropState extends State<CalendarDrop> {
  final controller = Get.put(InputController());
  final petsRef = FirebaseFirestore.instance
      .collection('Users/${FirebaseAuth.instance.currentUser!.email}/Pets');
  // var selectedValue;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    var valueList = controller.valueList;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20),
          child: controller.valueList.isEmpty
              ? GestureDetector(
                  child: const Text('멍멍이 선택'),
                  onTap: () {
                    setState(() {});
                  },
                )
              : DropdownButton(
                  value: controller.selectedValue,
                  items: controller.valueList.map(
                    (value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(
                      () {
                        controller.selectedValue = value.toString();
                      },
                    );
                  },
                ),
        )
      ],
    );
  }
}
