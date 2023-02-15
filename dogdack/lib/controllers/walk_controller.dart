import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:dogdack/models/user_data.dart';
import 'package:dogdack/models/walk_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/dog_data.dart';

import 'package:dogdack/controllers/input_controller.dart';
import 'package:intl/intl.dart';
import 'package:dogdack/models/calender_data.dart';

class WalkController extends GetxController {
  // 블루투스 장치 id
  final String serviceUUID = '0000ffe0-0000-1000-8000-00805f9b34fb';
  final String characteristicUUID = '0000ffe1-0000-1000-8000-00805f9b34fb';

  final userController = Get.put(UserController());

  RxBool isBleConnect = false.obs;

  // 위도, 경도
  RxDouble latitude = 37.500735.obs;
  RxDouble longitude = 127.036845.obs;

  // getter
  double get lat => latitude.value.toDouble();

  double get lon => longitude.value.toDouble();

  // 블루투스 디바이스 정보
  BluetoothDevice? _device;
  List<BluetoothService>? services;

  BluetoothDevice? get device => _device;

  // 산책 정보
  bool isStart = false;
  RxBool isRunning = false.obs;
  RxBool isDogSelected = false.obs;
  Timer? timer;
  RxInt timeCount = 0.obs;

  RxDouble totalDistance = 0.0.obs;

  List<LatLng> latlng = [];

  List<GeoPoint>? geolist = [];
  List<String> petList = [];
  Timestamp? startTime;
  Timestamp? endTime;

  // double? distance = 0.0;
  int light = 0;

  // 강아지 정보
  QuerySnapshot? _docInPets;
  String name = "asd";
  String? imgUrl;

  int rectime = 0;
  RxInt goal = 0.obs;
  RxInt tmp_goal = 0.obs;
  RxInt curGoal = 0.obs;
  String curName = "";

  // ---강아지 선택 modal---
  RxList flagList = [].obs;
  List selDogs = [];
  RxBool isSelected = false.obs;
  RxString selUrl = "".obs;

  void makeFlagList(List temp) {
    flagList.value = temp;
    update();
  }

  void setFlagList(int index) {
    flagList[index] = !flagList[index];
    update();
  }

  Widget choiceDog(int itemIndex, double size) {
    return
      flagList[itemIndex]?
      Container(
        // color: Colors.red,
        height: size * 0.4,
        child: Align(
          alignment: Alignment.bottomRight,
            child:
          CircleAvatar(
            backgroundImage: const ExactAssetImage('assets/dogdack.png') ,
            backgroundColor: Colors.transparent,
            // backgroundColor: ,
            radius: size * 0.12,

          ),
        ),
      ):Container();
  }

  // ----------------------

  // 산책화면 강아지 dropdown
  String dropdownValue = "";

  // ---------------------

  // LCD data
  String? phoneNumber;
  String? walkTimer;
  String dist = '0';
  String ledSig = '1';

  void getList() async {
    String temp = "";
    await for (var snapshot in FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets')
        .snapshots()) {
      for (var messege in snapshot.docs) {
        temp = messege.data()['name'];
        petList.add(temp);
      }
      // print(petList);
    }
  }

  int getCur() {
    if ((timeCount.value) == 0) {
      curGoal.value = 0;
    } else {
      curGoal.value =
          (((timeCount.value) / (goal.value * 60)) * 100).round();
    }
    return curGoal.value;
  }

  void recommend() async {
    int temp = 0;
    rectime = 0;

    CollectionReference<DogData> petsRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets')
        .withConverter(
        fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!),
        toFirestore: (dogData, _) => dogData.toJson());

