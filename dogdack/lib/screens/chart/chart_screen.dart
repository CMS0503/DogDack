import 'package:dogdack/screens/chart/widget/car_health_line_graph_card.dart';
import 'package:dogdack/screens/calendar_detail/widget/cal_detail_title.dart';
import 'package:dogdack/screens/chart/widget/car_health_progress_card.dart';
import 'package:dogdack/screens/chart/widget/graph_day.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../commons/logo_widget.dart';
import '../../controllers/chart_controller.dart';

class Chart extends StatefulWidget {
  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final chartController = Get.put(ChartController());

  @override
  void initState() {
    chartController.selectedDateValue.value = "일주일";
    chartController.getNames().then((value) {
      chartController.setData().then((value) {
        setState(() {});
      });
    });
    super.initState();
  }

  // 기간 드롭박스 값
  final List<String> _valueList = ['일주일', '한달'];
  String date_text = "주";

  // 일단 냅다 리스트로 불러와
  List<double> day_hour_points = [1, 1, 1, 1, 1, 1, 1];
  List<double> last_day_hour_points = [1, 1, 1, 1, 1, 1, 1];
  List<double> week_hour_points = [1, 1, 1, 1, 1, 1, 1];
  List<double> last_week_hour_points = [1, 1, 1, 1, 1, 1, 1];

  List<double> day_distance_points = [1, 1, 1, 1, 1, 1, 1];
  List<double> last_day_distance_points = [1, 1, 1, 1, 1, 1, 1];
  List<double> week_distance_points = [1, 1, 1, 1, 1, 1, 1];
  List<double> last_week_distance_points = [1, 1, 1, 1, 1, 1, 1];

  List<double> day_goal_points = [1, 1, 1, 1, 1, 1, 1];
  List<double> last_day_goal_points = [1, 1, 1, 1, 1, 1, 1];
  List<double> week_goal_points = [1, 1, 1, 1, 1, 1, 1];
  List<double> last_week_goal_points = [1, 1, 1, 1, 1, 1, 1];

  // 이번주 실제 산책 시간
  double day_hour_data = 0;

  // 저번주 실제 산책 시간
  double last_day_hour_data = 0;

  // 이번달 실제 산책 시간
  double week_hour_data = 0;

  // 저번달 실제 산책 시간
  double last_week_hour_data = 0;

  // 이번주 실제  산책 거리
  double day_distance_data = 0;

  // 저번주 실제 산책 거리
  double last_day_distance_data = 0;

  // 이번달 실제 산책 거리
  double week_distance_data = 0;

  // 저번달 실제 산책 거리
  double last_week_distance_data = 0;

  // 이번주 산책 시간 목표
  double day_goal_data = 0;

  // 저번주  산책 시간 목표
  double last_day_goal_data = 0;

  // 이번달  산책 시간 목표
  double week_goal_data = 0;

  // 저번달  산책 시간 목표
  double last_week_goal_data = 0;

  // 이번주 산책 시간 목표 달성률
  double day_achievement_rate = 0;

  // 저번주 산책시간 목표 달성률
  double last_day_achievement_rate = 0;

  // 이번달 산책 시간 목표 달성률
  double week_achievement_rate = 0;

  // 저번달 산책시간 목표 달성률
  double last_week_achievement_rate = 0;

  // 저번주 대비 이번주 목표 달성률 증감률
  double day_achievement_rate_increment = 0;

  // 저번달 대비 이번달 목표 달성률 증감률
  double week_achievement_rate_increment = 0;

  // 저번주 대비 이번주 산책 시간 증감률
  double day_hour_increment = 0;

  // 저번달 대비 이번달 산책 시간 증감률
  double week_hour_increment = 0;

  // 저번주 대비 이번주 산책 거리 증감률
  double day_distance_increment = 0;

  // 저번달 대비 이번달 산책 거리 증감률
  double week_distance_increment = 0;

  // 산책 이번주 시간 증감 표시 텍스트
  String day_hour_increment_text = "";
  // 산책 이번달 시간 증감 표시 텍스트
  String week_hour_increment_text = "";

  // 산책 이번주 거리 증감 표시 텍스트
  String day_distance_increment_text = "";
  // 산책 이번달 거리 증감 표시 텍스트
  String week_distance_increment_text = "";

  // 산책 이번주 달성률 증감 표시 텍스트
  String day_achievement_increment_text = "";
  // 산책 이번달 달성률 증감 표시 텍스트
  String week_achievement_increment_text = "";


  Widget x_value = DayWidget();
  Widget x_value_day = DayWidget();
  Widget x_value_week = WeekWidget();

