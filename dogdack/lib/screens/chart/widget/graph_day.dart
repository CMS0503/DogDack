import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/input_controller.dart';

class DayWidget extends StatefulWidget {
  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {

  final controller = Get.put(InputController());


  List<String> days = [];


  TextStyle style = TextStyle(
      fontSize: 14,
      fontFamily: 'bmjua',
      color: Color.fromARGB(255, 80, 78, 91));

  @override
  Widget build(BuildContext context) {
    for(int i=0;i<7;i++){
      days.add(DateFormat.E('ko_KR').format(controller.today.subtract(Duration(days: 6-i))));
    }

    print(DateFormat.E('ko_KR').format(controller.today));
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    int index = 0;
    return Container(
        width: width * 0.7,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text("${days[index++]}", style: style),
              ),
              Container(
                child: Text("${days[index++]}", style: style),
              ),
              Container(
                child: Text("${days[index++]}", style: style),
              ),
              Container(
                child: Text("${days[index++]}", style: style),
              ),
              Container(
                child: Text("${days[index++]}", style: style),
              ),
              Container(
                child: Text("${days[index++]}", style: style),
              ),
              Container(
                child: Text("${days[index++]}", style: style),
              )
            ],
          ),
        ));
  }
}

class WeekWidget extends StatefulWidget {
  @override
  State<WeekWidget> createState() => _WeekWidgetState();
}

class _WeekWidgetState extends State<WeekWidget> {
  List<String> days = ["1주차","2주차","3주차","4주차"];

  TextStyle style = TextStyle(
      fontSize: 14,
      fontFamily: 'bmjua',
      color: Color.fromARGB(255, 80, 78, 91));

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    int index = 0;
    return Container(
        width: width * 0.7,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text("${days[index++]}", style: style),
              ),
              Container(
                child: Text("${days[index++]}", style: style),
              ),
              Container(
                child: Text("${days[index++]}", style: style),
              ),
              Container(
                child: Text("${days[index++]}", style: style),
              ),
            ],
          ),
        ));
  }
}

