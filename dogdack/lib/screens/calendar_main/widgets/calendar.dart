import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/button_controller.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:dogdack/controllers/walk_controller.dart';
import 'package:dogdack/models/dog_data.dart';
import 'package:dogdack/screens/calendar_detail/calender_detail.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import 'package:table_calendar/table_calendar.dart';

import '../../../controllers/input_controller.dart';

class Calendar extends StatefulWidget {
  static Map<String, List> events = {};

  // 선택한 날짜
  final DateTime? selectedDay;

  // 보여줄 달 화면 날짜
  final DateTime focusedDay;

  const Calendar({
    super.key,
    this.selectedDay,
    required this.focusedDay,
  });

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late CollectionReference<DogData> userRef;

  // input과 walk controller 불러오기
  final controller = Get.put(InputController());
  final btnController = Get.put(ButtonController());
  final walkController = Get.put(WalkController());
  final userController = Get.put(UserController());

  // 강아지 정보 불러오기
  getName() async {
    // final controller = Get.put(InputController());
    final petsRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets');
    var dogDoc = await petsRef.get();
    List<String> dogs = [];
    // 자.. 여기다가 등록된 강아지들 다 입력하는거야
    for (int i = 0; i < dogDoc.docs.length; i++) {
      controller.dognames[dogDoc.docs[i]['name']] = '';
      dogs.insert(0, dogDoc.docs[i]['name']);
    }
    controller.valueList = dogs;

    // 근데 강아지들이 없으면?
    if (dogs.isEmpty) {
      '그냥 넘어가야지 뭐//';
    } else {
      // 강아지들이 있는데 처음 들어왔을 때 강아지 선택을 안한 상태면
      if (controller.selectedValue == '') {
        // 그냥 처음 강아지로 가져오기
        controller.selectedValue = dogs[0];
        var result = await petsRef
            .where("name", isEqualTo: controller.selectedValue)
            .get();
        if (result.docs.isNotEmpty) {
          String dogId = result.docs[0].id;
          controller.dognames[controller.selectedValue] = dogId.toString();
          // Calendar 데이터 불러오기
          final calRef = petsRef.doc(dogId).collection('Calendar');
          var data = await calRef.get();
          for (int i = 0; i < data.docs.length; i++) {
            print('여기서 날짜가 나와야됨');

            Calendar.events[
                '${data.docs[i].reference.id}/${controller.selectedValue}'] = [
              data.docs[i]['isWalk'],
              data.docs[i]['bath'],
              data.docs[i]['beauty'],
              data.docs[i]['diary'],
              data.docs[i]['imageUrl'],
            ];
            print('diary 프린트 해보는곳');
            print(data.docs[i]['diary']);
          }
          // setState(() {});
        }
      } else {
        // 그게 아니면 selectedValue로 데이터 가져오기
        var result = await petsRef
            .where("name", isEqualTo: controller.selectedValue)
            .get();
        if (result.docs.isNotEmpty) {
          String dogId = result.docs[0].id;
          controller.dognames[controller.selectedValue] = dogId.toString();
          final calRef = petsRef.doc(dogId).collection('Calendar');
          var data = await calRef.get();
          for (int i = 0; i < data.docs.length; i++) {
            print('여기서 날짜가 나와야됨');
            print(i);
            print(data.docs[i].reference.id);
            Calendar.events[
                '${data.docs[i].reference.id}/${controller.selectedValue}'] = [
              data.docs[i]['isWalk'],
              data.docs[i]['bath'],
              data.docs[i]['beauty'],
              data.docs[i]['diary'],
              data.docs[i]['imageUrl'],
            ];
          }
        }
      }
    }
    setState(() {});
  }

  int a = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      btnController.getName().then((value) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    userRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets')
        .withConverter(
            fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!),
            toFirestore: (dogData, _) => dogData.toJson());

    // getName();
    ButtonController().getName();
    Size screenSize = MediaQuery.of(context).size;
    double height = screenSize.height;

    List<dynamic> _getEventForDay(DateTime day) {
      return Calendar.events[
              '${DateFormat('yyMMdd').format(day)}/${controller.selectedValue}'] ??
          [];
    }

    var colors = [
      const Color.fromARGB(255, 100, 92, 170),
      const Color.fromARGB(255, 191, 172, 224),
      const Color.fromARGB(255, 235, 199, 232),
    ];

// Obx(() {
    return Column(
      children: [
        Container(
          height: height * 0.05,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: StreamBuilder(
              stream: userRef.snapshots(),
              builder: (petContext, petSnapshot) {
                // 등록한 강아지가 없으면
                return controller.valueList.isEmpty
                    // 강아지를 등록해달라는 dropbar
                    ? DropdownButton(
                        underline: Container(),
                        elevation: 0,
                        value: '댕댕이를 등록해 주세요',
                        items: ['댕댕이를 등록해 주세요'].map(
                          (value) {
                            walkController.curName = value;
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                        onChanged: (value) {
                          controller.selectedValue = value.toString();
                          setState(
                            () {
                              getName();
                            },
                          );
                        },
                      )
                    // 등록된 강아지가 있으면 강아지 목록으로 dropdown
                    : DropdownButton(
                        icon: const Icon(
                          Icons.expand_more,
                          color: Color.fromARGB(255, 100, 92, 170),
                          size: 28,
                        ),
                        underline: Container(),
                        elevation: 0,
                        value: controller.selectedValue,
                        items: controller.valueList.map(
                          (value) {
                            walkController.curName = value;
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 100, 92, 170),
                                  fontFamily: 'bmjua',
                                  fontSize: 24,
                                ),
                              ),
                            );
                          },
                        ).toList(),
                        onChanged: (value) {
                          controller.selectedValue = value.toString();
                          setState(() {
                            print('안녕하신가');
                            getName();
                          });
                        },
                      );
              },
            ),
          ),
        ),
        TableCalendar(
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
                return const SizedBox();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    controller.setDate(day);
                    // detail로 넘길 date
                    controller.date = day;
                    // controller.distance = Calendar.events[3].toString();
                    // print('안녕하신지요술사');
                    // print(events);
                    // print(events[0]);

                    setState(() {
                      // print('다람쥐');
                      // print(events[1].runtimeType);
                      // print("${controller.bath.runtimeType}1");
                      controller.bath = events[1] as bool;
                      controller.beauty = events[2] as bool;
                      controller.diary = events[3] as String;
                      // controller.imgUrl = events[4][0];
                      print('여기입니다 여기');
                      print(events[4].runtimeType);
                      // controller.imageUrl = events[4].toString();
                      print('다람쥐람쥐');
                      print(events);
                      // controller.diary = events[3];
                      // print('여기서 불리언확인');
                      // print(controller.beauty);
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CalenderDetail(),
                      ),
                    );
                  },
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                        child: Container(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 0,
                            child: ListTile(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(3),
                                ),
                              ),
                              tileColor: events[0] == true
                                  ? colors[0]
                                  : const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Card(
                          elevation: 0,
                          child: ListTile(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                            ),
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
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                            ),
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
        ),
      ],
    );
  }
}
