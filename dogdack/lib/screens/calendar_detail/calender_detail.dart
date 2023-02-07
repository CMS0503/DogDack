import 'package:dogdack/screens/calendar_detail/widget/beauty/beauty_icon.dart';
import 'package:dogdack/screens/calendar_detail/widget/diary/diary_widget.dart';
import 'package:dogdack/screens/calendar_detail/widget/health/car_health_line_graph_card.dart';
import 'package:dogdack/screens/calendar_detail/widget/health/car_health_progress_card.dart';
import 'package:dogdack/screens/calendar_detail/widget/cal_detail_date.dart';
import 'package:dogdack/screens/calendar_detail/widget/cal_detail_title.dart';
import 'package:dogdack/screens/calendar_detail/widget/cal_edit_button.dart';
import 'package:dogdack/screens/calendar_detail/widget/health/graph_day.dart';
import 'package:dogdack/screens/calendar_detail/widget/walk/cal_walk_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../calendar_schedule_edit/controller/input_controller.dart';
import '../my/controller/mypage_controller.dart';
import 'controller/calendar_detail_controller.dart';

class CalenderDetail extends StatefulWidget {
  static Map<String, List> events = {'': []};

  DateTime today;

  CalenderDetail({required this.today});

  @override
  State<CalenderDetail> createState() => _CalenderDetailState();
}

class _CalenderDetailState extends State<CalenderDetail> {
  final controller = Get.put(InputController());
  final mypageStateController = Get.put(MyPageStateController());

  final Map<String, List<Object>> events = {'': []};

// 캘린더에서 받아온 데이터
  String docId = '짬뽕';
  bool bath = false;
  bool beauty = false;
  String diary = "오늘의 일기";
  String today = "230206";
  late String image_path = 'images/login/login_image.png';
  late String? diary_text = "";

  ////////////////////////////////////////////파이어 베이스 연결 데이터/////////////////////////////////////////

//////////////////////////////////////////시간 관련 변수//////////////////////////////////////////
  // 일주일 산책 시간 그래프 포인트
  late List<double> day_hour_points = [1];
  // 일주일 산책 목표 시간 포인트
  late List<double> day_goal_hour_points = [1];

  // 한달 산책 시간 그래프 포인트
  late List<double> week_hour_points = [1];
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
  late int walk_goal_data =1;

  // last 산책 목표 달성률
  late int last_walk_goal_data =
  ((walk_hour_data / hour_goal_data) * 100).toInt();

  // 산책 목표 달성률 증감
  late int walk_goal_increment =1;

  // 산책 목표 달성률 증감 표시 텍스트
  late String walk_goal_increment_text = "";
  String walk_goal_plus = "올랐어요!";
  String walk_goal_minus = "떨어졌어요!";

  //산책 시간 증감
  late int hour_increment = walk_hour_data - last_walk_hour_data;

  // 산책 시간 증감 표시 텍스트
  late String walk_hour_increment_text = "";
  String walk_hour_plus = "늘었어요!";
  String walk_hour_minus = "줄었어요!";


  ///////////////////////////////////////////////////거리 관련 변수////////////////////////////////////

  // 일주일 산책 거리 그래프 포인트
  late List<double> day_distance_points = [1];

  // 한달 산책 시간 그래프 포인트
  late List<double> week_distance_points = [1];


  // 이번주 일주일 평균 산책 거리
  int sum_day_walk_distance = 1;

  // 저번주 일주일 평균 산책 거리
  int lase_sum_day_walk_distance = 1;

  // 이번달 평균 산책 거리
  int sum_week_walk_distance = 1;

  // 저번달 평균 산책 거리
  int last_sum_week_walk_distance = 1;



  late String place = "";
  late num distance = 1;
  late num totalTimeMin = 1;
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

  //산책 거리 증감
  late int distance_increment = walk_distance_data - last_walk_distance_data;

  // 산책 거리 증감 표시 텍스트
  late String walk_distance_increment_text = "";
  String walk_distance_plus = "증가했어요!";
  String walk_distance_minus = "감소했어요!";




