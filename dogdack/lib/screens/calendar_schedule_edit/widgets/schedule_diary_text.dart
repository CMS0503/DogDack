import 'package:dogdack/controllers/input_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleDiaryText extends StatelessWidget {
  const ScheduleDiaryText({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    final controller = Get.put(InputController());
    final inputController = TextEditingController();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          // height: height * 0.2,
          width: width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextField(
              maxLength: 20,
              onChanged: (value) {
                controller.diary = value;
              },
              // controller: inputController,
              controller: TextEditingController(text: controller.diary),
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                labelStyle: const TextStyle(
                  // color: Colors.red,
                  fontSize: 22,
                  fontFamily: 'bmjua',
                ),
                filled: true,
                fillColor: Colors.white,
                label: const Text(
                  "오늘의 일기를 추가해 보세요! (최대20자)",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 121, 119, 129),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
