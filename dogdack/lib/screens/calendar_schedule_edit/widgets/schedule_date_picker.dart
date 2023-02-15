import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/button_controller.dart';
import 'package:dogdack/controllers/input_controller.dart';
import 'package:dogdack/controllers/user_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  // 오늘 날짜를 기본으로 저장
  final controller = Get.put(InputController());
  final userController = Get.put(UserController());
  final btnController = Get.put(ButtonController());

  DateTime date = DateTime.now();

  String docId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getName();
    setState(() {
    btnController.getName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // 년월일, 강아지 이름 들어가는 칸
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromARGB(50, 100, 92, 170),
                            width: 3,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // 년월일
                        children: [
                          TextButton(
                            child: Row(
                              children: [
                                Text(
                                  '${controller.date.year}년 ${controller.date.month}월 ${controller.date.day}일 ${DateFormat.E('ko_KR').format(controller.date)}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'bmjua',
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                // 달력 아이콘
                                const Icon(
                                  Icons.calendar_month,
                                  color: Color.fromARGB(255, 100, 92, 170),
                                  size: 32,
                                ),
                              ],
                            ),
                            // Row 클릭하면 Datepicker 팝업 뜨게
                            onPressed: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              ).then((value) {
                                if (value == null) return;
                              setState(() {
                                controller.date = value;
                              });
                              });
                            },
                          ),
                          // 드랍다운 버튼
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10, left: 20),
                              child: controller.selectedValue.isEmpty
                                  ? GestureDetector(
                                      child: const Text('멍멍이를 선택해주세요'),
                                      onTap: () {
                                        setState(() {});
                                      },
                                    )
                                  : DropdownButton(
                                      icon: const Icon(
                                        Icons.expand_more,
                                        color: Colors.black,
                                        size: 28,
                                      ),
                                      underline: Container(),
                                      value: controller.selectedValue,
                                      items: controller.valueList.map(
                                        (value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'bmjua',
                                                fontSize: 22,
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          controller.selectedValue =
                                              value.toString();
                                          controller.saveName =
                                              controller.selectedValue;
                                        });
                                      },
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