    print('selDogs : $selDogs');
    for(int i = 0; i < selDogs.length; i++) {
      petsRef.where('name', isEqualTo: selDogs[i]).get().then((value) {
        temp = value.docs[0].get('recommend');
        rectime = rectime + temp;
        print('rectime : $rectime');
      });
    }
    update();
  }

  @override
  void onInit() {
    getData();
    // LCD 타이머

    ever(timeCount, (_) {
      // 1초마다 보냄
      String pn = phoneNumber!;
      String timer =
          '${timeCount ~/ 3600}:${timeCount ~/ 60}:${timeCount % 60}';
      String dist = '${totalDistance!.toInt()}';
      String isLed = ledSig;

      Data data = Data(pn, timer, dist, isLed);
      sendDataToArduino(data);
    });
  }

  void getData() async {
    final petsRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets')
        .withConverter(
            fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!),
            toFirestore: (dogData, _) => dogData.toJson());

    // Firebase : 유저 전화 번호 저장을 위한 참조 값
    final userRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/UserInfo')
        .withConverter(
            fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!),
            toFirestore: (userData, _) => userData.toJson());

    CollectionReference petRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets');

    QuerySnapshot _docInPets = await petRef.get();

    // name = (await petsRef.doc(_docInPets.docs.first.id.toString()).get())
    //     .data()!
    //     .name!;
    // imgUrl = (await petsRef.doc(_docInPets.docs.first.id.toString()).get())
    //     .data()!
    //     .imageUrl!;

    // phoneNumber = (await userRef.doc('number').get()).data()!.phoneNumber;
    phoneNumber = "01085382550";
  }

  void addData(List<LatLng> latlng) {
    for(int i = 0; i < latlng.length; i++){
      geolist?.add(GeoPoint(latlng[i].latitude, latlng[i].longitude));
    }
    update();
  }

  Future<void> sendDB() async {
    final inputController = Get.put(InputController());
    print("-----------send to DB-------------");
    // geolist?.add(GeoPoint(23.412, 125.234125));
    // geolist?.add(GeoPoint(42.213, 142.234125));
    String docId = "";

    CollectionReference petRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets');

    selDogs.forEach((dogName) async {
      final petDoc = petRef.where("name", isEqualTo: dogName);
      await petDoc.get().then((value) async {
        docId = value.docs[0].id;
        // print('$curName의 문서 id : $docId');

        await FirebaseFirestore.instance
            .collection('Users/${userController.loginEmail}/Pets/$docId/Walk')
            .withConverter(
              fromFirestore: (snapshot, options) =>
                  WalkData.fromJson(snapshot.data()!),
              toFirestore: (value, options) => value.toJson(),
            )
            // .doc('${DateTime.now().year}_${DateTime.now().month}_${DateTime.now().day}')
            // .set(WalkData(
            .add(WalkData(
              geolist: geolist,
              startTime: startTime,
              endTime: endTime,
              totalTimeMin: timeCount.value ~/ 60,
              isAuto: true,
              // place: ,
              distance: totalDistance.toInt(),
              goal: goal.value,
            )).then((value) => disconnect());

        // calendar 저장
        petRef.doc(docId).collection('Calendar').doc(DateFormat('yyMMdd').format(inputController.date).toString())
            .withConverter(
              fromFirestore: (snapshot, options) =>
                  CalenderData.fromJson(snapshot.data()!),
              toFirestore: (value, options) => value.toJson(),
            )
            .set(CalenderData(
              isWalk: true,
              bath: false,
              beauty: false,
              // distance: controller.distance,
            ))
            .then((value) => print("document added"))
            .catchError((error) => print("Fail to add doc $error"));
      });
    });

  }

  void disconnect() {
    try {
      geolist = [];
      isSelected.value = false;
      goal.value = 0;
      isRunning.value = false;
      isStart = false;
      totalDistance.value = 0;
      timeCount.value = 0;
      rectime = 0;

      // 강아지 선택 초기화
      flagList.value = [];
      selDogs = [];
      isSelected.value = false;
      selUrl.value = "";
      dropdownValue = "";

      update();
    } catch (e) {
      print("disconnect error!!");
    }
  }

  void setCurrentLocation(curLatitude, curLongitude) {
    latitude.value = curLatitude.toDouble();
    longitude.value = curLongitude.toDouble();
    update();
  }

  void connectBle(device) {
    _device = device;
    isBleConnect.value = true;
    update();
  }

  void updateWalkingState() {
    // LCD 초기화
    if (isStart == false) {
      initLCD();
      Future.delayed(const Duration(seconds: 1));
    }

    isStart = true;
    if (timeCount.value == 0) startTime = Timestamp.now();
    isRunning.value = !isRunning.value;
    update();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeCount++;
    });
    update();
  }

  void pauseTimer() {
    timer!.cancel();
  }

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.onClose();
  }

  void updateState() {
    update();
  }

  void initLCD() async {
    Data data = Data('00000000000', '00:00:00', '0', "1");

    String json = jsonEncode(data);

    sendDataToArduino(json);
  }

  Future<void> sendDataToArduino(data) async {
    String json = jsonEncode(data) + '\n';

    for (BluetoothService service in services!) {
      if (service.uuid.toString() == serviceUUID) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.uuid.toString() == characteristicUUID) {
            await characteristic.write(utf8.encode(json),
                withoutResponse: true);
            print('Send Data: $json');
          }
        }
      }
    }
  }
}

class Data {
  final String phoneNumber;
  final String timer;
  final String distance;
  final String isLedOn;

  Data(
    this.phoneNumber,
    this.timer,
    this.distance,
    this.isLedOn,
  );

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
        'timer': timer,
        'distance': distance,
        'isLedOn': isLedOn,
      };
}
