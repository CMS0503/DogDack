import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  // 선택한 날짜
  final DateTime? selectedDay;
  // 보여줄 달 화면 날짜
  final DateTime focusedDay;
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
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
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

        // defaultDecoration: defaultBoxDeco,
        // tablePadding: EdgeInsets.all(20),

        // 마커
        // 마커가 칸 안넘어가게
        canMarkersOverflow: false,
        // markerSize: 3,
        // markerSizeScale: 30,
        // markersAutoAligned: true,
        // 마커 기준점 조정
        // markersAnchor: 0.5,
        // 마커 위치 조정
        // markersAlignment: Alignment.center,
        // 한줄에 보여지는 마커 갯수
        // markersMaxCount: 3,
        markerDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        // markersOffset: PositionedOffset(
        //   top: 50,
        //   start: 50,
        // ),
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
      // calendarBuilders: CalendarBuilders(
      //   defaultBuilder: (context, dateTime, _) {
      //     return CalendarCellBuilder(context, dateTime, _, 0);
      //   },
      // ),
      calendarBuilders: CalendarBuilders(
          // singleMarkerBuilder: (context, date, event) {
          //   return Container(
          //     decoration: const BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Colors.red,
          //     ),
          //     width: 20,
          //     height: 20,
          //   );
          // },

          // 마커 디자인
          markerBuilder: (context, day, events) {
        if (events.isEmpty) return const SizedBox();
        return Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ListView.builder(
            // shrinkWrap: true,
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
        //  Container(
        //     width: 24,
        //     height: 24,
        //     alignment: Alignment.center,
        //     decoration: const BoxDecoration(
        //       color: Colors.red,
        //     ),
        //   )
      }),
    );
  }
}

class Event {
  String title;

  Event(this.title);
}

// Widget CalendarCellBuilder(
//     BuildContext context, DateTime dateTime, _, int type) {
//   return Container(
//     padding: const EdgeInsets.all(3),
//     child: Container(
//       padding: const EdgeInsets.only(top: 3, bottom: 3),
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.red, width: 3),
//         borderRadius: const BorderRadius.all(Radius.circular(7)),
//         color: Colors.blue,
//       ),
//       child: Column(
//         children: [
//           Text(
//             date,
//             style: const TextStyle(fontSize: 17),
//           ),
//           const Expanded(child: Text("")),
//           Text(
//             moneyString,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 12, color: nowIndexColor[900]),
//           ),
//         ],
//       ),
//     ),
//   );
// }
