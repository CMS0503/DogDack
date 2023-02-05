import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/models/walk_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Calendar extends StatefulWidget {
  static late Map<String, List> events;
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
  final calendarRef = FirebaseFirestore.instance
      .collection('Users/${FirebaseAuth.instance.currentUser!.email}/Calendar')
      .withConverter(
          fromFirestore: (snapshot, _) => WalkData.fromJson(snapshot.data()!),
          toFirestore: (calendarData, _) => calendarData.toJson());

  Future<Map<String, List<Object>>> getData() async {
    var result = await calendarRef.get();

    for (int i = 0; i < result.docs.length; i++) {
      events[result.docs[i].reference.id] = [
        result.docs[i]['diary'],
        result.docs[i]['bath'],
        result.docs[i]['beauty'],
      ];
    }
    setState(() {});
    return events;
  }

  final Map<String, List<Object>> events = {'': []};

  @override
  void initState() {
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
          fontSize: 19,
          color: Colors.white,
        ),
        // Chevron
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Colors.white,
          // size: 30,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Colors.white,
          // size: 30,
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
      eventLoader: _getEventForDay,
      calendarBuilders: CalendarBuilders(

          // 마커 디자인
          markerBuilder: (context, day, events) {
        if (events.isEmpty) return const SizedBox();
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListView(children: <Widget>[
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
          ]),
        );
        // return Padding(
        //   padding: const EdgeInsets.only(top: 30),
        //   child: ListView.builder(
        //     scrollDirection: Axis.vertical,
        //     itemCount: events.length,
        //     itemBuilder: (context, index) {
        //       return Padding(
        //         padding: const EdgeInsets.only(
        //           left: 3.0,
        //           right: 3.0,
        //           bottom: 3.0,
        //         ),
        //         child: Container(
        //           height: 15,
        //           decoration: BoxDecoration(
        //             shape: BoxShape.rectangle,
        //             color: colors[index],
        //             borderRadius: BorderRadius.circular(3),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // );
      }),
    );
  }
}

// class Event {
//   Object events;
//   Event(this.events);
// }