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

  // 영우가 쓰는 변수
  Timestamp  walkStartTime = Timestamp.now();
  Timestamp  walkEndTime = Timestamp.now();

  void makeFlagList(List temp) {
    flagList.value = temp;
    update();
  }

  void setFlagList(int index) {
    flagList[index] = !flagList[index];
    update();
  }

  Widget choiceDog(int itemIndex, Size size) {
    return
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          // color: Colors.yellow,
          height: size.height * 0.2,
          width: size.width * 0.28,
          child:
          Align(
              alignment: Alignment.bottomRight,
              child:
              flagList[itemIndex]
              ? Image.asset("assets/dogdack.png")
              : Container()
          )
        )
      );


        // CircleAvatar(
        //   backgroundImage: const ExactAssetImage('assets/dogdack.png') ,
        //   backgroundColor: Colors.transparent,
        //   // backgroundColor: ,
        //   radius: size * 0.12,
        // ),
      // ):Container(
      //   color: Colors.red,
      // );
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

    // print('selDogs : $selDogs');
    for(int i = 0; i < selDogs.length; i++) {
      petsRef.where('name', isEqualTo: selDogs[i]).get().then((value) {
        temp = value.docs[0].get('recommend');
        rectime = rectime + temp;
        // print('rectime : $rectime');
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
      String dist = '${totalDistance.toInt()}';
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

    // phoneNumber = (await userRef.doc('number').get()).data()!.phoneNumber;
    phoneNumber = "01085382550";
  }

  Future<void> addData(List<LatLng> latlng) async {
    for (int i = 0; i < latlng.length; i++) {
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
      // 강아지 document 불러오기
      final petDoc = petRef.where("name", isEqualTo: dogName);
      // 산책 했는지 controller 시간으로 확인
      final walkCheck = (int.parse(inputController.endTime.seconds.toString()) -
            int.parse(inputController.startTime.seconds.toString())) /

        60 + (int.parse(inputController.endTime.seconds.toString()) -

            int.parse(inputController.startTime.seconds.toString())) % 60;

      // 강아지 문서 비동기
      await petDoc.get().then((value) async {
        // 해당 강아지 아이디 가져오기
        docId = value.docs[0].id;
        
        // 산책 collection에 정보 입력하기
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
              place: '장소',
              distance: totalDistance.toInt(),
              goal: goal.value,
            )).then((value) => disconnect());

        // Calendar 해당하는 날짜 ref
        petRef.doc(docId).collection('Calendar').doc(DateFormat('yyMMdd').format(inputController.date).toString()).get().then((value) {
          // 해당 날짜의 문서가 있으면
          if(value.exists) {
            // 문서의 isWalk 값이 이미 true 이거나 산책
          //   if (value['bath'] == true){
          //     print('여기서 input Controller가 어떨까${inputController.walkCheck}');
          //     inputController.walkCheck = true;
          //     print('여기서는 input Controller가 어떨까${inputController.walkCheck}');
          // } else {
          //   inputController.walkCheck = false;
          // }
          // if (value['beauty'] == true) {
          //   inputController.bath = true;
          // }
          // 
          petRef.doc(docId).collection('Calendar').doc(DateFormat('yyMMdd').format(inputController.date).toString())
          .withConverter(
            fromFirestore: (snapshot, options) =>
                CalenderData.fromJson(snapshot.data()!),
            toFirestore: (value, options) => value.toJson(),
          )
          // 해당 문서 정보 update 하기
            .update({
            'isWalk': true,
          })
          .then((value) => print("document added"))
          .catchError((error) => print("Fail to add doc $error"));
          } else {
            // 문서가 없으면 입력하기
            petRef.doc(docId).collection('Calendar').doc(DateFormat('yyMMdd').format(inputController.date).toString())
            .withConverter(
              fromFirestore: (snapshot, options) =>
                  CalenderData.fromJson(snapshot.data()!),
              toFirestore: (value, options) => value.toJson(),
            ).set(
            CalenderData(
            diary: '',
            bath: false,
            beauty: false,
            isWalk: true,
            imageUrl: [],
            ))
            .then((value) => print("document added"))
            .catchError((error) => print("Fail to add doc $error"));
          }
        });
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
