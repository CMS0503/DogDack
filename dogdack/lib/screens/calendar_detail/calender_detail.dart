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



import '../../models/calender_data.dart';
import '../calendar_schedule_edit/controller/input_controller.dart';
import '../my/controller/mypage_controller.dart';

class CalenderDetail extends StatefulWidget {
  DateTime today;
  CalenderDetail({required this.today});

  static late Map<String, List> events;
  static late Map<String, List> w_events;


  @override
  State<CalenderDetail> createState() => _CalenderDetailState();
}

class _CalenderDetailState extends State<CalenderDetail> {

  final controller = Get.put(InputController());
  final mypageStateController = Get.put(MyPageStateController());
  final calendarRef = FirebaseFirestore.instance
      .collection('Users/${FirebaseAuth.instance.currentUser!.email}/Calendar')
      .withConverter(
          fromFirestore: (snapshot, _) => CalenderData.fromJson(snapshot.data()!),
          toFirestore: (calendarData, _) => calendarData.toJson());



  //
  // Future<Map<String, List<Object>>> getData() async {
  //   var result = await calendarRef.get();
  //
  //   for (int i = 0; i < result.docs.length; i++) {
  //     events[result.docs[i].reference.id] = [
  //       result.docs[i]['diary'],
  //       result.docs[i]['bath'],
  //       result.docs[i]['beauty'],
  //     ];
  //   }
  //   setState(() {});
  //   return events;
  // }
  //
  //
  // final Map<String, List<Object>> events = {'': []};
  // @override
  // void initState() {
  //   getData();
  // }

  ////////////////////////////////산책카드////////////////////////////////////////////
  late String place ="";
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

  /////////////// 산책 목표 달성률 카드//////////////////////////////////////////
  /*
  *  day_walk_tartget_data => 1주일 전체 산책 시간/1주일 전체 목표 시간
  *  week_walk_tartget_data => 한달 전체 산책 시간/한달 전체 목표 시간
  */
  late List<double> hour_points = day_hour_points;
  List<double> day_hour_points = [40, 30, 15, 80, 55, 40, 28];
  List<double> week_hour_points = [
    20,
    40,
    90,
    40,
    60,
    15,
    45,
    30,
    65,
    40,
    90,
    40,
    24,
    53,
    62,
    12,
    50,
    42,
    15,
    35,
    44
  ];

