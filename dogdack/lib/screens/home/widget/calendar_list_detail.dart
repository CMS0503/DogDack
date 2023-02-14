import 'package:dogdack/screens/home/widget/week_cal_icon.dart';
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
    Color grey = Color.fromARGB(255, 80, 78, 91);
    Color violet = Color.fromARGB(255, 100, 92, 170);
    Color red = Color.fromARGB(255,204, 111, 111);
    List<String> days = ["일", "월", "화", "수", "목", "금", "토"];
    int idx = 0;

    return Container(
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(size.width * 0.01, 0, size.width * 0.01, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //일요일
            InkWell(
              child: Column(
                children: [
                  // Text(
                  //     '${homeCalendarController.sunday.month}.${homeCalendarController.sunday.day}'),
                  Text(days[idx++], style: TextStyle(color: red),),
                  SizedBox(height: 5),
                  CalIconWidget(calColor: red, iconClolor: grey),
                ],
              ),
              onTap: () {
                print(
                    '일요일을 선택하셨습니다. 선택한 강아지 문서 ID : ${homeCalendarController.queryDocumentSnapshotDog.id}');
                print(
                    '일요일을 선택하셨습니다. 선택한 강아지 이름 : ${homeCalendarController.queryDocumentSnapshotDog['name']}');
                print('일요일을 선택하셨습니다. 선택한 날짜 ${homeCalendarController.sunday}');
              },
            ),
            //월요일
            InkWell(
              child: Column(
                children: [
                  // Text(
                  //     '${homeCalendarController.monday.month}.${homeCalendarController.monday.day}'),
                  Text(days[idx++], style: TextStyle(color: violet),),
                  SizedBox(height: 5),

                  CalIconWidget(calColor: violet, iconClolor: grey),
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
                  // Text(
                  //     '${homeCalendarController.tuesday.month}.${homeCalendarController.tuesday.day}'),
                  Text(days[idx++], style: TextStyle(color: violet),),
                  SizedBox(height: 5),

                  CalIconWidget(calColor: violet, iconClolor: grey),
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
                  // Text(
                  //     '${homeCalendarController.wednesday.month}.${homeCalendarController.wednesday.day}'),
                  Text(days[idx++], style: TextStyle(color: violet),),
                  SizedBox(height: 5),

                  CalIconWidget(calColor: violet, iconClolor: grey),
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
                  // Text(
                  //     '${homeCalendarController.thursday.month}.${homeCalendarController.thursday.day}'),
                  Text(days[idx++], style: TextStyle(color: violet),),
                  SizedBox(height: 5),

                  CalIconWidget(calColor: violet, iconClolor: grey),
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
                  // Text(
                  //     '${homeCalendarController.friday.month}.${homeCalendarController.friday.day}'),
                  Text(days[idx++], style: TextStyle(color: violet),),
                  SizedBox(height: 5),

                  CalIconWidget(calColor: violet, iconClolor: grey),
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
                  // Text(
                  //     '${homeCalendarController.saturday.month}.${homeCalendarController.saturday.day}'),
                  Text(days[idx++], style: TextStyle(color: red),),
                  SizedBox(height: 5),
                  CalIconWidget(calColor: red, iconClolor: grey),
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
