import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';

class CalendarListDetail extends StatefulWidget {
  const CalendarListDetail({Key? key}) : super(key: key);

  @override
  State<CalendarListDetail> createState() => _CalendarListDetailState();
}

class _CalendarListDetailState extends State<CalendarListDetail> {
  //GetXController
  final homeCalendarController = Get.put(HomePageCalendarController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(size.width * 0.01, 0, size.width * 0.01, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //일요일
            InkWell(
              child: Column(
                children: [
                  Text('${homeCalendarController.sunday.month}.${homeCalendarController.sunday.day}'),
                  Icon(Icons.calendar_today_outlined, size: size.width * 0.14, color: Colors.red,),
                ],
              ),
              onTap: () {
                print('일요일을 선택하셨습니다. 선택한 강아지 문서 ID : ${homeCalendarController.queryDocumentSnapshotDog.id}');
                print('일요일을 선택하셨습니다. 선택한 강아지 이름 : ${homeCalendarController.queryDocumentSnapshotDog['name']}');
                print('일요일을 선택하셨습니다. 선택한 날짜 ${homeCalendarController.sunday}');
              },
            ),
            //월요일
            InkWell(
              child: Column(
                children: [
                  Text('${homeCalendarController.monday.month}.${homeCalendarController.monday.day}'),
                  Icon(Icons.calendar_today_outlined, size: size.width * 0.14, color: Color(0xff644CAA),),
                ],
              ),
              onTap: () {
                print(homeCalendarController.monday);
              },
            ),
            //화요일
            InkWell(
              child: Column(
                children: [
                  Text('${homeCalendarController.tuesday.month}.${homeCalendarController.tuesday.day}'),
                  Icon(Icons.calendar_today_outlined, size: size.width * 0.14, color: Color(0xff644CAA),),
                ],
              ),
              onTap: () {
                print(homeCalendarController.tuesday);
              },
            ),
            //수요일
            InkWell(
              child: Column(
                children: [
                  Text('${homeCalendarController.wednesday.month}.${homeCalendarController.wednesday.day}'),
                  Icon(Icons.calendar_today_outlined, size: size.width * 0.14, color: Color(0xff644CAA),),
                ],
              ),
              onTap: () {
                print(homeCalendarController.wednesday);
              },
            ),
            //목요일
            InkWell(
              child: Column(
                children: [
                  Text('${homeCalendarController.thursday.month}.${homeCalendarController.thursday.day}'),
                  Icon(Icons.calendar_today_outlined, size: size.width * 0.14, color: Color(0xff644CAA),),
                ],
              ),
              onTap: () {
                print(homeCalendarController.thursday);
              },
            ),
            //금요일
            InkWell(
              child: Column(
                children: [
                  Text('${homeCalendarController.friday.month}.${homeCalendarController.friday.day}'),
                  Icon(Icons.calendar_today_outlined, size: size.width * 0.14, color: Color(0xff644CAA),),
                ],
              ),
              onTap: () {
                print(homeCalendarController.friday);
              },
            ),
            //토요일
            InkWell(
              child: Column(
                children: [
                  Text('${homeCalendarController.saturday.month}.${homeCalendarController.saturday.day}'),
                  Icon(Icons.calendar_today_outlined, size: size.width * 0.14, color: Colors.red,),
                ],
              ),
              onTap: () {
                print(homeCalendarController.saturday);
              },
            ),
          ],
        ),
      ),
    );
  }
}
