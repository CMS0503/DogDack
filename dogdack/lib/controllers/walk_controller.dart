import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/models/walk_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WalkController extends GetxController {
  // 블루투스 장치 id
  final String serviceUUID = '0000ffe0-0000-1000-8000-00805f9b34fb';
  final String characteristicUUID = '0000ffe1-0000-1000-8000-00805f9b34fb';

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

  double? distance = 0.0;
  int rectime = 0;
  RxInt goal = 0.obs;
  RxInt tmp_goal = 0.obs;
  RxInt curGoal = 0.obs;
  String curName = "dog1";

  void getList() async {
    String temp = "";
    await for (var snapshot in FirebaseFirestore.instance
        .collection('Users/${'imcsh313@naver.com'}/Pets')
        .snapshots()) {
      for (var messege in snapshot.docs) {
        temp = messege.data()['name'];
        petList.add(temp);
      }
      print(petList);
    }
  }

  int getCur() {
    if ((timeCount.value ~/ 100) == 0) {
      curGoal.value = 0;
    } else {
      curGoal.value =
          (((timeCount.value ~/ 100) / (goal.value * 60)) * 100).round();
    }
    return curGoal.value;
  }

  void recommend() async {
    int cnt = 0;
    int temp = 0;
    int recTime = 0;
    await for (var snapshot in FirebaseFirestore.instance
        .collection('Users/${'imcsh313@naver.com'}/Pets')
        .snapshots()) {
      for (var messege in snapshot.docs) {
        cnt++;
        temp = messege.data()['recommend'];
        recTime = recTime + temp;
      }
      rectime = (recTime / cnt).round();
    }
  }

  @override
  void onInit() {
    ever(timeCount, (_) {
      if ((timeCount % 6000) % 100 == 0) {
        String pn = '01085382550';
        String timer =
            '${timeCount ~/ 360000}:${timeCount ~/ 6000}:${(timeCount % 6000) ~/ 100}';
        String dist = '${distance!.toInt()}m';
        String isLed = '0';

        Data data = Data(pn, timer, dist, isLed);
        sendDataToArduino(data);
      }
    });
  }

  void addData(lat, lng) {
    geolist?.add(GeoPoint(lat, lng));
    update();
  }

  void sendDB() {
    print("-----------send to DB-------------");
    // geolist?.add(GeoPoint(23.412, 125.234125));
    // geolist?.add(GeoPoint(42.213, 142.234125));
    String docId = "";

    CollectionReference petRef = FirebaseFirestore.instance
        .collection('Users/${'imcsh313@naver.com'}/Pets');

    final petDoc = petRef.where("name", isEqualTo: curName);
    petDoc.get().then((value) {
      docId = value.docs[0].id;
      // print('$curName의 문서 id : $docId');

      FirebaseFirestore.instance
          .collection('Users/${'imcsh313@naver.com'}/Pets/$docId/Walk')
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
            totalTimeMin: timeCount.value ~/ 6000,
            isAuto: true,
            // place: ,
            distance: distance,
            goal: goal.value,
          ));
    });
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
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
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

  void abv() {
    update();
  }

  void initLCD() async {
    Data data = Data('01085382550', '00:00:00', '123m', '0');

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
  final String isLedOn;
  final String distance;

  Data(this.phoneNumber, this.timer, this.isLedOn, this.distance);

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
        'timer': timer,
        'distance': distance,
        'isLedOn': isLedOn,
      };
}