  late List<double> last_hour_points = last_day_hour_points;
  List<double> last_day_hour_points = [0.21, 2.0, 2.2, 1.0, 0.5, 0.8, 1.8];
  List<double> last_week_hour_points = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0.21,
    2.0,
    2.2,
    1.0,
    0.5,
    0.8,
    1.8
  ];

  late List<double> hour_target_points = day_hour_target_points;
  List<double> day_hour_target_points = [30, 30, 30, 30, 30, 30, 30];
  List<double> week_hour_target_points = [
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30
  ];

  late List<double> last_hour_target_points = last_day_hour_target_points;
  List<double> last_day_hour_target_points = [30, 30, 30, 30, 30, 30, 30];
  List<double> last_week_hour_target_points = [
    0,
    0,
    0,
    0,
    0,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30,
    30
  ];

  // 실제산책시간
  late int walk_hour_data = day_walk_hour_data;
  int day_walk_hour_data = 0;
  int week_walk_hour_data = 0;

  // 목표
  late int hour_target_data = day_walk_tartget_data;
  int day_walk_tartget_data = 0;
  int week_walk_tartget_data = 0;

  // 산책 목표 달성률
  late int walk_target_data =
      ((walk_hour_data / hour_target_data) * 100).toInt();

  // 저번주 , 저번달 산책 목표 달성률
  // 실제산책시간
  late int last_walk_hour_data = last_day_walk_hour_data;
  int last_day_walk_hour_data = 0;
  int last_week_walk_hour_data = 0;

  // 목표
  late int last_walk_hour_target_data = last_day_walk_tartget_data;
  int last_day_walk_tartget_data = 0;
  int last_week_walk_tartget_data = 0;

  // 산책 목표 달성률
  late int last_walk_target_data =
      (last_walk_hour_data / last_walk_hour_target_data).toInt();

  //증감
  late int walk_target_increment =
      (walk_target_data - last_walk_target_data).toInt();

  // 증감 표시 텍스트
  late String walk_target_increment_text = "";
  String walk_target_plus = "올랐어요!";
  String walk_targer_minus = "떨어졌어요!";

  /////////////// 평균 산책 시간 카드//////////////////////////////////////////
  late int avg_hour = walk_hour_data;

  // 저번주, 저번달
  late int last_avg_hour = last_walk_hour_data;

  //증감 (분) => 시간, 분으로 나눠야 함
  late int hour_increment = (avg_hour - last_avg_hour).toInt();

  // 증감 표시 텍스트
  late String walk_hour_increment_text = "";
  String walk_hour_plus = "늘었어요!";
  String walk_hour_minus = "줄었어요!";

  /////////////// 평균 거리 카드//////////////////////////////////////////

  //산책 거리 라인 차트 포인트
  late List<double> distance_points = day_distance_points;
  List<double> day_distance_points = [50, 90, 103, 180, 150, 120, 50];
  List<double> week_distance_points = [
    50,
    90,
    200,
    100,
    150,
    80,
    200,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];

  late int avg_distance = 0;
  int day_avg_distance = 0;
  int week_avg_distance = 0;

  //저번주, 저번달
  late List<double> last_distance_points = last_day_distance_points;
  List<double> last_day_distance_points = [100, 70, 150, 60, 0, 40, 50];
  List<double> last_week_distance_points = [50, 90,200, 100, 150, 80, 200, 100, 70, 150, 60, 0, 40, 50, 50, 90, 200, 100, 150, 80, 200, 100, 70, 150, 60, 0, 40, 50, 50];

  late int last_avg_distance = 0;
  int last_day_avg_distance = 0;
  int last_week_avg_distance = 0;

  //증감
  late int distance_increment = (avg_distance - last_avg_distance).toInt();

  // 증감 표시 텍스트
  late String walk_distance_increment_text = "";
  String walk_distance_plus = "증가했어요!";
  String walk_distance_minus = "감소했어요!";

  // late DateTime date = DateTime.now();


  // late String today = DateFormat('yyMMdd').format(date);

  //////////////////////오늘의 일기///////////////////
  //갖고와야해
  late String image_path = 'images/login/login_image.png';
  late String? diary_text = "";
  
  
  

  @override
  Widget build(BuildContext context) {

    // 달력에서 선택한 날



    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    Color grey = Color.fromARGB(255, 80, 78, 91);
    Color violet = Color.fromARGB(255, 100, 92, 170);
    Color violet2 = Color.fromARGB(255, 160, 132, 202);

    // String? do_bath = events[today]?[1].toString();
    // String? do_hair = events[today]?[2].toString();
    late Color hair_color =  grey;
    late Color bath_color = grey;



    // if(do_bath == "true"){
    //   bath_color = violet;
    // }else{
    //   bath_color = grey;
    // }
    // if(do_hair == "true"){
    //   hair_color = violet;
    // }else{
    //   bath_color = grey;
    // }



// x축 표시될 값

    List<String> days = ["월", "화", "수", "목", "금", "토", "일"];
    List<String> week_date = ["1주차", "2주차", "3주차", "4주차"];

    // 주단위 시간=> 7로 나눠서 평균
    for (int i = 0; i < 7; i++) {
      day_walk_hour_data += day_hour_points[i].toInt();
      day_walk_tartget_data += day_hour_target_points[i].toInt();
      last_day_walk_hour_data += last_day_hour_points[i].toInt();
      last_day_walk_tartget_data += last_day_hour_target_points[i].toInt();
      day_avg_distance += day_distance_points[i].toInt();
      last_day_avg_distance += last_day_distance_points[i].toInt();
    }

    day_walk_hour_data = (day_walk_hour_data / 7).toInt();
    day_walk_tartget_data = (day_walk_tartget_data / 7).toInt();

    last_day_walk_hour_data = (last_day_walk_hour_data / 7).toInt();
    last_day_walk_tartget_data = (last_day_walk_tartget_data / 7).toInt();
    day_avg_distance = (day_avg_distance / 7).toInt();
    last_day_avg_distance = (last_day_avg_distance / 7).toInt();

    // 월단위
    for (int i = 0; i < week_hour_points.length; i++) {
      week_walk_hour_data += week_hour_points[i].toInt();
      week_walk_tartget_data += week_hour_target_points[i].toInt();
      last_week_walk_hour_data += last_week_hour_points[i].toInt();
      last_week_walk_tartget_data += last_week_hour_target_points[i].toInt();
      week_avg_distance += week_distance_points[i].toInt();
      last_week_avg_distance += last_week_distance_points[i].toInt();
    }
    week_walk_hour_data =
        (week_walk_hour_data / week_hour_points.length).toInt();
    week_walk_tartget_data =
        (week_walk_tartget_data / week_hour_points.length).toInt();
    last_week_walk_hour_data =
        (last_week_walk_hour_data / week_hour_points.length).toInt();
    last_week_walk_tartget_data =
        (last_week_walk_tartget_data / week_hour_points.length).toInt();
    week_avg_distance = (week_avg_distance / week_hour_points.length).toInt();
    last_week_avg_distance =
        (last_week_avg_distance / week_hour_points.length).toInt();

    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: grey,
      ),
      title: Text(
        mypageStateController.myPageStateType == MyPageStateType.Create ? '추가하기' : '캘린더 상세페이지',
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
                          "${widget.today.year}년 ${widget.today.month}월 ${widget.today.day}일 ${widget.today.hour}시 ${widget.today.second}분에서"),
                  CalDetailDateWidget(
                      time:
                          "${widget.today.year}년 ${widget.today.month}월 ${widget.today.day}일 ${widget.today.hour}시 ${widget.today.second}분까지")
                ],
              ),
            ),
            // 산책 카드
            CalWalkCardWidget(distance: distance, imageUrl: imageUrl, place: place, totalTimeMin: totalTimeMin),
