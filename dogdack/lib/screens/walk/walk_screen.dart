import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:dogdack/screens/calendar_main/calendar_main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/walk_controller.dart';
import '../../models/dog_data.dart';
import './widgets/my_map.dart';
import './widgets/status.dart';
import '../../commons/logo_widget.dart';
import '../../controllers/main_controll.dart';

class WalkPage extends StatefulWidget {
  const WalkPage({super.key});

  @override
  State<WalkPage> createState() => _WalkPageState();
}

class _WalkPageState extends State<WalkPage> {
  final walkController = Get.put(WalkController());
  final mainController = Get.put(MainController());
  final userController = Get.put(UserController());

  // final petController = Get.put(PetController());

  late CollectionReference<DogData> petsRef;

  bool flag = false;

  // List<bool> flagList = [];

  Color grey = const Color.fromARGB(255, 80, 78, 91);
  Color violet = const Color.fromARGB(255, 100, 92, 170);
  Color violet2 = const Color.fromARGB(255, 160, 132, 202);

  Widget mapAreaWidget(w, h) {
    return SizedBox(
      height: h * 0.67,
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.6,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              height: size.height * 0.62,
              width: size.width,
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Container(
                height: h * 0.26,
                width: w * 0.9,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: StreamBuilder(
                  stream: petsRef.orderBy('createdAt').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // 불러온 데이터가 없을 경우 등록 안내
                    if (snapshot.data!.docs.isEmpty) {
                      return Padding(
                        padding:
                            EdgeInsets.fromLTRB(0, size.height * 0.3, 0, 0),
                        child: const Text('댕댕이를 등록해주세요!'),
                      );
                    }
                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            CarouselSlider.builder(
                              options: CarouselOptions(
                                viewportFraction: 0.45,
                                autoPlay: false,
                                enableInfiniteScroll: false,
                              ),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, itemIndex, pageViewIndex) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 15,),
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
                                          Container(
                                            // color: Colors.red,
                                            height: size.height * 0.2,
                                              child: Column(
                                                children: [
                                                  Text(
                                                      "${snapshot.data!.docs[itemIndex].get('name')}",
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                      )),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  CircleAvatar(
                                                    radius: size.width * 0.13,
                                                    child: ClipOval(
                                                        child: CachedNetworkImage(
                                                        imageUrl: snapshot.data!.docs[itemIndex].get('imageUrl'),
                                                      )
                                                  ),
                                                ),
                                              ],
                                            )
                                          ),
                                          if (walkController
                                              .flagList.isNotEmpty)
                                            walkController.choiceDog(
                                                itemIndex, size.width),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Container(
                              // color: Colors.red,
                              height: size.height * 0.25,
                              width: size.width * 0.85,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor),
                                  onPressed: () {
                                    walkController.selDogs.clear();
                                    for (int i = 0;
                                        i < walkController.flagList.length;
                                        i++) {
                                      if (walkController.flagList[i]) {
                                        walkController.selDogs.add(
                                            snapshot.data!.docs[i].get('name'));
                                      }
                                    }
                                    if (walkController.selDogs.isEmpty) {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              title: const Text(
                                                  "함께할 강아지를 선택해주세요."),
                                              actions: <Widget>[
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.red),
                                                    child: const Text("확인"),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    } else {
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
                                    }
                                    walkController.recommend();
                                  },
                                  child: const Text("출발하기!"),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }

  Widget walkTimeModal(w, h, context) {
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
              height: h * 0.67,
              width: w,
            ),
          ),
          Container(
            height: h * 0.25,
            width: w * 0.8,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                const Text('목표 산책 시간을 입력하세요', style: TextStyle(fontSize: 20)),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                            walkController.tmp_goal.value = int.parse(text);
                          },

                          decoration: InputDecoration(
                            hintText:
                                '권장 산책 시간 : ${(walkController.rectime / walkController.selDogs.length).round()} 분',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 100, 92, 170))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 100, 92, 170))),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            // labelText: '목표 산책 시간',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {

                          if(walkController.tmp_goal.value == 0) {
                            walkController.goal.value = (walkController.rectime / walkController.selDogs.length).round();
                          } else {
                            walkController.goal.value = walkController.tmp_goal.value;
                          }
                        },
                        style:
                            ElevatedButton.styleFrom(backgroundColor: violet2),
                        child: const Text("입력"),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
              height: h * 0.67,
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
                      SizedBox(
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
                      SizedBox(
                        width: w * 0.4,
                        // decoration: BoxDecoration(color: Colors.blue),
                        child: Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            child: const Text(
                              '종료',
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                            onPressed: () {
                              walkController.endTime = Timestamp.now();
                              walkController.addData(walkController.latlng);

                              walkController.sendDB();
                              flag = false;

                              userController.myUpdate().then((value) {});
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
    petsRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets')
        .withConverter(
            fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!),
            toFirestore: (dogData, _) => dogData.toJson());

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.08),
          child: const LogoWidget(),
        ),
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
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
                              ? choiceDogModal(
                                  screenWidth, screenHeight, context)
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
        ),
      ),
    );
  }
}
