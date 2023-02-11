import 'package:flutter/material.dart';

class HealthCardWidget extends StatefulWidget {
  @override
  State<HealthCardWidget> createState() => _HealthCardWidget();
}

class _HealthCardWidget extends State<HealthCardWidget> {
  // 드롭박스 값
  final List<String> _valueList = ['일', '월'];
  String _selectedValue = '일';
  // 드롭박스에 따라 변하는 그래프 값 => 디비에서 불러와야 함
  final List<double> day_points = [50, 90, 103, 180, 150, 120, 50];
  final List<double> week_points = [50, 90, 200, 100, 150, 80, 200];

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
