import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/walk_controller.dart';
import '../../models/dog_data.dart';
import './widgets/my_map.dart';
import './widgets/status.dart';
import '../../commons/logo_widget.dart';
import '../../controllers/main_controll.dart';

class WalkPage extends StatefulWidget {
  WalkPage({super.key});

  @override
  State<WalkPage> createState() => _WalkPageState();
}

class _WalkPageState extends State<WalkPage> {
  final walkController = Get.put(WalkController());
  final mainController = Get.put(MainController());

  // final petController = Get.put(PetController());

  final petsRef = FirebaseFirestore.instance
      .collection('Users/imcsh313@naver.com/Pets')
      .withConverter(
          fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!),
          toFirestore: (dogData, _) => dogData.toJson());

  bool flag = false;

  // List<bool> flagList = [];

  Color grey = const Color.fromARGB(255, 80, 78, 91);
  Color violet = const Color.fromARGB(255, 100, 92, 170);
  Color violet2 = const Color.fromARGB(255, 160, 132, 202);

  Widget mapAreaWidget(w, h) {
    return Container(
      height: h * 0.57,
      width: w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: myMap(),
      ),
    );
  }

  Widget requestBluetoothConnectWidget(w, h, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.8,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              height: h * 0.6,
              width: w,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 100,
              width: w * 0.8,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  const Text(
                    '블루투스 연결을 확인해주세요',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.bluetooth_outlined,
                        color: Colors.blue,
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/Ble'),
                        child: const Text('지금 연결하러 가기'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  Widget choiceDogModal(w, h, context) {
    final size = MediaQuery.of(context).size;

    return Opacity(
      opacity: 0.7,
      child: Container(
          decoration: const BoxDecoration(color: Colors.grey),
          height: h * 0.6,
          width: w,
          child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 250,
                width: w * 0.9,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: StreamBuilder(
                  stream: petsRef.orderBy('createdAt').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    // 불러온 데이터가 없을 경우 등록 안내
                    if (snapshot.data!.docs.length == 0) {
                      return Padding(
                        padding:
                            EdgeInsets.fromLTRB(0, size.height * 0.3, 0, 0),
                        child: Text('댕댕이를 등록해주세요!'),
                      );
                    }
                    return Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            CarouselSlider.builder(
                              options: CarouselOptions(
                                enlargeCenterPage: true,
                                viewportFraction: 0.5,
                                autoPlay: false,
                                enableInfiniteScroll: false,
                              ),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, itemIndex, pageViewIndex) {
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (!flag) {
                                          var temp = List<bool>.filled(
                                              snapshot.data!.docs.length,
                                              false);
                                          walkController.makeFlagList(temp);
                                          flag = true;
                                        }
                                        walkController.setFlagList(itemIndex);
                                        setState(() {});
                                      },
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: size.width * 0.2,
                                            child: ClipOval(
                                                child: CachedNetworkImage(
                                              imageUrl: snapshot
                                                  .data!.docs[itemIndex]
                                                  .get('imageUrl'),
                                            )),
                                          ),
                                          if (walkController
                                              .flagList.isNotEmpty)
                                            walkController.choiceDog(
                                                itemIndex, size.width),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        "${snapshot.data!.docs[itemIndex].get('name')}",
                                        style: TextStyle(fontSize: 20)),
                                  ],
                                );
                              },
                            ),
                            Container(
                              height: 220,
                              width: 300,
                              // color: Colors.red,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                    onPressed: () {
                                      walkController.selDogs.clear();
                                      for (int i = 0;
                                          i < walkController.flagList.length;
                                          i++) {
                                        if (walkController.flagList[i]) {
                                          walkController.selDogs.add(snapshot
                                              .data!.docs[i]
                                              .get('name'));
                                        }
                                      }
                                      walkController.isSelected.value = true;
                                      walkController.dropdownValue =
                                          walkController.selDogs.first;
                                      // print(walkController.selDogs);
                                      petsRef
                                          .where('name',
                                              isEqualTo:
                                                  walkController.dropdownValue)
                                          .get()
                                          .then((data) {
                                        setState(() {
                                          walkController.selUrl.value =
                                              data.docs[0]['imageUrl'];
                                        });
                                      });
                                    },
                                    child: Text("선택")),
                              ),
                            )
                          ],
                        )
                      ],
                    );
                  },
                ),
              ))),
    );
  }

  Widget walkTimeModal(w, h, context) {
    walkController.recommend();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0.8,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                height: h * 0.6,
                width: w,
              ),
            ),
            Container(
              height: 170,
              width: w * 0.8,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("권장 산책 시간 : ", style: TextStyle(fontSize: 20)),
                      Text('${walkController.rectime} 분',
                          style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: TextField(
                            onChanged: (text) {
                              walkController.tmp_goal.value = int.parse(text);
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: '목표 산책 시간',
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            walkController.goal.value =
                                walkController.tmp_goal.value;
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: violet2),
                          child: Text("입력"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget endWalkModal(w, h, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.8,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              height: h * 0.6,
              width: w,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 100,
              width: w * 0.8,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('산책하기를 종료합니다'),
                  const Text('산책 거리가 짧으면 기록되지 않습니다.'),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: w * 0.4,
                        // decoration: BoxDecoration(color: Colors.red),
                        child: Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30)),
                            child: Text(
                              '산책 계속하기',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            onPressed: () {
                              walkController.updateWalkingState();
                              walkController.startTimer();
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: w * 0.4,
                        // decoration: BoxDecoration(color: Colors.blue),
                        child: Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            child: const Text(
                              '종료',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              walkController.endTime = Timestamp.now();
                              walkController.sendDB();
                              // 캘린더 화면으로
                              mainController.changeTabIndex(2);
                              // 캘린더 상세화면으로 이동해야함
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: const LogoWidget(),
      ),
      body: Obx(
            () => Column(
          children: [
            const Status(),
            const SizedBox(height: 10),
            walkController.isBleConnect.value == false
                ? requestBluetoothConnectWidget(
                    screenWidth, screenHeight, context)
                : Stack(
                    children: [
                      mapAreaWidget(screenWidth, screenHeight),
                      walkController.isSelected.value == false
                          ? choiceDogModal(screenWidth, screenHeight, context)
                          : walkController.goal.value == 0
                              ? walkTimeModal(
                                  screenWidth, screenHeight, context)
                              : (walkController.isRunning.value ==
                                      walkController.isStart)
                                  ? Container()
                                  : endWalkModal(
                                      screenWidth, screenHeight, context),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
