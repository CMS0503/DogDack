import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/mypage_controller.dart';
import 'package:dogdack/screens/home/widget/bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:dogdack/commons/logo_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/home_controller.dart';
import '../../models/dog_data.dart';


class HomePage extends StatefulWidget {
  HomePage({super.key});

  final inputController = TextEditingController();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Firebase : 반려견 테이블 참조 값
  final petsRef = FirebaseFirestore.instance.collection('Users/imcsh313@naver.com/Pets')
      .withConverter(fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!), toFirestore: (dogData, _) => dogData.toJson());

  final sliderController = Get.put(HomePageSliderController());
  final homePageWalkCalculatorController = Get.put(HomePageWalkCalculatorController());
  final homePageBarChartController = Get.put(HomePageBarChartController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * 0.12),
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
                        child: Text('마이 페이지에서 댕댕이를 등록해주세요!'),
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
                    for(int liIdx = 0; liIdx < birthList.length; liIdx++) {
                      _petBirth += birthList.elementAt(liIdx);
                    }
                    int displayBirth = int.parse(_today.difference(DateTime.parse(_petBirth)).inDays.toString());

                    // 산책 달성률 구하기
                    String curDogID = petSnapshot.data!.docs[sliderController.sliderIdx].id;
                    CollectionReference refCurDogWalk = FirebaseFirestore.instance.collection('Users/imcsh313@naver.com/Pets/').doc(curDogID).collection('Walk');

                    var startOfToday = Timestamp.fromDate(DateTime.now().subtract(Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute, seconds: DateTime.now().second, milliseconds: DateTime.now().millisecond, microseconds: DateTime.now().microsecond)));
                    var endOfToday = Timestamp.fromDate(DateTime.now().add(Duration(days: 1, hours: -DateTime.now().hour, minutes: -DateTime.now().minute, seconds: -DateTime.now().second, milliseconds: -DateTime.now().millisecond, microseconds: -DateTime.now().microsecond)));

                    refCurDogWalk.where("startTime", isGreaterThanOrEqualTo: startOfToday, isLessThan: endOfToday).get().then((QuerySnapshot snapshot) {
                      num totalGoalTime = 0;
                      num totalTimeMinute = 0;
                      for (var document in snapshot.docs) {
                        totalGoalTime += document.get('goal');
                        totalTimeMinute += document.get('totalTimeMin');
                      }

                      if(totalGoalTime == 0) {
                        homePageWalkCalculatorController.compPercent = 100;
                      } else {
                        homePageWalkCalculatorController.compPercent = ((totalTimeMinute / totalGoalTime) * 100).toInt();
                      }

                      homePageWalkCalculatorController.getTodayWalkPercent();
                    });

                    //그래프 데이터 계산
                    homePageBarChartController.calculatorHomeChartData(curDogID, refCurDogWalk);

                    return Column(
                      children: [
                        Text(
                          '오늘 목표 산책 달성량',
                          style: TextStyle(
                            color: Color(0xff504E5B),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        GetBuilder<HomePageWalkCalculatorController>(builder: (_) {
                          return Text(
                            '${homePageWalkCalculatorController.compPercent}%',
                            style: TextStyle(
                                color: Color(0xff644CAA),
                                fontSize: width * 0.06
                            ),
                          );
                        }),
                        SizedBox(
                          height: height * 0.001,
                        ),
                        // 좌우 스크롤 슬라이더
                        CarouselSlider.builder(
                          options: CarouselOptions(
                            viewportFraction: 0.5,
                            enlargeCenterPage : true,
                            enlargeFactor : 0.4,
                            enableInfiniteScroll: true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                sliderController.sliderIdx = index;
                              });
                            },
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 7),
                          ),
                          itemCount: petSnapshot.data!.docs.length,
                          itemBuilder: (context, itemIndex, pageViewIndex) {
                            return CircleAvatar(
                              radius: size.width * 0.23,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: petSnapshot.data!.docs[itemIndex].get('imageUrl'),
                                  progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                            );
                          },
                        ),
                        Center(
                          child: Text(
                            petSnapshot.data!.docs[sliderController.sliderIdx].get('name'),
                            style: TextStyle(
                              color: Color(0xff644CAA),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Center(
                          child: Text(
                            '함께한지 ${displayBirth}일',
                            style: TextStyle(
                              color: Color(0xff504E5B),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.04),
                        Text(
                          '${petSnapshot.data!.docs[sliderController.sliderIdx]['name']}의 최애 산책 시간',
                          style: TextStyle(color: Color(0xaa504E5B)),
                        ),
                        SizedBox(height: size.height * 0.01),
                        HomePageBarChart(),
                        SizedBox(height: size.height * 0.01),
                        Padding(
                          padding: EdgeInsets.fromLTRB(size.width * 0.1, 0, size.width * 0.1, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.ac_unit),
                              Text('2022년 1월 1주차'),
                              Icon(Icons.ac_unit),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        )
    );
  }
}