  Future<Map<String, List<Object>>> getData() async {
    // 두달 산책 시간 포인트 불러오기
    final day_points = FirebaseFirestore.instance
        .collection('Users/${FirebaseAuth.instance.currentUser!.email}/Pets')
        .doc(docId)
        .collection('Walk')
        .where('startTime', isLessThan: DateTime.now())
        .where('startTime',
            isGreaterThan: DateTime.now().subtract(Duration(days: 60))).orderBy('startTime',  descending: false);

    var points_result = await day_points.get();

    for (int i = 0; i < points_result.docs.length; i++) {

      if (i == 0) {
        day_hour_points[i] = points_result.docs[i]['totalTimeMin'].toDouble();
        week_hour_points[i] = points_result.docs[i]['totalTimeMin'].toDouble();
        day_distance_points[i] = points_result.docs[i]['distance'].toDouble();
        week_distance_points[i] = points_result.docs[i]['distance'].toDouble();
        day_goal_hour_points[i] = points_result.docs[i]['goal'].toDouble();
      } else {
        //이번주
        if (i < 7) {
          day_hour_points.add(points_result.docs[i]['totalTimeMin'].toDouble());
          day_distance_points.add(points_result.docs[i]['distance'].toDouble());
          day_goal_hour_points.add(points_result.docs[i]['goal'].toDouble());
        }
        if (i < 28) {

          week_hour_points
              .add(points_result.docs[i]['totalTimeMin'].toDouble());
          week_distance_points
              .add(points_result.docs[i]['distance'].toDouble());
          week_goal_hour_points.add(points_result.docs[i]['goal'].toDouble());

        }
      }
      // if(i>6 && i<14){
      //   last_day_hour_points.add(points_result.docs[i]['totalTimeMin'].toDouble());
      // }
      // if(i>28 && i<56){
      //   last_week_hour_points.add(points_result.docs[i]['totalTimeMin'].toDouble());
      // }
    }
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

    // 일주일 동안 실제 산책한 평균 시간
    for (int i = 0; i < day_hour_points.length; i++) {
      sum_day_walk_hour += day_hour_points[i].toInt();
      sum_day_walk_distance += day_distance_points[i].toInt();
      day_goal_hour += day_goal_hour_points[i].toInt();
    }
    sum_day_walk_hour = (sum_day_walk_hour / day_hour_points.length).toInt();
    sum_day_walk_distance = (sum_day_walk_distance / day_distance_points.length).toInt();
    day_goal_hour = (day_goal_hour / day_goal_hour_points.length).toInt();

    // 한달 동안 실제 산책한 평균 시간
    for (int i = 0; i < week_hour_points.length; i++) {
      sum_week_walk_hour += week_hour_points[i].toInt();
      sum_week_walk_distance += week_distance_points[i].toInt();
      week_goal_hour += week_goal_hour_points[i].toInt();
    }
    sum_week_walk_hour = (sum_week_walk_hour / week_hour_points.length).toInt();
    sum_week_walk_distance = (sum_week_walk_distance / week_distance_points.length).toInt();
    week_goal_hour = (week_goal_hour / week_distance_points.length).toInt();
    hour_increment = walk_hour_data - last_walk_hour_data;
    distance_increment = walk_distance_data - last_walk_distance_data;
    walk_goal_data =
        ((walk_hour_data / hour_goal_data) * 100).toInt();
    walk_goal_increment =
        (walk_goal_data - last_walk_goal_data).toInt();











    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    Color grey = Color.fromARGB(255, 80, 78, 91);
    Color violet = Color.fromARGB(255, 100, 92, 170);
    Color violet2 = Color.fromARGB(255, 160, 132, 202);

    late Color hair_color = grey;
    late Color bath_color = grey;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: grey,
        ),
        title: Text(
          mypageStateController.myPageStateType == MyPageStateType.Create
              ? '추가하기'
              : '캘린더 상세페이지',
          style: TextStyle(
            color: grey,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //산책 타이틀 +  편집 버튼
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CalDetailTitleWidget(name: "짬뽕이", title: "산책"),
                  CalEditButtonWidget(),
                ]),
            //날짜
            Padding(
              padding: EdgeInsets.only(left: 18, bottom: 15),
              child: Column(
                children: [
                  // 등록한 날짜가 나와야 함
                  CalDetailDateWidget(
                      time:
                          "${controller.date.year}년 ${controller.date.month}월 ${controller.date.day}일 ${controller.date.hour}시 ${controller.date.second}분에서"),
                  CalDetailDateWidget(
                      time:
                          "${controller.date.year}년 ${controller.date.month}월 ${controller.date.day}일 ${controller.date.hour}시 ${controller.date.second}분까지")
                ],
              ),
            ),
            // 산책 카드
            CalWalkCardWidget(
                distance: distance,
                imageUrl: imageUrl,
                place: place,
                totalTimeMin: totalTimeMin),
//            건강지수 타이틀  + 드롭다운 박스

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CalDetailTitleWidget(name: "짬뽕이", title: "건강 지수"),
                  // CalHealthDropdownWidget(),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Center(
                        child: DropdownButton(
                      elevation: 0,
                      focusColor: Color.fromARGB(255, 100, 92, 170),
                      borderRadius: BorderRadius.circular(10),
                      value: _selectedValue,
                      items: _valueList.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Container(
                            width: width * 0.2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 2,
                                  color: Color.fromARGB(255, 100, 92, 170),
                                )),
                            child: Text(
                              value,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'bmjua',
                                  color: Color.fromARGB(255, 80, 78, 91)),
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
                              walk_distance_data = sum_day_walk_distance;
                              distance_points = day_distance_points;
                              //   last_avg_distance = last_day_avg_distance;
                              date_text = "주";
                              x_value = x_value_day;
                              // 각각 증감 텍스트 변경
                              if (walk_goal_increment > 0) {
                                walk_goal_increment_text = walk_goal_plus;
                              } else {
                                walk_goal_increment_text = walk_goal_minus;
                              }

