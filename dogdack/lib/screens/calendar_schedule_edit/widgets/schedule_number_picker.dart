import 'package:dogdack/screens/calendar_schedule_edit/controller/input_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:get/get.dart';

class ScheduleNumberPicker extends StatefulWidget {
  const ScheduleNumberPicker({super.key});

  @override
  State<ScheduleNumberPicker> createState() => _ScheduleNumberPickerState();
}

class _ScheduleNumberPickerState extends State<ScheduleNumberPicker> {
  final int _currentValue = 0;
  final controller = Get.put(InputController());
  final distanceController = TextEditingController();

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
                '거리',
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
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                var distance = Picker(
                    cancelText: '취소하기',
                    cancelTextStyle: const TextStyle(
                      fontFamily: 'bmjua',
                      color: Color.fromARGB(255, 100, 92, 170),
                    ),
                    confirmText: '선택하기',
                    confirmTextStyle: const TextStyle(
                      fontFamily: 'bmjua',
                      color: Color.fromARGB(255, 100, 92, 170),
                    ),
                    adapter: NumberPickerAdapter(data: [
                      const NumberPickerColumn(
                        begin: 0,
                        end: 1000,
                        jump: 100,
                      ),
                    ]),
                    hideHeader: true,
                    title: const Text(
                      "산책 거리를 선택해 주세요",
                      style: TextStyle(
                        fontFamily: 'bmjua',
                        color: Color.fromARGB(255, 100, 92, 170),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onConfirm: (Picker picker, List value) {
                      distanceController.text =
                          '${picker.getSelectedValues()[0].toString()}m';
                      controller.distance =
                          picker.getSelectedValues()[0].toString();
                      // distanceController.text = picker.getSelectedValues();
                    }).showDialog(context);
              },
              // maxLength: 20,
              onChanged: (value) {
                controller.time = value;
                setState(() {});
              },
              controller: distanceController,
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
