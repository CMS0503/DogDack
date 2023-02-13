import 'package:dogdack/controllers/walk_controller.dart';
import 'package:dogdack/screens/chart/widget/car_health_line_graph_card.dart';
import 'package:dogdack/screens/calendar_detail/widget/cal_detail_title.dart';
import 'package:dogdack/screens/chart/widget/car_health_progress_card.dart';
import 'package:dogdack/screens/chart/widget/graph_day.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../commons/logo_widget.dart';
import '../../controllers/input_controller.dart';
import '../../controllers/main_controll.dart';
import '../../controllers/mypage_controller.dart';
import '../../models/dog_data.dart';

class ChartMain extends StatefulWidget {
  static Map<String, List> events = {'': []};

  const ChartMain({super.key});

  @override
  State<ChartMain> createState() => _ChartMainState();
}

class _ChartMainState extends State<ChartMain> {
  final userRef = FirebaseFirestore.instance
      .collection('Users/${'imcsh313@naver.com'.toString()}/Pets')
      .withConverter(
          fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!),
          toFirestore: (dogData, _) => dogData.toJson());

  final controller = Get.put(InputController());
  final mypageStateController = Get.put(MyPageStateController());
  final walkController = Get.put(WalkController());

  final Map<String, List<Object>> events = {'': []};

  ////////////////////////////////////////////파이어 베이스 연결 데이터/////////////////////////////////////////

