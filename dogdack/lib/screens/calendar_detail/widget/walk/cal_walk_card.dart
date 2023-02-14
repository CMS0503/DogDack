import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/input_controller.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:dogdack/screens/calendar_detail/widget/walk/cal_walk_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';

import '../../../../controllers/walk_controller.dart';

class CalWalkCardWidget extends StatefulWidget {
  String place;
  String distance;
  String totalTimeMin;
  String imageUrl;

  var geodata;
  num distdata = 0;
  var placedata;
  num timedata = 0;

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
  final Set<Polyline> _polyline = {};
  List<LatLng> latlng = [];

  final Completer<GoogleMapController> _controller = Completer();
  final walkController = Get.put(WalkController());
  final inputController = Get.put(InputController());
  final userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();

    setPoly().then((result) {
      _polyline.add(
        Polyline(
            polylineId: const PolylineId('1'),
            points: latlng,
            width: 3,
            color: Colors.blue),
      );
      walkController.updateState();
    });
  }

  Future<void> setPoly() async {
    latlng.clear();
    String docId =
        inputController.dognames[inputController.selectedValue.toString()];
    print('docId : $docId');
    // walk 경로
    CollectionReference walkRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets/$docId/Walk');

    print('cal_walk_card 안 : ${userController.loginEmail}');

    await walkRef.get().then(
      (value) async {
        print('cal_walk_card 안 : ${userController.loginEmail}');
        // 달력에서 선택한 날짜
        var selectedDay = inputController.date;
        var startOfToday = Timestamp.fromDate(selectedDay);
        var endOfToday =
            Timestamp.fromDate(selectedDay.add(const Duration(days: 1)));

        // 선택한 날짜의 산책 데이터를 내림차순 정렬(최신 데이터가 위로 오게)
        await walkRef
            .where("startTime",
                isGreaterThanOrEqualTo: startOfToday, isLessThan: endOfToday)
            .orderBy("startTime", descending: true)
            .get()
            .then(
          (QuerySnapshot snapshot) async {
            print('cal_walk_card 안 snapshot: ${snapshot.docs}');
            widget.geodata = snapshot.docs[0]['geolist'];
            // 장소, 거리, 시간 데이터
            widget.placedata = snapshot.docs[0]['place'];

            for (var i = 0; i < snapshot.docs.length; i++) {
              widget.timedata += snapshot.docs[i]['totalTimeMin'];
              widget.distdata += snapshot.docs[i]['distance'];
            }
            addPloy(widget.geodata);
          },
        );
      },
    );

    setState(() {});
  }

  Future<void> addPloy(data) async {
    for (int i = 0; i < data.length; i++) {
      latlng.add(LatLng(data[i].latitude, data[i].longitude));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        child: SizedBox(
          width: width * 0.9,
          height: height * 0.25,
          child: Row(
            children: <Widget>[
              // 지도
              Container(
                width: width * 0.45,
                height: height * 0.2,
                margin: const EdgeInsets.all(20),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
                child: Stack(
                  children: [
                    GetBuilder<WalkController>(builder: (_) {
                      return GoogleMap(
                        gestureRecognizers: Set()
                          ..add(Factory<PanGestureRecognizer>(
                              () => PanGestureRecognizer())),
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(37.5012428, 127.039585),
                          zoom: 15,
                        ),
                        onMapCreated: (mapController) {
                          _controller.complete(mapController);
                        },
                        polylines: _polyline,
                      );
                    }),
                  ],
                ),
              ),

              // 산책 정보
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: CalDetailTextWidget(
                        title: "산책 장소",
                        text: widget.placedata,
                      ),
                    ),
                    Flexible(
                      child: CalDetailTextWidget(
                          title: "이동 거리",
                          text: "${widget.distdata.toString()}미터"),
                    ),
                    Flexible(
                      child: CalDetailTextWidget(
                          title: "산책 시간",
                          text: "${widget.timedata.toString()}분"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
