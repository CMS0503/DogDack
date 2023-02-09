import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../calendar_detail/calender_detail.dart';
import '../../calendar_detail/controller/calendar_detail_controller.dart';

class CalHealthDropdownWidget extends StatefulWidget {

  const CalHealthDropdownWidget({super.key});

  @override
  State<CalHealthDropdownWidget> createState() =>
      _CalHealthDropdownWidgetState();
}

class _CalHealthDropdownWidgetState extends State<CalHealthDropdownWidget> {

  final controller = Get.put(CalendarDetailController());



  final List<String> _valueList = ['일', '월'];
  var selectedValue = '일';

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Center(
          child: DropdownButton(
        elevation: 0,
        focusColor: Color.fromARGB(255, 100, 92, 170),
        borderRadius: BorderRadius.circular(10),
        value: selectedValue,
        items: _valueList.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Container(
              width: width * 0.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color: Color.fromARGB(255, 100, 92, 170),
                  )),
              child: Text(
                value,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'bmjua',
                    color: Color.fromARGB(255, 80, 78, 91)),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(
            () {
              selectedValue = value!;
              controller.drop_value.value = value;
              print(selectedValue+"여긴드롭");

            },
          );
        },
      )),
    );
  }
}
