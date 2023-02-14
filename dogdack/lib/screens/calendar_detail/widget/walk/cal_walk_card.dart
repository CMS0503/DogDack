import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/input_controller.dart';
import 'package:dogdack/controllers/user_controller.dart';
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
                            text: "${widget.distdata.toString()}미터")),
                    Flexible(
                        child: CalDetailTextWidget(
                            title: "산책 시간",
                            text: "${widget.timedata.toString()}분")),
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
