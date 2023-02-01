import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Calendar extends StatelessWidget {
  // 선택한 날짜
  final DateTime? selectedDay;
  // 보여줄 달 화면 날짜
  final DateTime focusedDay;

  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance
          .collection(
            'Users',
          )
          .doc('${FirebaseAuth.instance.currentUser!.email}')
          .collection('Walk');

  getData() async {
    var result = await collectionReference.get();
    print(result);
    print('다녀감');
  }

  // 테스트용 이벤트 데이터
  Map<DateTime, List<Event>> events = {
    DateTime.utc(2023, 1, 25): [
      Event('title'),
      Event('title2'),
      Event('title3')
    ],
  };

  Calendar({
    super.key,
    this.selectedDay,
    required this.focusedDay,
  });

  List<Event> _getEventForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    getData();
    Size screenSize = MediaQuery.of(context).size;
    double height = screenSize.height;
    // 날짜별 박스 데코

    return TableCalendar(
      // 날짜 언어 설정
      locale: 'ko_KR',
      // 보여줄 날짜
      focusedDay: focusedDay,
      // 달력 처음 날짜
      firstDay: DateTime(2000),
      // 달력 마지막 날짜
      lastDay: DateTime(3000),
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
          padding: const EdgeInsets.only(top: 30),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: events.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 3.0,
                  right: 3.0,
                  bottom: 3.0,
                ),
                child: Container(
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: const Color.fromARGB(255, 100, 92, 170),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class Event {
  String title;

  Event(this.title);
}
