import 'package:dogdack/screens/calendar_schedule_edit/controller/input_controller.dart';
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
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // appbar로 교체해야함
        const SizedBox(
          height: 100,
        ),
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
                                  '${date.year}년 ${date.month}월 ${date.day}일 ${DateFormat.E('ko_KR').format(date)}',
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
                              );
                              if (newDate == null) return;
                              setState(() => date = newDate);
                              controller.date = date;
                            },
                          ),
                          Row(
                            children: const [
                              Text(
                                '짬뽕이',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'bmjua',
                                  fontSize: 22,
                                ),
                              ),
                              Icon(
                                Icons.expand_more,
                                color: Colors.black,
                              ),
                            ],
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