  @override
  Widget build(BuildContext context) {
    if (chartController.chartData.isEmpty) {
      print("데이터를 불러오는 중입니다.");
    } else {
      day_hour_points = chartController
          .chartData[chartController.chartSelectedId]!["hour"]!
          .sublist(60 - 7, 60);
      last_day_hour_points = chartController
          .chartData[chartController.chartSelectedId]!["hour"]!
          .sublist(60 - 14, 60 - 7);
      week_hour_points = chartController
          .chartData[chartController.chartSelectedId]!["hour"]!
          .sublist(60 - 30, 60);
      last_week_hour_points = chartController
          .chartData[chartController.chartSelectedId]!["hour"]!
          .sublist(0, 60 - 30);

      day_distance_points = chartController
          .chartData[chartController.chartSelectedId]!["distance"]!
          .sublist(60 - 7, 60);
      last_day_distance_points = chartController
          .chartData[chartController.chartSelectedId]!["distance"]!
          .sublist(60 - 14, 60 - 7);
      week_distance_points = chartController
          .chartData[chartController.chartSelectedId]!["distance"]!
          .sublist(60 - 30, 60);
      last_week_distance_points = chartController
          .chartData[chartController.chartSelectedId]!["distance"]!
          .sublist(0, 60 - 30);

      day_goal_points = chartController
          .chartData[chartController.chartSelectedId]!["goal"]!
          .sublist(60 - 7, 60);
      last_day_goal_points = chartController
          .chartData[chartController.chartSelectedId]!["goal"]!
          .sublist(60 - 14, 60 - 7);
      week_goal_points = chartController
          .chartData[chartController.chartSelectedId]!["goal"]!
          .sublist(60 - 30, 60);
      last_week_goal_points = chartController
          .chartData[chartController.chartSelectedId]!["goal"]!
          .sublist(0, 60 - 30);

      for (int i = 0; i < day_hour_points.length; i++) {
        day_hour_data += day_hour_points[i];
        last_day_hour_data += last_day_hour_points[i];
        day_distance_data += day_distance_points[i];
        last_day_distance_data += last_day_distance_points[i];
        day_goal_data += day_goal_points[i];
        last_day_goal_data += last_day_goal_points[i];
      }
      day_hour_data /= day_hour_points.length;
      last_day_hour_data /= last_day_hour_points.length;
      day_distance_data /= day_distance_points.length;
      last_day_distance_data /= last_day_distance_points.length;
      day_goal_data /= day_goal_points.length;
      last_day_goal_data /= last_day_goal_points.length;

      for (int i = 0; i < week_hour_points.length; i++) {
        week_hour_data += week_hour_points[i];
        last_week_hour_data += last_week_hour_points[i];
        week_distance_data += week_distance_points[i];
        last_week_distance_data += last_week_distance_points[i];
        week_goal_data += week_goal_points[i];
        last_week_goal_data += last_week_goal_points[i];
      }
      week_hour_data /= week_hour_points.length;
      last_week_hour_data /= last_week_hour_points.length;
      week_distance_data /= week_distance_points.length;
      last_week_distance_data /= last_week_distance_points.length;
      week_goal_data /= week_goal_points.length;
      last_week_goal_data /= last_week_goal_points.length;

      if (day_goal_data > 0) {
        day_achievement_rate = (day_hour_data / day_goal_data) * 100;
      }
      if (last_day_goal_data > 0) {
        last_day_achievement_rate =
            (last_day_hour_data / last_day_goal_data) * 100;
      }
      if (week_goal_data > 0) {
        week_achievement_rate = (week_hour_data / week_goal_data) * 100;
      }
      if (last_week_goal_data > 0) {
        last_week_achievement_rate =
            (last_week_hour_data / last_week_goal_data) * 100;
      }

      day_hour_increment = day_hour_data - last_day_hour_data;
      if(day_hour_increment>0){
        day_hour_increment_text = "늘었어요!";
      }else{
        day_hour_increment_text = "즐었어요!";
      }



      week_hour_increment = week_hour_data - last_week_hour_data;
      if(week_hour_increment>0){
        week_hour_increment_text = "늘었어요!";
      }else{
        week_hour_increment_text = "즐었어요!";
      }
      day_distance_increment = day_distance_data - last_day_distance_data;
      if(day_distance_increment>0){
        day_distance_increment_text = "증가했어요";
      }else{
        day_distance_increment_text = "감소했어요";
      }
      week_distance_increment = week_distance_data - last_week_distance_data;
      if(week_distance_increment>0){
        week_distance_increment_text = "증가했어요";
      }else{
        week_distance_increment_text = "감소했어요";
      }

      day_achievement_rate_increment =
          day_achievement_rate - last_day_achievement_rate;
      if(day_achievement_rate_increment>0){
        day_achievement_increment_text = "올랐어요!";
      }else{
        day_achievement_increment_text= "떨어졌어요!";
      }
      week_achievement_rate_increment =
          week_achievement_rate - last_week_achievement_rate;
      if(week_achievement_rate_increment>0){
        week_achievement_increment_text = "올랐어요!";
      }else{
        week_achievement_increment_text="떨어졌어요!";
      }




    }



    // 위젯 선언

    Color grey = Color.fromARGB(255, 80, 78, 91);
    Color violet = Color.fromARGB(255, 100, 92, 170);
    Color violet2 = Color.fromARGB(255, 160, 132, 202);

    Widget achiveWidget = CalHealthProgressCardWidget(
        last_data: day_achievement_rate_increment.toInt(),
        this_data: day_achievement_rate.toInt(),
        message: day_achievement_increment_text,
        date_text: date_text);

    Widget hourWidget = CalHealthCardWidget(
      color: violet2,
      message: day_hour_increment_text,
      title: "평균 산책시간",
      points: day_hour_points,
      this_data: 0,
      last_data: 0,
      date_text: date_text,
      unit: "분",
      x_value: x_value,
    );

    Widget distanceWidget = CalHealthCardWidget(
      color: violet,
      message: day_distance_increment_text,
      title: "평균 산책거리",
      points: day_distance_points,
      last_data: 0,
      this_data: 0,
      date_text: date_text,
      unit: "미터",
      x_value: x_value,
    );

    void change() {
      if (chartController.selectedDateValue.value == "일주일") {
        x_value = x_value_day;
        date_text = "주";
        distanceWidget = CalHealthCardWidget(
          color: violet,
          message: day_distance_increment_text,
          title: "평균 산책거리",
          points: day_distance_points,
          last_data: day_distance_increment.toInt().abs(),
          this_data: day_distance_data.toInt(),
          date_text: date_text,
          unit: "미터",
          x_value: x_value,
        );
        hourWidget = CalHealthCardWidget(
          color: violet2,
          message: day_hour_increment_text,
          title: "평균 산책시간",
          points: day_hour_points,
          this_data: day_hour_data.toInt().abs(),
          last_data: day_hour_increment.toInt(),
          date_text: date_text,
          unit: "분",
          x_value: x_value,
        );

        achiveWidget = CalHealthProgressCardWidget(
            last_data: day_achievement_rate_increment.toInt().abs(),
            this_data: day_achievement_rate.toInt(),
            message: day_achievement_increment_text,
            date_text: date_text);
      } else {
        x_value = x_value_week;
        date_text = "달";
        distanceWidget = CalHealthCardWidget(
          color: violet,
          message: week_distance_increment_text,
          title: "평균 산책거리",
          points: week_distance_points,
          last_data:week_distance_increment.toInt().abs() ,
          this_data: week_distance_data.toInt(),
          date_text: date_text,
          unit: "미터",
          x_value: x_value,
        );
        hourWidget = CalHealthCardWidget(
            color: violet2,
            message: week_hour_increment_text,
            title: "평균 산책시간",
            points: week_hour_points,
            this_data: week_hour_data.toInt(),
            last_data: week_hour_increment.toInt().abs(),
            date_text: date_text,
            unit: "분",
            x_value: x_value);
        achiveWidget = CalHealthProgressCardWidget(
            last_data: week_achievement_rate_increment.toInt().abs(),
            this_data: week_achievement_rate.toInt(),
            message: week_achievement_increment_text,
            date_text: date_text);
      }
    }

    change();

    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.08),
        child: const LogoWidget(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  chartController.dogNames.keys.isEmpty
                      ? Container(
                    child: Text('강아지를 등록해주세요'),
                  )
                      : DropdownButton(
                    icon: const Icon(
                      Icons.expand_more,
                      color: Color.fromARGB(255, 100, 92, 170),
                      size: 28,
                    ),
                    underline: Container(),
                    elevation: 0,
                    value: chartController.chartSelectedName.value!,
                    items: chartController.dogNames.keys.toList().map(
                          (value) {
                        // chartController.chartSelectedName.value = value!;
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
                      chartController.chartSelectedName.value =
                          value.toString();
                      chartController.chartSelectedId.value =
                      chartController.dogNames[value.toString()];
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CalDetailTitleWidget(
                          name: chartController.chartSelectedName.value,
                          title: "건강 지수"),
                      // CalHealthDropdownWidget(),
                      // 날짜 바꾸는 드롭다운
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Center(
                            child: DropdownButton(
                              elevation: 0,
                              focusColor: Color.fromARGB(255, 100, 92, 170),
                              borderRadius: BorderRadius.circular(10),
                              value: chartController.selectedDateValue.value,
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
                                chartController.selectedDateValue.value = value!;
                                setState(() {});
                              },
                            )),
                      ),
                    ]),
                achiveWidget,
                hourWidget,
                distanceWidget
              ],
            ),
          ],
        ),
      ),
    );
  }
}
