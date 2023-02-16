import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/input_controller.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:dogdack/models/walk_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';

import '../../../../controllers/cal_walk_controller.dart';
import '../../../../controllers/mypage_controller.dart';
import '../../../../controllers/walk_controller.dart';
import '../../../../models/dog_data.dart';

class CalWalkCardWidget extends StatefulWidget {
  String place;
  String distance;
  String totalTimeMin;
  String imageUrl;

  var geodata;
  // num distdata = 0;
  var placedata;

  // num timedata = 0;

  CalWalkCardWidget(
      {super.key,
      required this.place,
      required this.distance,
      required this.totalTimeMin,
      required this.imageUrl});

  @override
  State<CalWalkCardWidget> createState() => _CalWalkCardWidget();
}

class _CalWalkCardWidget extends State<CalWalkCardWidget> {
  Color grey = const Color.fromARGB(255, 80, 78, 91);
  Color violet = const Color.fromARGB(255, 100, 92, 170);
  Color violet2 = const Color.fromARGB(255, 160, 132, 202);
  Color violet3 = const Color.fromARGB(255, 191, 172, 224);

  final Set<Polyline> _polyline = {};

  // List<LatLng> latlng = [];

  late CollectionReference<DogData> petsRef;

  final Completer<GoogleMapController> _controller = Completer();
  final walkController = Get.put(WalkController());
  final inputController = Get.put(InputController());
  final userController = Get.put(UserController());
  final petController = Get.put(PetController());
  final calController = Get.put(CalendarWorkController());

  late CollectionReference<WalkData> walkRef;
  late DateTime selectedDay;
  late Timestamp startOfToday;
  late Timestamp endOfToday;
  late String docId;

  Future<void> addPloy(data) async {
    for (int i = 0; i < data.length; i++) {
      calController.latlng.add(LatLng(data[i].latitude, data[i].longitude));
    }

    if (calController.latlng.length > 1) {
      GoogleMapController googleMapController = await _controller.future;
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 17,
            target: LatLng(
                calController.latlng[calController.latlng.length ~/ 2].latitude,
                calController
                    .latlng[calController.latlng.length ~/ 2].longitude),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    calController.latlng.clear();
    docId = inputController.dognames[inputController.selectedValue.toString()];
    walkRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets/${docId}/Walk')
        .withConverter(
        fromFirestore: (snapshot, _) => WalkData.fromJson(snapshot.data()!),
        toFirestore: (walkData, _) => walkData.toJson());

    selectedDay = inputController.date;
    startOfToday = Timestamp.fromDate(selectedDay);
    endOfToday = Timestamp.fromDate(selectedDay.add(const Duration(days: 1)));

    return Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 4.0,
          child: SizedBox(
            width: width * 0.9,
            height: height * 0.5,
            child: StreamBuilder(
              stream: walkRef.orderBy("startTime", descending: true).snapshots(),
              builder: (context, snapshot) {
                // 데이터를 아직 불러오지 못했으면 로딩
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                //초기화
                calController.latlng.clear();
                calController.timeData = 0;
                calController.distData = 0;

                var timeZoneOffset = DateTime.now().timeZoneOffset.inMilliseconds;
                int start = (startOfToday.millisecondsSinceEpoch) ~/ 1000;
                int end = (endOfToday.millisecondsSinceEpoch) ~/ 1000;

                bool walkSearchOneTimeFlag = false;
                for(int walkDocIdx = 0; walkDocIdx < snapshot.data!.docs.length; walkDocIdx++) {
                  int docTime = (snapshot.data!.docs[walkDocIdx].get('startTime').millisecondsSinceEpoch + timeZoneOffset) ~/ 1000;
                  if(docTime >= start && docTime < end) {
                    if(!walkSearchOneTimeFlag) {
                      walkController.walkStartTime = snapshot.data!.docs[walkDocIdx].get('startTime');
                      walkController.walkEndTime = snapshot.data!.docs[walkDocIdx].get('endTime');
                      widget.geodata = snapshot.data!.docs[walkDocIdx].get('geolist');
                      widget.placedata = snapshot.data!.docs[walkDocIdx].get('place');
                      walkSearchOneTimeFlag = true;
                    }

                    calController.timeData += snapshot.data!.docs[walkDocIdx].get('totalTimeMin');
                    calController.distData += snapshot.data!.docs[walkDocIdx].get('distance');
                  }
                }

                addPloy(widget.geodata).then((value) => calController.updateState());

                return GetBuilder<CalendarWorkController>(builder: (_) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: width * 0.7,
                          height: height * 0.3,
                          margin: const EdgeInsets.all(20),
                          decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
                          child: calController.latlng.isEmpty
                              ? Image.asset("assets/logo.png")
                              : GoogleMap(
                            gestureRecognizers: Set()
                              ..add(Factory<PanGestureRecognizer>(
                                      () => PanGestureRecognizer())),
                            initialCameraPosition: const CameraPosition(
                              target: LatLng(37.5012428, 127.039585),
                              zoom: 15,
                            ),
                            onMapCreated: (mapController) {
                                  if (_controller.isCompleted == false) {
                                    _controller.complete(mapController);
                                  }
                                },
                            polylines: _polyline,
                          ),
                        ),
                      ),
                      // 산책 정보
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: [
                                Icon(
                                  Icons.place,
                                  color: violet,
                                  size: 50,
                                ),
                                Text(widget.placedata.toString())
                              ],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.directions_walk,
                                  color: violet2,
                                  size: 50,
                                ),
                                Text("${calController.distData.toString()}미터")
                              ],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.timelapse,
                                  color: violet3,
                                  size: 50,
                                ),
                                Text("${calController.timeData.toString()}분")
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                });
              },
            ),
          ),
        ),
    );
  }
}
