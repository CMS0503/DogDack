import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/screens/calendar_detail/widget/walk/cal_walk_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CalWalkCardWidget extends StatefulWidget {
  String place;
  num distance;
  num totalTimeMin;
  String imageUrl;

  CalWalkCardWidget(
      {required this.place,
      required this.distance,
      required this.totalTimeMin,
      required this.imageUrl});

  @override
  State<CalWalkCardWidget> createState() => _CalWalkCardWidget();
}

class _CalWalkCardWidget extends State<CalWalkCardWidget> {
  Set<Polyline> _polyline = {};
  List<LatLng> latlng = [];
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();

    setPoly().then((result) {
      setState(() {});
    });

    _polyline.add(
      Polyline(
          polylineId: PolylineId('1'),
          points: latlng,
          width: 3,
          color: Colors.blue
      ),
    );
  }

  Future<void> setPoly() async {
    latlng.clear();
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('Users/${FirebaseAuth.instance.currentUser!.email}/Walk')
        // .doc('${DateTime.now().year}_${DateTime.now().month}_${DateTime.now().day}')
        .doc('2023_2_7')
        .get();
    // var documentSnapshot = await FirebaseFirestore.instance
    //     .collection('Users/${FirebaseAuth.instance.currentUser!.email}/Walk')
    //     .where('startTime', isEqualTo: )

    var data = await documentSnapshot.data()!['geolist'];
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
        child: Container(
          width: width * 0.9,
          height: height * 0.25,
          child: Row(
            children: <Widget>[
              // 지도
              Container(
                  width: width * 0.45,
                  height: height * 0.2,
                  margin: EdgeInsets.all(20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
                  // child: Image.asset("${widget.imageUrl}")
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(37.5012428, 127.039585),
                          zoom: 15,
                        ),
                        onMapCreated: (mapController) {
                          _controller.complete(mapController);
                        },
                        polylines: _polyline,
                      ),
                    ],
                  )),

              // 산책 정보
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: Column(
                  children: <Widget>[
                    Flexible(
                        child: CalDetailTextWidget(
                      title: "산책 장소",
                      text: "${widget.place}",
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