//            건강지수 타이틀  + 드롭다운 박스
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
                Widget>[
              CalDetailTitleWidget(name: "짬뽕이", title: "건강 지수"),
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
                          last_hour_points = last_day_hour_points;
                          hour_target_points = day_hour_target_points;
                          last_hour_target_points = last_day_hour_target_points;
                          walk_hour_data = day_walk_hour_data;
                          last_walk_hour_data = last_day_walk_hour_data;
                          hour_target_data = day_walk_tartget_data;
                          last_walk_hour_target_data =
                              last_day_walk_tartget_data;
                          distance_points = day_distance_points;
                          last_distance_points = last_day_distance_points;
                          avg_distance = day_avg_distance;
                          last_avg_distance = last_day_avg_distance;
                          date_text = "주";
                          x_value = x_value_day;

                          if (walk_target_increment > 0) {
                            walk_target_increment_text = walk_target_plus;
                          } else {
                            walk_target_increment_text = walk_targer_minus;
                          }

                          if (hour_increment > 0) {
                            walk_hour_increment_text = walk_hour_plus;
                          } else {
                            walk_hour_increment_text = walk_hour_minus;
                          }

                          if (distance_increment > 0) {
                            walk_distance_increment_text = walk_distance_plus;
                          } else {
                            walk_distance_increment_text = walk_distance_minus;
                          }
                        } else {
                          hour_points = week_hour_points;
                          last_hour_points = last_week_hour_points;
                          hour_target_points = week_hour_target_points;
                          last_hour_target_points =
                              last_week_hour_target_points;
                          walk_hour_data = week_walk_hour_data;
                          last_walk_hour_data = last_week_walk_hour_data;
                          hour_target_data = week_walk_tartget_data;
                          last_walk_hour_target_data =
                              last_week_walk_tartget_data;
                          distance_points = week_distance_points;
                          last_distance_points = last_week_distance_points;
                          avg_distance = week_avg_distance;
                          last_avg_distance = last_week_avg_distance;
                          date_text = "달";
                          x_value = x_value_week;

                          if (walk_target_increment > 0) {
                            walk_target_increment_text = walk_target_plus;
                          } else {
                            walk_target_increment_text = walk_targer_minus;
                          }

                          if (hour_increment > 0) {
                            walk_hour_increment_text = walk_hour_plus;
                          } else {
                            walk_hour_increment_text = walk_hour_minus;
                          }

                          if (distance_increment > 0) {
                            walk_distance_increment_text = walk_distance_plus;
                          } else {
                            walk_distance_increment_text = walk_distance_minus;
                          }
                        }
                      },
                    );
                  },
                )),
              ),
            ]),
            //건강지수 카드
            CalHealthProgressCardWidget(
                last_data: walk_target_increment,
                this_data: walk_target_data,
                message: "${walk_target_increment_text}",
                date_text: date_text),
            CalHealthCardWidget(
              color: violet2,
              message: "${walk_hour_increment_text}",
              title: "평균 산책 시간",
              points: hour_points,
              last_data: last_avg_hour,
              this_data: "${walk_hour_data}",
              date_text: date_text,
              unit: "분",
              x_value: x_value,
            ),
            CalHealthCardWidget(
              color: violet,
              message: "${walk_distance_increment_text}",
              title: "평균 산책거리",
              points: distance_points,
              last_data: last_avg_distance,
              this_data: "${avg_distance}",
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
