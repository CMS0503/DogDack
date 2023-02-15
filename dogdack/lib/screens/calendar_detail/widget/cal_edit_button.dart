import 'package:dogdack/controllers/input_controller.dart';
import 'package:dogdack/screens/calender_detail_edit/calendar_detail_edit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalEditButtonWidget extends StatelessWidget {
  CalEditButtonWidget({super.key});
  final inputcontroller = Get.put(InputController());

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Container(
      child: IconButton(
        icon: const Icon(Icons.edit),
        color: const Color.fromARGB(255, 80, 78, 91),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CalendarDetailEdit(
                day: inputcontroller.date,
              ),
            ),
          );
        }, // 편집 화면으로 가야 함
      ),
    );
  }
}
