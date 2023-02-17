import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/user_controller.dart';
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
  final userController = Get.put(UserController());

  late CollectionReference calendarColRef;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double daysAndCalendar = size.height * 0.005;

    Color grey = Color.fromARGB(255, 80, 78, 91);
    Color violet = Color.fromARGB(255, 100, 92, 170);
    Color violetOp = Color.fromARGB(50, 100, 92, 170);
    Color red = Color.fromARGB(255,204, 111, 111);
    Color transparent = Colors.transparent;

    List<bool> listIsWalk = List.filled(7, false);
    List<String> days = ["일", "월", "화", "수", "목", "금", "토"];
    int idx = 0;

    calendarColRef = FirebaseFirestore.instance.collection('Users/${userController.loginEmail}/Pets/${homeCalendarController.queryDocumentSnapshotDog.id}/Calendar');

    homeCalendarController.strWeekDocID_sun = (homeCalendarController.sunday.year % 100).toString().padLeft(2, '0')
        + (homeCalendarController.sunday.month).toString().padLeft(2, '0')
        + (homeCalendarController.sunday.day).toString().padLeft(2, '0');
    homeCalendarController.strWeekDocID_mon = (homeCalendarController.monday.year % 100).toString().padLeft(2, '0')
        + (homeCalendarController.monday.month).toString().padLeft(2, '0')
        + (homeCalendarController.monday.day).toString().padLeft(2, '0');
    homeCalendarController.strWeekDocID_tue = (homeCalendarController.tuesday.year % 100).toString().padLeft(2, '0')
        + (homeCalendarController.tuesday.month).toString().padLeft(2, '0')
        + (homeCalendarController.tuesday.day).toString().padLeft(2, '0');
    homeCalendarController.strWeekDocID_wed = (homeCalendarController.wednesday.year % 100).toString().padLeft(2, '0')
        + (homeCalendarController.wednesday.month).toString().padLeft(2, '0')
        + (homeCalendarController.wednesday.day).toString().padLeft(2, '0');
    homeCalendarController.strWeekDocID_thu = (homeCalendarController.thursday.year % 100).toString().padLeft(2, '0')
        + (homeCalendarController.thursday.month).toString().padLeft(2, '0')
        + (homeCalendarController.thursday.day).toString().padLeft(2, '0');
    homeCalendarController.strWeekDocID_fri = (homeCalendarController.friday.year % 100).toString().padLeft(2, '0')
        + (homeCalendarController.friday.month).toString().padLeft(2, '0')
        + (homeCalendarController.friday.day).toString().padLeft(2, '0');
    homeCalendarController.strWeekDocID_sat = (homeCalendarController.saturday.year % 100).toString().padLeft(2, '0')
        + (homeCalendarController.saturday.month).toString().padLeft(2, '0')
        + (homeCalendarController.saturday.day).toString().padLeft(2, '0');

    calendarColRef.doc(homeCalendarController.strWeekDocID_sun).get().then((value) {
      if(value.exists) {
        listIsWalk[0] = value.get('isWalk');
      } else {
        listIsWalk[0] = false;
      }
      homeCalendarController.compSearchWalkExist();
    });
    calendarColRef.doc(homeCalendarController.strWeekDocID_mon).get().then((value) {
      if(value.exists) {
        listIsWalk[1] = value.get('isWalk');
      } else {
        listIsWalk[1] = false;
      }
      homeCalendarController.compSearchWalkExist();
    });
    calendarColRef.doc(homeCalendarController.strWeekDocID_tue).get().then((value) {
      if(value.exists) {
        listIsWalk[2] = value.get('isWalk');
      } else {
        listIsWalk[2] = false;
      }
      homeCalendarController.compSearchWalkExist();
    });
    calendarColRef.doc(homeCalendarController.strWeekDocID_wed).get().then((value) {
      if(value.exists) {
        listIsWalk[3] = value.get('isWalk');
      } else {
        listIsWalk[3] = false;
      }
      homeCalendarController.compSearchWalkExist();
    });
    calendarColRef.doc(homeCalendarController.strWeekDocID_thu).get().then((value) {
      if(value.exists) {
        listIsWalk[4] = value.get('isWalk');
      } else {
        listIsWalk[4] = false;
      }
      homeCalendarController.compSearchWalkExist();
    });
    calendarColRef.doc(homeCalendarController.strWeekDocID_fri).get().then((value) {
      if(value.exists) {
        listIsWalk[5] = value.get('isWalk');
      } else {
        listIsWalk[5] = false;
      }
      homeCalendarController.compSearchWalkExist();
    });
    calendarColRef.doc(homeCalendarController.strWeekDocID_sat).get().then((value) {
      if(value.exists) {
        listIsWalk[6] = value.get('isWalk');
      } else {
        listIsWalk[6] = false;
      }
      homeCalendarController.compSearchWalkExist();
    });

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
                  Text(days[0], style: TextStyle(color: red)),
                  SizedBox(height: daysAndCalendar),
                  GetBuilder<HomePageCalendarController>(builder: (_) {
                    if(listIsWalk[0]) {
                      return CalIconWidget(calColor: red, iconClolor: red);
                    } else {
                      return CalIconWidget(calColor: red, iconClolor: transparent);
                    }
                  }),
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
                  Text(days[1], style: TextStyle(color: violet)),
                  SizedBox(height: daysAndCalendar),
                  GetBuilder<HomePageCalendarController>(builder: (_) {
                    if(listIsWalk[1]) {
                      return CalIconWidget(calColor: violet, iconClolor: violet);
                    } else {
                      return CalIconWidget(calColor: violet, iconClolor: transparent);
                    }
                  }),
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
                  Text(days[2], style: TextStyle(color: violet)),
                  SizedBox(height: daysAndCalendar),
                  GetBuilder<HomePageCalendarController>(builder: (_) {
                    if(listIsWalk[2]) {
                      return CalIconWidget(calColor: violet, iconClolor: violet);
                    } else {
                      return CalIconWidget(calColor: violet, iconClolor: transparent);
                    }
                  }),
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
                  Text(days[3], style: TextStyle(color: violet)),
                  SizedBox(height: daysAndCalendar),
                  GetBuilder<HomePageCalendarController>(builder: (_) {
                    if(listIsWalk[3]) {
                      return CalIconWidget(calColor: violet, iconClolor: violet);
                    } else {
                      return CalIconWidget(calColor: violet, iconClolor: transparent);
                    }
                  }),
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
                  Text(days[4], style: TextStyle(color: violet),),
                  SizedBox(height: daysAndCalendar),
                  GetBuilder<HomePageCalendarController>(builder: (_) {
                    if(listIsWalk[4]) {
                      return CalIconWidget(calColor: violet, iconClolor: violet);
                    } else {
                      return CalIconWidget(calColor: violet, iconClolor: transparent);
                    }
                  }),
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
                  Text(days[5], style: TextStyle(color: violet),),
                  SizedBox(height: daysAndCalendar),
                  GetBuilder<HomePageCalendarController>(builder: (_) {
                    if(listIsWalk[5]) {
                      return CalIconWidget(calColor: violet, iconClolor: violet);
                    } else {
                      return CalIconWidget(calColor: violet, iconClolor: transparent);
                    }
                  }),
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
                  Text(days[6], style: TextStyle(color: red),),
                  SizedBox(height: daysAndCalendar),
                  GetBuilder<HomePageCalendarController>(builder: (_) {
                    if(listIsWalk[6]) {
                      return CalIconWidget(calColor: red, iconClolor: red);
                    } else {
                      return CalIconWidget(calColor: red, iconClolor: transparent);
                    }
                  }),
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
