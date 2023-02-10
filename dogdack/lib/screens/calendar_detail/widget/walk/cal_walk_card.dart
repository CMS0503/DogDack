import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/input_controller.dart';
import 'package:dogdack/screens/calendar_detail/widget/walk/cal_walk_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

import '../../../../controllers/walk_controller.dart';

class CalWalkCardWidget extends StatefulWidget {
  String place;
  String distance;
  String totalTimeMin;
  String imageUrl;

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
  var data;
  final Completer<GoogleMapController> _controller = Completer();
  final walkController = Get.put(WalkController());
  final inputController = Get.put(InputController());

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
      walkController.abv();
    });
  }

  Future<void> setPoly() async {
    latlng.clear();
    String docId = inputController.selected_id;
    // String docId = "";
/////////////////////////수정한 부분//////////////////////////////////////
    CollectionReference petRef = FirebaseFirestore.instance
        .collection('Users/${'imcsh313@naver.com'}/Pets/$docId/Walk');


    ////////////////////원래 송빈님 코드////////////////////////////////////////////////////
    // // ★★★ 현재 강아지 walkController.curName  ->  walkController 가서 수정할것
    // final petDoc = petRef.where("name", isEqualTo: walkController.curName);
    //
    //   // print('${walkController.curName}의 문서 id : $docId');
    //
    //   // 산책한 강아지의 AutoId의 Walk 컬렉션
    //   final firestore = FirebaseFirestore.instance
    //       .collection('Users/${'imcsh313@naver.com'}/Pets/$docId/Walk');


      await petRef.get().then((value) async {
      // 달력에서 선택한 날짜
      var selectedDay = inputController.date;
      var startOfToday = Timestamp.fromDate(selectedDay);
      var endOfToday =
          Timestamp.fromDate(selectedDay.add(const Duration(days: 1)));
      // var startOfToday = Timestamp.fromDate(selectedDay.subtract(Duration(hours: selectedDay.hour, minutes: selectedDay.minute, seconds: selectedDay.second, milliseconds: selectedDay.millisecond, microseconds: selectedDay.microsecond)));
      // var endOfToday = Timestamp.fromDate(selectedDay.subtract(Duration(hours: selectedDay.hour, minutes: selectedDay.minute, seconds: selectedDay.second, milliseconds: selectedDay.millisecond, microseconds: selectedDay.microsecond)));

      // 선택한 날짜의 산책 데이터를 내림차순 정렬(최신 데이터가 위로 오게)
      await petRef.where("startTime",
              isGreaterThanOrEqualTo: startOfToday, isLessThan: endOfToday)
          .orderBy("startTime", descending: true)
          .get()
          .then((QuerySnapshot snapshot) async {
        data = snapshot.docs[0]['geolist'];

        addPloy(data);
      });
    });

    // var documentSnapshot = await FirebaseFirestore.instance.collection('Users/${'imcsh313@naver.com'}/Walk')
    //     // .doc('${DateTime.now().year}_${DateTime.now().month}_${DateTime.now().day}')
    //     .doc('2023_2_7')
    //     .get();
    // // var documentSnapshot = await FirebaseFirestore.instance
    // //     .collection('Users/${'imcsh313@naver.com'}/Walk')
    // //     .where('startTime', isEqualTo: )
    //
    // var data = await documentSnapshot.data()!['geolist'];
    // for (int i = 0; i < data.length; i++) {
    //   latlng.add(LatLng(data[i].latitude, data[i].longitude));
    // }
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
                  // child: Image.asset("${widget.imageUrl}")
                  child: Stack(
                    children: [
                      GetBuilder<WalkController>(builder: (_) {
                        return GoogleMap(
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
                  )),

              // 산책 정보
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  children: <Widget>[
                    Flexible(
                        child: CalDetailTextWidget(
                      title: "산책 장소",
                      text: widget.place,
                    )),
                    Flexible(
                        child: CalDetailTextWidget(
                            title: "이동 거리", text: "${widget.distance}미터")),
                    Flexible(
                        child: CalDetailTextWidget(
                            title: "산책 시간", text: "${widget.totalTimeMin}분")),
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
