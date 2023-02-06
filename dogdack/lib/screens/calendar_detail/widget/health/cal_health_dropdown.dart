import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../calender_detail.dart';

class CalHealthDropdownWidget extends StatefulWidget {

  @override
  State<CalHealthDropdownWidget> createState() =>
      _CalHealthDropdownWidgetState();
}

class _CalHealthDropdownWidgetState extends State<CalHealthDropdownWidget> {



  final List<String> _valueList = ['일', '월'];
  String _selectedValue = '일';

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
        value: _selectedValue,
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
              _selectedValue = value!;
            },
          );
        },
      )),
    );
  }
}
