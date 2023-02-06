import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/screens/calendar_detail/calender_detail.dart';

import 'package:dogdack/screens/calendar_schedule_edit/controller/input_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Calendar extends StatefulWidget {
  static Map<String, List> events = {'': []};

  // 선택한 날짜
  final DateTime? selectedDay;

  // 보여줄 달 화면 날짜
  final DateTime focusedDay;

  const Calendar({
    super.key,
    this.selectedDay,
    // this.events,
    required this.focusedDay,
  });

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final controller = Get.put(InputController());
  final Map<String, List<Object>> events = {'': []};

  String docId = '';
  Future<Map<String, List<Object>>> getData() async {
    final petsRef = FirebaseFirestore.instance
        .collection('Users/${FirebaseAuth.instance.currentUser!.email}/pets');

    var result = await petsRef
        .where("name", isEqualTo: controller.name.toString())
        .get();

    String dogId = result.docs[0].id;

    String getName() {
      for (var name in controller.dognames) {
        if (name == controller.name) {
          return name;
        }
      }
      return 'no dog';
    }

    var dog = getName();

    if (dog == 'no dog') {
      return events;
    }

    final calRef = petsRef.doc(dogId).collection('Calendar');
    var data = await calRef.get();

    for (int i = 0; i < result.docs.length; i++) {
      events[data.docs[i].reference.id] = [
        data.docs[i]['diary'],
        data.docs[i]['bath'],
        data.docs[i]['beauty'],
      ];
    }

    setState(() {});
    return events;
    // await petsRef.get().then(
    //   (value) {
    //     for (var element in value.docs) {
    //       if (element.id == controller.name) {
    //         docId = element.id;
    //       }
    //     }
    //   },
    // );

    // if (docId == '') {
    //   return events;
    // }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double height = screenSize.height;

    List<dynamic> _getEventForDay(DateTime day) {
      return events[DateFormat('yyMMdd').format(day)] ?? [];
    }

    var colors = [
      const Color.fromARGB(255, 100, 92, 170),
      const Color.fromARGB(255, 191, 172, 224),
      const Color.fromARGB(255, 235, 199, 232),
    ];

    // 날짜별 박스 데코
    return TableCalendar(
      // 날짜 언어 설정
      locale: 'ko_KR',
      // 보여줄 날짜
      focusedDay: widget.focusedDay,
      // 달력 처음 날짜
      firstDay: DateTime(1900),
      // 달력 마지막 날짜
      lastDay: DateTime(2100),
      // 헤더
      headerStyle: const HeaderStyle(
        // 주별, 월별 포맷 제거
        formatButtonVisible: false,
        headerPadding: EdgeInsets.only(top: 3, bottom: 3),
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontFamily: 'bmjua',
          // fontWeight: FontWeight.w700,
          fontSize: 18,
          color: Colors.white,
        ),
        // Chevron
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Colors.white,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Colors.white,
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 100, 92, 170),
        ),
      ),
      // 요일 디자인
      daysOfWeekHeight: height * 0.035,
      daysOfWeekStyle: const DaysOfWeekStyle(
        // 평일
        weekdayStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
        // 주일
        weekendStyle: TextStyle(
          fontFamily: 'bmjua',
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          // fontWeight: FontWeight.w600,
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 195, 177, 228),
        ),
      ),
      // 셀 높이
      rowHeight: height * 0.11,
      calendarStyle: const CalendarStyle(
        // 오늘 날짜 표시 X
        isTodayHighlighted: false,

        // 마커
        // 마커가 칸 안넘어가게
        canMarkersOverflow: false,
        markerDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),

        // 테이블 경계선 넣기
        tableBorder: TableBorder(
          verticalInside: BorderSide(
            color: Color.fromARGB(50, 191, 172, 224),
            width: 2,
          ),
          horizontalInside: BorderSide(
            color: Color.fromARGB(50, 191, 172, 224),
            width: 2,
          ),
        ),
        // 달력 일자 위치 조정
        cellAlignment: Alignment.topRight,
        // 달력 일자 일반일 텍스트 스타일
        defaultTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: 'bmjua',
          fontWeight: FontWeight.w400,
        ),
        // 달력 일자 주말 텍스트 스타일
        weekendTextStyle: TextStyle(
          color: Colors.red,
          fontFamily: 'bmjua',
          fontWeight: FontWeight.w400,
        ),
      ),
      // firebase 산책 기록 불러오기
      eventLoader: _getEventForDay,
      calendarBuilders: CalendarBuilders(
        // 마커 디자인
        // 불러온 events 순회하면서
        markerBuilder: (context, day, events) {
          // 이벤트 비어 있으면 빈 Box
          if (events.isEmpty) {
            return ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  controller.date = day;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CalenderDetail(
                              today: day,
                            )),
                  );
                },
                child: const SizedBox());
          }
          return ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              controller.date = day;
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 0,
                      child: ListTile(
                        tileColor: events[0] == true
                            ? colors[0]
                            : const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 0,
                      child: ListTile(
                        tileColor: events[1] == true
                            ? colors[1]
                            : const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 0,
                      child: ListTile(
                        tileColor: events[2] == true
                            ? colors[2]
                            : const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
