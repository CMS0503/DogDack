import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/models/walk_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/dog_data.dart';

class WalkController extends GetxController {
  // 블루투스 장치 id
  final String serviceUuid = '0000ffe0-0000-1000-8000-00805f9b34fb';
  final String characteristicUuid = '0000ffe1-0000-1000-8000-00805f9b34fb';

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
  Timer? timer;
  RxInt timeCount = 0.obs;
  RxDouble totalDistance = 0.0.obs;
  List<LatLng> latlng = [];

  List<GeoPoint>? geolist = [];
  Timestamp? startTime;
  Timestamp? endTime;
  double? distance = 0.0;
  int light = 0;

  // 강아지 정보
  QuerySnapshot? _docInPets;
  List<DogData>? petList;
  String name = "asd";
  String? imgUrl;

  @override
  void onInit() {
    getData();
    // LCD 타이머
    ever(timeCount, (_) {
      if ((timeCount % 6000) % 100 == 0) {
        sendData(
            '${timeCount ~/ 360000}:${timeCount ~/ 6000}:${(timeCount % 6000) ~/ 100}, ${distance!.toInt()}m');
      }
    });
  }

  void getData() async {
    final petsRef = FirebaseFirestore.instance
        .collection(
            'Users/${FirebaseAuth.instance.currentUser!.email.toString()}/Pets')
        .withConverter(
            fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!),
            toFirestore: (dogData, _) => dogData.toJson());

    CollectionReference petRef = FirebaseFirestore.instance.collection(
        'Users/${FirebaseAuth.instance.currentUser!.email.toString()}/Pets');

    QuerySnapshot _docInPets = await petRef.get();

    name = (await petsRef.doc(_docInPets.docs.first.id.toString()).get())
        .data()!
        .name!;
    imgUrl = (await petsRef.doc(_docInPets.docs.first.id.toString()).get())
        .data()!
        .imageUrl!;
  }

  void addData(lat, lng) {
    geolist?.add(GeoPoint(lat, lng));
    update();
  }

  void sendDB() {
    print("-----------send to DB-------------");
    // geolist?.add(GeoPoint(23.412, 125.234125));
    // geolist?.add(GeoPoint(42.213, 142.234125));

    FirebaseFirestore.instance.collection('Users/${FirebaseAuth.instance.currentUser!.email}/Walk')
        .withConverter(
          fromFirestore: (snapshot, options) => WalkData.fromJson(snapshot.data()!),
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
          // goal: ,
        ));
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
      Future.delayed(Duration(seconds: 1));
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

  void initLCD() async {
    await sendData('01085382550a');
    await sendData('0:0:0, 0m');
  }

  void clickLedBtn() async {
    await sendData('${light}');
  }

  Future<void> sendData(data) async {
    // print('try sendData');
    for (BluetoothService service in services!) {
      if (service.uuid.toString() == serviceUuid) {
        // print('find service ok');
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.uuid.toString() == characteristicUuid) {
            // print('find chara ok');
            await characteristic.write(utf8.encode(data),
                withoutResponse: true);
            print('Send Data: ${data.toString()}');
          }
        }
      }
    }
  }
}
