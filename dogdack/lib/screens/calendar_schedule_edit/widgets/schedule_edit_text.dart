import 'package:dogdack/screens/calendar_schedule_edit/controller/input_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleEditText extends StatefulWidget {
  final name;

  const ScheduleEditText({
    super.key,
    required this.name,
  });

  @override
  State<ScheduleEditText> createState() => _ScheduleEditTextState();
}

class _ScheduleEditTextState extends State<ScheduleEditText> {
  final controller = Get.put(InputController());
  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return SizedBox(
      height: height * 0.05,
      width: width,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: width * 0.22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 2,
                color: const Color.fromARGB(255, 100, 92, 170),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 7,
              ),
              child: Text(
                '${widget.name}',
                style: const TextStyle(
                  fontFamily: 'bmjua',
                  fontSize: 20,
                  color: Color.fromARGB(255, 100, 92, 170),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: width * 0.65,
            child: TextField(
              // maxLength: 20,
              onChanged: (value) {
                if (widget.name == '장소') {
                  controller.place = value;
                } else {
                  controller.distance = value;
                }
              },
              controller: inputController,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                labelStyle: const TextStyle(
                  // color: Colors.red,
                  fontSize: 22,
                  fontFamily: 'bmjua',
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 229, 229, 230),
                label: Text(
                  "산책 ${widget.name}",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 121, 119, 129),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
