import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/screens/chart/widget/car_health_line_graph_card.dart';
import 'package:dogdack/screens/chart/widget/car_health_progress_card.dart';
import 'package:dogdack/screens/chart/widget/dounut_chart.dart';
import 'package:dogdack/screens/chart/widget/graph_day.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../commons/logo_widget.dart';
import '../../controllers/chart_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/dog_data.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late CollectionReference<DogData> petRef;
  final chartController = Get.put(ChartController());
  final userController = Get.put(UserController());

  // getName() async {
  //   Map dogNames = {};
  //
  //   var dogDoc = await FirebaseFirestore.instance
  //       .collection('Users/${userController.loginEmail}/Pets')
  //       .orderBy('name')
  //       .get();
  //   for (int i = 0; i < dogDoc.docs.length; i++) {
  //     String name = dogDoc.docs[i]['name'].toString();
  //     if (!dogNames.keys.toList().contains(name)) {
  //       dogNames[name] = dogDoc.docs[i].id.toString();
  //     }
  //   }
  //   chartController.dogNames = dogNames;
  //   setState(() {});
  // }

  @override
  void initState() {
    chartController.selectedDateValue.value = "일주일";
    setState(() {

    });
    chartController.getNames().then((value) {
      if (chartController.dogNames.keys.toList().length != 0) {
        chartController.chartSelectedId.value =
        chartController.dogNames.values.toList()[0];
        chartController.chartSelectedName.value =
        chartController.dogNames.keys.toList()[0];
        chartController.goalTime = chartController.dogGoal.values.toList()[0];
      };
      // setChartData();
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
  List<double> day_hour_points = [0.001, 0.001];
  List<double> last_day_hour_points = [0.001, 0.001];
  List<double> week_hour_points = [0.001, 0.001];
  List<double> last_week_hour_points = [0.001, 0.001];

  List<double> day_distance_points = [0.001, 0.001];
  List<double> last_day_distance_points = [0.001, 0.001];
  List<double> week_distance_points = [0.001, 0.001];
  List<double> last_week_distance_points = [0.001, 0.001];

  List<double> day_goal_points = [0.001, 0.001];
  List<double> last_day_goal_points = [0.001, 0.001];
  List<double> week_goal_points = [0.001, 0.001];
  List<double> last_week_goal_points = [0.001, 0.001];

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

  void setChartData() {
    if (chartController.chartData.isEmpty ||
        chartController.chartSelectedId.isEmpty ||
        chartController.chartData[chartController.chartSelectedId].isNull) {
    } else {
      day_hour_data = 0;
      week_hour_data = 0;
      day_distance_data = 0;
      week_distance_data = 0;
      day_goal_data = 0;
      week_goal_data = 0;
      if (!chartController
          .chartData[chartController.chartSelectedId]!["hour"].isNull) {
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
          if (day_hour_points[i] > 0.1) {
            day_hour_data += day_hour_points[i];
          } else {
            day_hour_data += 0;
            day_hour_points[i] = 0.000001;
          }
          if (last_day_hour_points[i] > 0.1) {
            last_day_hour_data += last_day_hour_points[i];
          } else {
            last_day_hour_data += 0;
            last_day_hour_points[i]=0.000001;
          }
          if (day_distance_points[i] > 0.1) {
            day_distance_data += day_distance_points[i];
          } else {
            day_distance_data += 0;
            day_distance_points[i]=0.000001;
          }
          if (last_day_distance_points[i] > 0.1) {
            last_day_distance_data += last_day_distance_points[i];
          } else {
            last_day_distance_data += 0;
            last_day_distance_points[i]=0.000001;
          }
          if (day_goal_points[i]> 0.1) {
            day_goal_data += day_goal_points[i];
          } else {
            day_goal_data += chartController.goalTime;
            day_goal_points[i]=0.000001;
          }
          if (last_day_goal_points[i] > 0.1) {
            last_day_goal_data += last_day_goal_points[i];
          } else {
            last_day_goal_data += chartController.goalTime;
            last_day_goal_points[i]=0.000001;
          }
        }

        day_hour_data /= day_hour_points.length;
        last_day_hour_data /= last_day_hour_points.length;
        day_distance_data /= day_distance_points.length;
        last_day_distance_data /= last_day_distance_points.length;
        day_goal_data /= day_goal_points.length;
        last_day_goal_data /= last_day_goal_points.length;

        for (int i = 0; i < week_hour_points.length; i++) {
          if (week_hour_points[i] > 0.1) {
            week_hour_data += week_hour_points[i];
          } else {
            week_hour_data += 0;
            week_hour_points[i] = 0.000001;
          }
          if (last_week_hour_points[i] > 0.1) {
            last_week_hour_data += last_week_hour_points[i];
          } else {
            last_week_hour_data += 0;
            last_week_hour_points[i]=0.000001;
          }
          if (week_distance_points[i] > 0.1) {
            week_distance_data += week_distance_points[i];
          } else {
            week_distance_data += 0;
            week_distance_points[i]=0.000001;
          }
          if (last_week_distance_points[i] > 0.1) {
            last_week_distance_data += last_week_distance_points[i];
          } else {
            last_week_distance_data += 0;
            last_week_distance_points[i]=0.000001;
          }
          if (week_goal_points[i] > 0.1) {
            week_goal_data += week_goal_points[i];
          } else {
            week_goal_data += chartController.goalTime;
            week_goal_points[i]=0.000001;
          }
          if (last_week_goal_points[i] > 0.1) {
            last_week_goal_data += last_week_goal_points[i];
          } else {
            last_week_goal_data += chartController.goalTime;
            last_week_goal_points[i]=0.000001;
          }
        }
        week_hour_data /= week_hour_points.length;
        last_week_hour_data /= last_week_hour_points.length;
        week_distance_data /= week_distance_points.length;
        last_week_distance_data /= last_week_distance_points.length;
        week_goal_data /= week_goal_points.length;
        last_week_goal_data /= last_week_goal_points.length;


        if (day_goal_data > 0.1) {
          day_achievement_rate = (day_hour_data / day_goal_data) * 100;
        } else {
          day_achievement_rate = 0;
        }
        if (last_day_goal_data >0.1) {
          last_day_achievement_rate =
              (last_day_hour_data / last_day_goal_data) * 100;
        } else {
          last_day_goal_data = 0;
        }
        if (week_goal_data>0.1) {
          week_achievement_rate = (week_hour_data / week_goal_data) * 100;
        } else {
          week_achievement_rate = 0;
        }
        if (last_week_goal_data >0.1) {
          last_week_achievement_rate =
              (last_week_hour_data / last_week_goal_data) * 100;
        } else {
          last_week_goal_data = 0;
        }

        day_hour_increment = day_hour_data - last_day_hour_data;
        if (day_hour_increment > 0) {
          day_hour_increment_text = "늘었어요!";
        } else if (day_hour_increment < 0) {
          day_hour_increment_text = "즐었어요!";
        }

        week_hour_increment = week_hour_data - last_week_hour_data;
        if (week_hour_increment > 0) {
          week_hour_increment_text = "늘었어요!";
        } else if (week_hour_increment < 0) {
          week_hour_increment_text = "즐었어요!";
        }
        day_distance_increment = day_distance_data - last_day_distance_data;
        if (day_distance_increment > 0) {
          day_distance_increment_text = "증가했어요";
        } else if (day_distance_increment < 0) {
          day_distance_increment_text = "감소했어요";
        }
        week_distance_increment = week_distance_data - last_week_distance_data;
        if (week_distance_increment > 0) {
          week_distance_increment_text = "증가했어요";
        } else if (week_distance_increment < 0) {
          week_distance_increment_text = "감소했어요";
        }

        day_achievement_rate_increment =
            day_achievement_rate - last_day_achievement_rate;
        if (day_achievement_rate_increment > 0) {
          day_achievement_increment_text = "올랐어요!";
        } else if (day_achievement_rate_increment < 0) {
          day_achievement_increment_text = "떨어졌어요!";
        }
        week_achievement_rate_increment =
            week_achievement_rate - last_week_achievement_rate;
        if (week_achievement_rate_increment > 0) {
          week_achievement_increment_text = "올랐어요!";
        } else if (week_achievement_rate_increment < 0) {
          week_achievement_increment_text = "떨어졌어요!";
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    petRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets')
        .withConverter(
        fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!),
        toFirestore: (dogData, _) => dogData.toJson());

    Color grey = const Color.fromARGB(255, 80, 78, 91);
    Color violet = const Color.fromARGB(255, 100, 92, 170);
    Color violet2 = const Color.fromARGB(255, 160, 132, 202);


    Widget achiveWidget =
    // Container();
    CalHealthProgressCardWidget(
        last_data: day_achievement_rate_increment.toInt(),
        this_data: day_achievement_rate.toInt(),
        message: day_achievement_increment_text,
        date_text: date_text);

    Widget hourWidget =
    // Container();
    CalHealthCardWidget(
      color: violet2,
      message: day_hour_increment_text,
      title: "평균 산책시간",
      points: day_hour_points,
      this_data: double.parse(day_hour_data.floorToDouble().toStringAsFixed(2)),
      last_data: double.parse(day_hour_increment.toStringAsFixed(2)).abs(),
      date_text: date_text,
      unit: "분",
      x_value: x_value,
    );

    Widget distanceWidget =
    // Container();
    CalHealthCardWidget(
      color: violet,
      message: day_distance_increment_text,
      title: "평균 산책거리",
      points: day_distance_points,
      last_data: double.parse(day_distance_increment.toStringAsFixed(2)),
      this_data: double.parse(day_distance_data.toStringAsFixed(2)).abs(),
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
          last_data: double.parse(day_distance_increment.toStringAsFixed(2)).abs(),
          this_data: double.parse(day_distance_data.toStringAsFixed(2)),
          date_text: date_text,
          unit: "미터",
          x_value: x_value,
        );
        hourWidget = CalHealthCardWidget(
          color: violet2,
          message: day_hour_increment_text,
          title: "평균 산책시간",
          points: day_hour_points,
          this_data: double.parse(day_hour_data.toStringAsFixed(2)),
          last_data: double.parse(day_hour_increment.toStringAsFixed(2)).abs(),
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
          last_data: week_distance_increment.floorToDouble().abs(),
          this_data: week_distance_data.floorToDouble(),
          date_text: date_text,
          unit: "미터",
          x_value: x_value,
        );
        hourWidget = CalHealthCardWidget(
            color: violet2,
            message: week_hour_increment_text,
            title: "평균 산책시간",
            points: week_hour_points,
            this_data: week_hour_data.floorToDouble(),
            last_data: week_hour_increment.floorToDouble().abs(),
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

    // 함수 실행 순서 바뀌면 안됨.
    chartController.getData().then((value) {});
    // chartController.getNames().then((value) {
    //
    // });
    setChartData();
    change();
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    // chartController.getNames();

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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: EdgeInsets.only(left: width * 0.05),
                child: StreamBuilder(
                  stream: petRef.snapshots(),
                  builder: (petContext, petSnapshot) {
                    if (!petSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    chartController.dogNames={};

                    for(int i=0; i<petSnapshot.data!.docs.length;i++){
                      chartController.dogNames[petSnapshot.data!.docs[i].get('name').toString()] = petSnapshot.data!.docs[i].id.toString();
                      petSnapshot.data!.docs[i].get('name').toString();
                    }

                    if (chartController.dogNames.keys.toList().length != 0) {
                      chartController.chartSelectedId.value =
                      chartController.dogNames.values.toList()[0];
                      chartController.chartSelectedName.value =
                      chartController.dogNames.keys.toList()[0];
                      chartController.goalTime = chartController.dogGoal.values.toList()[0];
                    };
                      chartController.setData();


                    // 등록한 강아지가 없으면
                    // chartController.getNames();
                    return (chartController.dogNames.keys.toList().isEmpty)
                    // 강아지를 등록해달라는 dropbar
                        ? DropdownButton(
                      underline: Container(),
                      elevation: 0,
                      value: '댕댕이를 등록해 주세요',
                      items: ['댕댕이를 등록해 주세요'].map(
                            (value) {
                          return DropdownMenuItem(
                            value: value,
                            child: new Text(value),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          // getName();
                        });
                      },
                    )
                    // 등록된 강아지가 있으면 강아지 목록으로 dropdown
                        : GetBuilder<UserController>(builder: (_) {
                      // chartController.getNames();
                      return GetBuilder<ChartController>(builder: (_) {
                        return DropdownButton(
                          icon: const Icon(
                            Icons.expand_more,
                            color: Color.fromARGB(255, 100, 92, 170),
                            size: 28,
                          ),
                          underline: Container(),
                          elevation: 0,
                          value: chartController.chartSelectedName.value,
                          items: chartController.dogNames.keys.toList().map(
                                (value) {
                              chartController.name = value;
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 100, 92, 170),
                                    fontFamily: 'bmjua',
                                    fontSize: 26,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                          // onChanged: (_){},
                          onChanged: (value) {
                            chartController.chartSelectedName.value =
                                value.toString();
                            chartController.chartSelectedId.value =
                            chartController.dogNames[value.toString()];
                            chartController.goalTime = chartController.dogGoal[value.toString()];
                            setChartData();
                            setState(() {
                              // getName();
                            });
                          },
                        );
                      });
                    });

                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Center(
                    child: DropdownButton(
                      elevation: 0,
                      focusColor: const Color.fromARGB(255, 100, 92, 170),
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
                                  color: const Color.fromARGB(255, 100, 92, 170),
                                )),
                            child: Text(
                              value,
                              style: const TextStyle(
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
            Column(
              children: <Widget>[achiveWidget, hourWidget, distanceWidget],
            ),
          ],
        ),
      ),
    );
  }
}