                              if (hour_increment > 0) {
                                walk_hour_increment_text = walk_hour_plus;
                              } else {
                                walk_hour_increment_text = walk_hour_minus;
                              }

                              if (distance_increment > 0) {
                                walk_distance_increment_text =
                                    walk_distance_plus;
                              } else {
                                walk_distance_increment_text =
                                    walk_distance_minus;
                              }
                            } else {
                              hour_points = week_hour_points;
                              walk_hour_data = sum_week_walk_hour;
                              walk_distance_data = sum_week_walk_distance;
                              distance_points = week_distance_points;
                              date_text = "달";
                              x_value = x_value_week;

                              // 각각 증감 텍스트 변경
                              if (walk_goal_increment > 0) {
                                walk_goal_increment_text = walk_goal_plus;
                              } else {
                                walk_goal_increment_text = walk_goal_minus;
                              }
                              if (hour_increment > 0) {
                                walk_hour_increment_text = walk_hour_plus;
                              } else {
                                walk_hour_increment_text = walk_hour_minus;
                              }
                              if (distance_increment > 0) {
                                walk_distance_increment_text =
                                    walk_distance_plus;
                              } else {
                                walk_distance_increment_text =
                                    walk_distance_minus;
                              }
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
                last_data: walk_goal_increment,
                this_data: walk_goal_data,
                message: "${walk_goal_increment_text}",
                date_text: date_text),
            CalHealthCardWidget(
              color: violet2,
              message: "${walk_hour_increment_text}",
              title: "평균 산책 시간",
              points: hour_points,
              last_data: hour_increment,
              this_data: walk_hour_data,
              date_text: date_text,
              unit: "분",
              x_value: x_value,
            ),
            CalHealthCardWidget(
              color: violet,
              message: "${walk_distance_increment_text}",
              title: "평균 산책거리",
              points: distance_points,
              last_data: distance_increment,
              this_data: walk_distance_data,
              date_text: date_text,
              unit: "미터",
              x_value: x_value,
            ),
            CalDetailTitleWidget(name: "짬뽕이", title: "뷰티도장"),
            BeautyWidget(hair_color: hair_color, bath_color: bath_color),
            CalDetailTitleWidget(name: "짬뽕이", title: "오늘의 일기"),
            DiaryWidget(diary_image: image_path, diary_text: diary_text),
          ],
        ),
      ),
    );
  }
}