//////////////////////////////////////////시간 관련 변수//////////////////////////////////////////
  // 일주일 산책 시간 그래프 포인트
  late List<double> day_hour_points = [1];

  //저번주 산책 시간 그래프
  late List<double> last_day_hour_points = [1];

  // 일주일 산책 목표 시간 포인트
  late List<double> day_goal_hour_points = [1];

  // 한달 산책 시간 그래프 포인트
  late List<double> week_hour_points = [1];

  // 저번달 산책 시간 그래프 포인트
  late List<double> last_week_hour_points = [1];

  //한달 산책 목표 시간 포인트
  late List<double> week_goal_hour_points = [1];

  // 일주일 동안 실제 산책한 평균 시간
  int sum_day_walk_hour = 1;

  // 저번주 실제 산책한 평균 시간
  int last_sum_day_walk_hour = 1;

  // 한달 동안 실제 산책한 평균 시간
  int sum_week_walk_hour = 1;

  // 저번달 실제 산책한 평균 시간
  int last_sum_week_walk_hour = 1;

  // 이번주 일주일 목표 산책 시간
  int day_goal_hour = 1;

  // 저번주 일주일 목표 산잭 시간
  int last_day_goal_hour = 1;

  // 이번달 목표 산책 시간
  int week_goal_hour = 1;

  // 저번달 목표 산잭 시간
  int last_week_goal_hour = 1;

  //산책 시간 포인트
  late List<double> hour_points = [1, 1, 1, 1, 1, 1, 1];

  //산책 시간 목표 포인트
  late List<double> hour_goal_points = [1, 1, 1, 1, 1, 1, 1];

  //산책 거리 라인 차트 포인트
  late List<double> distance_points = [1, 1, 1, 1, 1, 1, 1];

  // this 실제 산책시간
  late int walk_hour_data = 1;

  // last 실제 산책시간
  late int last_walk_hour_data = 1;

  //this 산책 목표 시간
  late num hour_goal_data = 1;

  //last 산책 목표 시간
  late int last_hour_goal_data = 1;

  // this 산책 목표 달성률
  // late int walk_goal_data = 1;

  // last 산책 목표 달성률
  late int last_walk_goal_data =
      ((walk_hour_data / hour_goal_data) * 100).toInt();

  // 산책 목표 달성률 증감
  late int walk_goal_increment = 1;

  // 산책 목표 달성률 증감 표시 텍스트
  late String walk_goal_increment_text = "";
  String walk_goal_plus = "올랐어요!";
  String walk_goal_minus = "떨어졌어요!";

  // 산책 시간 증감 표시 텍스트
  late String walk_hour_increment_text = "";
  String walk_hour_plus = "늘었어요!";
  String walk_hour_minus = "줄었어요!";

  ///////////////////////////////////////////////////거리 관련 변수////////////////////////////////////

  // 일주일 산책 거리 그래프 포인트
  late List<double> day_distance_points = [1];

  // 한달 산책 시간 그래프 포인트
  late List<double> week_distance_points = [1];

  late String imageUrl = 'images/login/login_image.png';

  // 드롭박스 값
  final List<String> _valueList = ['일주일', '한달'];
  String _selectedValue = '일주일';
  late String date_text = "주";

  late Widget x_value = DayWidget();
  Widget x_value_day = DayWidget();
  Widget x_value_week = WeekWidget();

  // this 산책 거리
  late int walk_distance_data = 1;

  // last 산책 거리
  late int last_walk_distance_data = 1;

  // 산책 거리 증감 표시 텍스트
  late String walk_distance_increment_text = "";
  String walk_distance_plus = "증가했어요!";
  String walk_distance_minus = "감소했어요!";

  /// 바뀔 강아지 이름

  Map dognames = {};

  Future<Map<String, List<Object>>> getData() async {
    // 두달 산책 시간 포인트 불러오기

    final findName = FirebaseFirestore.instance
        .collection('Users/${'imcsh313@naver.com'}/Pets');

    var docId = await findName.get();

    for (int i = 0; i < docId.docs.length; i++) {
      dognames[docId.docs[i]['name'].toString()] = docId.docs[i].id.toString();
    }
    print(dognames);
    print(dognames.values.toList()[0]);
    if (controller.selected_id.isEmpty && dognames.values.isNotEmpty) {
      controller.selected_id = dognames.values.toList()[0];
    }

    //////// 강아지 아이디 고정값으로 박아 놓음. 바꿔야 됨.
    final dayPoints = FirebaseFirestore.instance
        .collection('Users/${'imcsh313@naver.com'}/Pets')
        .doc(controller.selected_id)
        .collection('Walk')
        .where('startTime', isLessThan: DateTime.now())
        .where('startTime',
            isGreaterThan: DateTime.now().subtract(const Duration(days: 60)))
        .orderBy('startTime', descending: false);

    var pointsResult = await dayPoints.get();

    List<String> dateList = [];
    // 최신일 -> 두달전
    for (int i = 0; i < 60; i++) {
      String temp = DateTime.now().subtract(Duration(days: 59 - i)).toString();
      dateList.add(temp.substring(0, 10));
    }
    List<String> docsList = [];
    for (int i = 0; i < pointsResult.docs.length; i++) {
      docsList.add((pointsResult.docs[i]['startTime'])
          .toDate()
          .toString()
          .substring(0, 10));
    }

    day_hour_points = List<double>.filled(7, 1);
    week_hour_points = List<double>.filled(30, 1);

    last_day_hour_points = List<double>.filled(7, 1);
    last_week_hour_points = List<double>.filled(30, 1);

    day_distance_points = List<double>.filled(7, 1);
    week_distance_points = List<double>.filled(30, 1);

    day_goal_hour_points = List<double>.filled(7, 1);
    week_goal_hour_points = List<double>.filled(30, 1);

    List<double> twoMonthHour = List<double>.filled(60, 1);
    List<double> twoMonthDistance = List<double>.filled(60, 1);
    List<double> twoMonthGoal = List<double>.filled(60, 1);

    for (int i = 0; i < dateList.length; i++) {
      for (int j = 0; j < docsList.length; j++) {
        if (docsList[j] == (dateList[i])) {
          twoMonthHour[i] = pointsResult.docs[j]['totalTimeMin'].toDouble();
          twoMonthDistance[i] = pointsResult.docs[j]['distance'].toDouble();
          twoMonthGoal[i] = pointsResult.docs[j]['goal'].toDouble();
        }
      }
    }

    day_hour_points =
        twoMonthHour.sublist(twoMonthHour.length - 7, twoMonthHour.length);
    week_hour_points =
        twoMonthHour.sublist(twoMonthHour.length - 30, twoMonthHour.length);

    last_day_hour_points = twoMonthHour.sublist(
        twoMonthDistance.length - 14, twoMonthDistance.length - 7);
    last_week_hour_points =
        twoMonthHour.sublist(0, twoMonthDistance.length - 30);

    day_distance_points = twoMonthDistance.sublist(
        twoMonthDistance.length - 7, twoMonthDistance.length);
    week_distance_points = twoMonthDistance.sublist(
        twoMonthDistance.length - 30, twoMonthDistance.length);

    day_goal_hour_points =
        twoMonthGoal.sublist(twoMonthGoal.length - 7, twoMonthGoal.length);
    week_goal_hour_points =
        twoMonthGoal.sublist(twoMonthGoal.length - 30, twoMonthGoal.length);

    return events;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  ////////////////////////////////////파이어 베이스 연결 끝/////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    Color grey = const Color.fromARGB(255, 80, 78, 91);
    Color violet = const Color.fromARGB(255, 100, 92, 170);
    Color violet2 = const Color.fromARGB(255, 160, 132, 202);

    // 이번주 일주일 평균 산책 거리
    int sumDayWalkDistance = 0;

    // 이번달 평균 산책 거리
    int sumWeekWalkDistance = 0;

    // 일주일 동안 실제 산책한 평균 시간
    for (int i = 0; i < day_hour_points.length; i++) {
      sum_day_walk_hour += day_hour_points[i].toInt();
      last_sum_day_walk_hour += last_day_hour_points[i].toInt();
      sumDayWalkDistance += day_distance_points[i].toInt();
      day_goal_hour += day_goal_hour_points[i].toInt();
    }
    sum_day_walk_hour = sum_day_walk_hour ~/ day_hour_points.length;
    last_sum_day_walk_hour =
        last_sum_day_walk_hour ~/ last_day_hour_points.length;
    sumDayWalkDistance = sumDayWalkDistance ~/ day_distance_points.length;
    day_goal_hour = day_goal_hour ~/ day_goal_hour_points.length;

    // 한달 동안 실제 산책한 평균 시간
    for (int i = 0; i < week_hour_points.length; i++) {
      sum_week_walk_hour += week_hour_points[i].toInt();
      last_sum_week_walk_hour += last_week_hour_points[i].toInt();
      sumWeekWalkDistance += week_distance_points[i].toInt();
      week_goal_hour += week_goal_hour_points[i].toInt();
    }
    sum_week_walk_hour = sum_week_walk_hour ~/ week_hour_points.length;
    last_sum_week_walk_hour =
        last_sum_week_walk_hour ~/ last_week_hour_points.length;
    sumWeekWalkDistance = sumWeekWalkDistance ~/ week_distance_points.length;
    week_goal_hour = week_goal_hour ~/ week_distance_points.length;

    //산책 시간 증감
    int hourIncrement = walk_hour_data - last_walk_hour_data;
    int distanceIncrement = walk_distance_data - last_walk_distance_data;
    int walkGoalData = ((walk_hour_data / hour_goal_data) * 100).toInt();
    int walkGoalIncrement = (walkGoalData - last_walk_goal_data).toInt();

    // 각각 증감 텍스트 변경
    if (walkGoalIncrement > 0) {
      walk_goal_increment_text = walk_goal_plus;
    } else {
      walk_goal_increment_text = walk_goal_minus;
    }

    if (hourIncrement > 0) {
      walk_hour_increment_text = walk_hour_plus;
    } else {
      walk_hour_increment_text = walk_hour_minus;
    }

    if (distanceIncrement > 0) {
      walk_distance_increment_text = walk_distance_plus;
    } else {
      walk_distance_increment_text = walk_distance_minus;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.09),
        child: const LogoWidget(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: GetBuilder<MainController>(
                builder: (_) {
                  // getName();
                  return controller.valueList.isEmpty
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
                            controller.selected_id =
                                controller.dognames[value.toString()];

                            setState(() {
                              getData();
                            });
                            // ButtonController.getName();
                          },
                        )
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
                            controller.selected_id = dognames[value.toString()];
                            print(controller.selected_id);
                            // controller.selected_id = controller.dognames[value.toString()];

                            setState(() {
                              getData();
                            });
                            // ButtonController.getName();
                          },
                        );
                },
              ),
            ),
            StreamBuilder(
                stream: userRef.snapshots(),
                builder: (petContext, petSnapshot) {
                  return Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CalDetailTitleWidget(name: "짬뽕이", title: "건강 지수"),
                            // CalHealthDropdownWidget(),
                            // 날짜 바꾸는 드롭다운
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Center(
                                  child: DropdownButton(
                                elevation: 0,
                                focusColor:
                                    const Color.fromARGB(255, 100, 92, 170),
                                borderRadius: BorderRadius.circular(10),
                                value: _selectedValue,
                                items: _valueList.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Container(
                                      width: width * 0.2,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            width: 2,
                                            color: const Color.fromARGB(
                                                255, 100, 92, 170),
                                          )),
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'bmjua',
                                            color: Color.fromARGB(
                                                255, 80, 78, 91)),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _selectedValue = value!;
                                      if (_selectedValue == '일주일') {
                                        hour_points = day_hour_points;
                                        walk_hour_data = sum_day_walk_hour;
                                        last_walk_hour_data =
                                            last_sum_day_walk_hour;
                                        walk_distance_data = sumDayWalkDistance;
                                        distance_points = day_distance_points;
                                        //   last_avg_distance = last_day_avg_distance;
                                        date_text = "주";
                                        x_value = x_value_day;
                                        hour_goal_data = day_goal_hour;
                                      } else {
                                        hour_points = week_hour_points;
                                        walk_hour_data = sum_week_walk_hour;
                                        last_walk_hour_data =
                                            last_sum_week_walk_hour;
                                        walk_distance_data =
                                            sumWeekWalkDistance;
                                        distance_points = week_distance_points;
                                        date_text = "달";
                                        x_value = x_value_week;
                                        hour_goal_data = week_goal_hour;
                                      }
                                    },
                                  );
                                },
                              )),
                            ),
                          ]),
                      // Obx(() => Text('${drop_controller.drop_value.value}'),
                      // drop_controller.drop_value.value == '월'
                      // ? hour_points = week_hour_points : hour_points = week_hour_points;
                      //
                      // )
                      //건강지수 카드
                      CalHealthProgressCardWidget(
                          last_data: walkGoalIncrement.abs(),
                          this_data: walkGoalData,
                          message: walk_goal_increment_text,
                          date_text: date_text),
                      CalHealthCardWidget(
                        color: violet2,
                        message: walk_hour_increment_text,
                        title: "평균 산책 시간",
                        points: hour_points,
                        last_data: hourIncrement.abs(),
                        this_data: walk_hour_data,
                        date_text: date_text,
                        unit: "분",
                        x_value: x_value,
                      ),
                      CalHealthCardWidget(
                        color: violet,
                        message: walk_distance_increment_text,
                        title: "평균 산책거리",
                        points: distance_points,
                        last_data: distanceIncrement.abs(),
                        this_data: walk_distance_data,
                        date_text: date_text,
                        unit: "미터",
                        x_value: x_value,
                      ),
                    ],
                  );
                }),

            //
            // Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       CalDetailTitleWidget(name: "짬뽕이", title: "건강 지수"),
            //       // CalHealthDropdownWidget(),
            //       // 날짜 바꾸는 드롭다운
            //       Padding(
            //         padding: const EdgeInsets.all(3.0),
            //         child: Center(
            //             child: DropdownButton(
            //           elevation: 0,
            //           focusColor: Color.fromARGB(255, 100, 92, 170),
            //           borderRadius: BorderRadius.circular(10),
            //           value: _selectedValue,
            //           items: _valueList.map((value) {
            //             return DropdownMenuItem(
            //               value: value,
            //               child: Container(
            //                 width: width * 0.2,
            //                 decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(10),
            //                     border: Border.all(
            //                       width: 2,
            //                       color: Color.fromARGB(255, 100, 92, 170),
            //                     )),
            //                 child: Text(
            //                   value,
            //                   style: TextStyle(
            //                       fontSize: 20,
            //                       fontFamily: 'bmjua',
            //                       color: Color.fromARGB(255, 80, 78, 91)),
            //                   textAlign: TextAlign.center,
            //                 ),
            //               ),
            //             );
            //           }).toList(),
            //           onChanged: (value) {
            //             setState(
            //               () {
            //                 _selectedValue = value!;
            //                 if (_selectedValue == '일주일') {
            //                   hour_points = day_hour_points;
            //                   walk_hour_data = sum_day_walk_hour;
            //                   last_walk_hour_data = last_sum_day_walk_hour;
            //                   walk_distance_data = sum_day_walk_distance;
            //                   distance_points = day_distance_points;
            //                   //   last_avg_distance = last_day_avg_distance;
            //                   date_text = "주";
            //                   x_value = x_value_day;
            //                   hour_goal_data = day_goal_hour;
            //
            //                 } else {
            //                   hour_points = week_hour_points;
            //                   walk_hour_data = sum_week_walk_hour;
            //                   last_walk_hour_data = last_sum_week_walk_hour;
            //                   walk_distance_data = sum_week_walk_distance;
            //                   distance_points = week_distance_points;
            //                   date_text = "달";
            //                   x_value = x_value_week;
            //                   hour_goal_data = week_goal_hour;
            //
            //                 }
            //               },
            //             );
            //           },
            //         )),
            //       ),
            //     ]),
            // // Obx(() => Text('${drop_controller.drop_value.value}'),
            // // drop_controller.drop_value.value == '월'
            // // ? hour_points = week_hour_points : hour_points = week_hour_points;
            // //
            // // )
            // //건강지수 카드
            // CalHealthProgressCardWidget(
            //     last_data: walk_goal_increment.abs(),
            //     this_data: walk_goal_data,
            //     message: walk_goal_increment_text,
            //     date_text: date_text),
            // CalHealthCardWidget(
            //   color: violet2,
            //   message: "${walk_hour_increment_text}",
            //   title: "평균 산책 시간",
            //   points: hour_points,
            //   last_data: hour_increment.abs(),
            //   this_data: walk_hour_data,
            //   date_text: date_text,
            //   unit: "분",
            //   x_value: x_value,
            // ),
            // CalHealthCardWidget(
            //   color: violet,
            //   message: "${walk_distance_increment_text}",
            //   title: "평균 산책거리",
            //   points: distance_points,
            //   last_data: distance_increment.abs(),
            //   this_data: walk_distance_data,
            //   date_text: date_text,
            //   unit: "미터",
            //   x_value: x_value,
            // ),
          ],
        ),
      ),
    );
  }
}
