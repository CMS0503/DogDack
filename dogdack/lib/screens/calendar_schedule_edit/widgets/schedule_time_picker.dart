import 'package:dogdack/screens/calendar_schedule_edit/controller/input_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleTimePicker extends StatefulWidget {
  const ScheduleTimePicker({super.key});

  @override
  State<ScheduleTimePicker> createState() => _ScheduleTimePickerState();
}

class _ScheduleTimePickerState extends State<ScheduleTimePicker> {
  Duration duration = const Duration(hours: 1, minutes: 23);
  final controller = Get.put(InputController());
  final timeController = TextEditingController();

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
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 7,
              ),
              child: Text(
                '시작',
                style: TextStyle(
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
            child: TextFormField(
              onTap: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                var time = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (!mounted) return;
                if (time == null) {
                  return;
                }
                timeController.text = time.format(context);
                controller.time = time.format(context);
              },
              // maxLength: 20,
              onChanged: (value) {
                controller.time = value;
              },
              controller: timeController,
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
                  fontSize: 22,
                  fontFamily: 'bmjua',
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 229, 229, 230),
                label: const Text(
                  "산책 시간",
                  style: TextStyle(
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
