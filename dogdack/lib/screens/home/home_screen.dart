import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/mypage_controller.dart';
import 'package:dogdack/screens/home/widget/bar_chart.dart';
import 'package:dogdack/screens/home/widget/calendar_list.dart';
import 'package:dogdack/screens/home/widget/goal_achievement.dart';
import 'package:flutter/material.dart';
import 'package:dogdack/commons/logo_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/dog_data.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  final inputController = TextEditingController();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Firebase : 반려견 테이블 참조 값
  late CollectionReference<DogData> petsRef;

  final sliderController = Get.put(HomePageSliderController());
  final homePageWalkCalculatorController = Get.put(HomePageWalkCalculatorController());
  final homePageBarChartController = Get.put(HomePageBarChartController());
  final homePageCalendarController = Get.put(HomePageCalendarController());
  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    petsRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets')
        .withConverter(
            fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!),
            toFirestore: (dogData, _) => dogData.toJson());

    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * 0.08),
          child: const LogoWidget(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, size.height * 0.02, 0, 0),
            child: Column(
              children: [
                StreamBuilder(
                  stream: petsRef.orderBy('createdAt').snapshots(),
                  builder: (petContext, petSnapshot) {
                    // 데이터를 아직 불러오지 못했으면 로딩
                    if (!petSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    // 불러온 데이터가 없을 경우 등록 안내
                    if (petSnapshot.data!.docs.length == 0) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, size.height * 0.25, 0, 0),
                          child: Column(
                            children: [
                              Image.asset('assets/dogs.png'),
                              SizedBox(height: size.height * 0.05),
                              Text('마이페이지에서 댕댕이를 등록해주세요!'),
                            ],
                          ),
                        ),
                      );
                    }

                    // 여기서 부터는 등록된 반려견이 1마리 이상 존재함.

                    // 함께 한 날짜 구하기
                    //오늘 날짜 구하기
                    var _today = DateTime.now();
                    //현재 선택된 반려견 생일 문자열 파싱
                    String _petBirthYearOrigin = petSnapshot.data!.docs[sliderController.sliderIdx].get('birth');
                    String _petBirth = '';
                    List<String> birthList = _petBirthYearOrigin.split('.');
                    for (int liIdx = 0; liIdx < birthList.length; liIdx++) {
                      _petBirth += birthList.elementAt(liIdx);
                    }
                    int displayBirth = int.parse(_today.difference(DateTime.parse(_petBirth)).inDays.toString());

                    // 산책 달성률 구하기
                    String curDogID = petSnapshot.data!.docs[sliderController.sliderIdx].id;
                    CollectionReference refCurDogWalk = petsRef.doc(curDogID).collection('Walk');

                    var startOfToday = Timestamp.fromDate(DateTime.now()
                        .subtract(Duration(
                            hours: DateTime.now().hour,
                            minutes: DateTime.now().minute,
                            seconds: DateTime.now().second,
                            milliseconds: DateTime.now().millisecond,
                            microseconds: DateTime.now().microsecond)));
                    var endOfToday = Timestamp.fromDate(DateTime.now().add(
                        Duration(
                            days: 1,
                            hours: -DateTime.now().hour,
                            minutes: -DateTime.now().minute,
                            seconds: -DateTime.now().second,
                            milliseconds: -DateTime.now().millisecond,
                            microseconds: -DateTime.now().microsecond)));

                    refCurDogWalk.where("startTime", isGreaterThanOrEqualTo: startOfToday, isLessThan: endOfToday).get().then((QuerySnapshot snapshot) {
                          num totalGoalTime = 0;
                          num totalTimeMinute = 0;
                          for (var document in snapshot.docs) {
                            totalGoalTime += document.get('goal');
                            totalTimeMinute += document.get('totalTimeMin');
                          }

                          if (totalGoalTime == 0) {
                            homePageWalkCalculatorController.compPercent = 0;
                          } else {
                            homePageWalkCalculatorController.compPercent = ((totalTimeMinute / totalGoalTime) * 100).toInt();
                          }

                          homePageWalkCalculatorController.getTodayWalkPercent();
                    });

                    //그래프 데이터 계산
                    homePageBarChartController.calculatorHomeChartData(curDogID, refCurDogWalk);

                    //홈화면 캘린더 매핑
                    homePageCalendarController.queryDocumentSnapshotDog = petSnapshot.data!.docs[sliderController.sliderIdx];

                    return Column(
                      children: [
                        //오늘 산책 달성량
                        GetBuilder<HomePageWalkCalculatorController>(builder: (_) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '오늘 ${petSnapshot.data!.docs[sliderController.sliderIdx].get('name')} 산책 달성량 ',
                                    style: TextStyle(color: Color(0xff504E5B), fontSize: 18),
                                  ),
                                  Text(
                                    '${homePageWalkCalculatorController.compPercent}%',
                                    style: TextStyle(color: Color.fromARGB(255, 100, 92, 170), fontSize: 20),
                                  ),
                                ],
                              ),
                              GoalAchievementWidget(this_data: homePageWalkCalculatorController.compPercent),
                            ],
                          );
                        }),
                        //사진 슬라이더
                        GetBuilder<HomePageCalendarController>(builder: (_) {
                          return CarouselSlider.builder(
                            options: CarouselOptions(
                              viewportFraction: 0.5,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.4,
                              enableInfiniteScroll: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  sliderController.sliderIdx = index;
                                });
                              },
                              autoPlay: homePageCalendarController.isAutoFlag,
                              autoPlayInterval: Duration(seconds: 7),
                            ),
                            itemCount: petSnapshot.data!.docs.length,
                            itemBuilder: (context, itemIndex, pageViewIndex) {
                              return CircleAvatar(
                                radius: size.width * 0.23,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: petSnapshot.data!.docs[itemIndex]
                                        .get('imageUrl'),
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                        //함께한지...
                        Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("함께한지  ", style: TextStyle(color: Color(0xff504E5B), fontSize: 18)),
                                Text("${displayBirth}일", style: TextStyle(color: Color.fromARGB(255, 221, 137, 189), fontSize: 18)),
                                Icon(Icons.favorite_border, color: Color.fromARGB(255, 221, 137, 189), size: 18)
                              ]
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        CalenderListView(), //일주일 달력
                        SizedBox(height: height * 0.05),
                        Text('최애 산책 시간', style: TextStyle(color: Color(0xff504E5B), fontSize: width * 0.05)),
                        SizedBox(height: height * 0.01),
                        HomePageBarChart(), //최애 산책 시간
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
