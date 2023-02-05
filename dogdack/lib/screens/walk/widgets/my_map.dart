import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/screens/walk/walk_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as d;
import '../../../models/position_data.dart';
import '../../../models/walk_data.dart';

class Map extends StatefulWidget {
  late final String title;

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController _controller;

  // 이 값은 지도가 시작될 때 첫 번째 위치입니다.
  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(37.5012428, 127.0395859),
    zoom: 17,
  );

  // 지도 클릭 시 표시할 장소에 대한 마커 목록
  final List<Marker> markers = [];

  final Set<Polyline> _polylines = {};
  List<LatLng> latlng = [];

  final d.Distance distance = const d.Distance();
  late LatLng temp;
  double? total = 0;

  // 타이머 변수
  late Timer _timer;
  int _timeCount = 0;
  bool _isRunning = false;

  // List<String> _lapTimeList = [];

  addMarker(cordinate) {
    int id = Random().nextInt(100);

    setState(() {
      markers
          .add(Marker(position: cordinate, markerId: MarkerId(id.toString())));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          zoomControlsEnabled: false,
          initialCameraPosition: _initialPosition,
          mapType: MapType.normal,
          onMapCreated: (controller) {
            setState(() {
              _controller = controller;
            });
          },
          markers: markers.toSet(),

          // 클릭한 위치가 중앙에 표시
          onTap: (cordinate) {
            _controller.animateCamera(CameraUpdate.newLatLng(cordinate));
            addMarker(cordinate);

            FirebaseFirestore.instance
                .collection(
                    '${FirebaseAuth.instance.currentUser!.email}_position')
                .withConverter(
                  fromFirestore: (snapshot, options) =>
                      PosData.fromJson(snapshot.data()!),
                  toFirestore: (value, options) => value.toJson(),
                )
                .add(PosData(
                  timestamp: Timestamp.now(),
                  lat: cordinate.latitude.toString(),
                  lng: cordinate.longitude.toString(),
                ));

            // getDist(distance, temp, cordinate, markers, total);

            // 좌표간 거리 계산
            if (markers.length == 1) {
              temp = LatLng(cordinate.latitude, cordinate.longitude);
            } else {
              total = total! +
                  distance(d.LatLng(temp.latitude, temp.longitude),
                      d.LatLng(cordinate.latitude, cordinate.longitude));

              temp = LatLng(cordinate.latitude, cordinate.longitude);
            }

            latlng.add(LatLng(double.parse(cordinate.latitude.toString()),
                double.parse(cordinate.longitude.toString())));

            // 폴리라인
            _polylines.add(Polyline(
              polylineId: PolylineId(cordinate.toString()),
              visible: true,
              points: latlng,
              color: Colors.blue,
            ));
          },
          polylines: _polylines,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              size.height * 0.01, size.height * 0.53, size.height * 0.01, 0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.purple, width: 3.0)),
            child: Container(
                height: size.height * 0.1,
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment(
                        Alignment.center.x,
                        Alignment.center.y,
                      ),
                      child: OutlineCircleButton(
                          radius: 50.0,
                          borderSize: 5.0,
                          onTap: () async {
                            _clickPlayButton();
                          },
                          child: _isRunning
                              ? const Icon(Icons.pause, color: Colors.purple)
                              : const Icon(Icons.play_arrow,
                                  color: Colors.purple)),
                    ),
                    Align(
                      alignment: Alignment(
                        Alignment.centerLeft.x + size.width * 0.0005,
                        Alignment.center.y,
                      ),
                      child: Text(
                        '${_timeCount ~/ 360000} : ${_timeCount ~/ 6000} : ${(_timeCount % 6000) ~/ 100}',
                        // (_timeCount ~/ 100).toString() + ' 초',
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                    Align(
                      alignment: Alignment(
                        Alignment.centerRight.x - size.width * 0.0005,
                        Alignment.center.y,
                      ),
                      child: Text(
                        '$total m',
                        // 'data',
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ],
                )),
          ),
        )
      ]),
      floatingActionButton: Stack(
        children: <Widget>[
          // 초기화 버튼
          Align(
            alignment: Alignment(
                Alignment.topLeft.x + 0.13, Alignment.topLeft.y + 0.1),
            child: FloatingActionButton(
              heroTag: "1",
              onPressed: () {
                markers.clear();
                latlng.clear();
                FirebaseFirestore.instance
                    .collection(
                        '${FirebaseAuth.instance.currentUser!.email}_position')
                    .get()
                    .then((snapshot) {
                  for (DocumentSnapshot ds in snapshot.docs) {
                    ds.reference.delete();
                  }
                });
                // _controller.animateCamera(CameraUpdate.zoomOut());
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WalkPage(tabIndex: 2)));
                });
              },
              tooltip: '초기화',
              child: const Icon(Icons.refresh),
            ),
          ),

          // DB 데이터로 좌표 찍기
          Align(
            alignment: Alignment(
                Alignment.topLeft.x + 0.13, Alignment.topLeft.y + 0.4),
            child: FloatingActionButton(
              heroTag: "2",
              onPressed: () async {
                total = 0;
                await for (var snapshot in FirebaseFirestore.instance
                    .collection(
                        '${FirebaseAuth.instance.currentUser!.email}_position_test')
                    .orderBy('Timestamp', descending: true)
                    .snapshots()) {
                  for (var messege in snapshot.docs) {
                    addMarker(LatLng(double.parse(messege.data()['lat']),
                        double.parse(messege.data()['lng'])));

                    if (markers.length == 1) {
                      temp = LatLng(double.parse(messege.data()['lat']),
                          double.parse(messege.data()['lng']));
                    } else {
                      total = total! +
                          distance(
                              d.LatLng(temp.latitude, temp.longitude),
                              d.LatLng(double.parse(messege.data()['lat']),
                                  double.parse(messege.data()['lng'])));
                      temp = LatLng(double.parse(messege.data()['lat']),
                          double.parse(messege.data()['lng']));
                    }

                    latlng.add(LatLng(double.parse(messege.data()['lat']),
                        double.parse(messege.data()['lng'])));

                    _polylines.add(Polyline(
                      polylineId: PolylineId(messege.data().toString()),
                      visible: true,
                      points: latlng,
                      color: Colors.blue,
                    ));
                  }
                }
              },
              tooltip: '좌표 찍기',
              child: const Icon(Icons.access_time_filled),
            ),
          ),

          // 이동거리, 시간 DB 저장 버튼
          Align(
            alignment: Alignment(
                Alignment.topLeft.x + 0.13, Alignment.topLeft.y + 0.7),
            child: FloatingActionButton(
              heroTag: "3",
              onPressed: () => setState(() {
                FirebaseFirestore.instance
                    .collection(
                        '${FirebaseAuth.instance.currentUser!.email}_walk')
                    .withConverter(
                      fromFirestore: (snapshot, options) =>
                          WalkData.fromJson(snapshot.data()!),
                      toFirestore: (value, options) => value.toJson(),
                    )
                    .add(WalkData(
                      distance: total?.toInt(),
                      time: (_timeCount ~/ 100).toString(),
                    ));
              }),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _timeCount++;
      });
    });
  }

  void _pause() {
    _timer.cancel();
  }

  void _clickPlayButton() {
    _isRunning = !_isRunning;

    if (_isRunning) {
      _start();
    } else {
      _pause();
    }
  }
}

class OutlineCircleButton extends StatelessWidget {
  const OutlineCircleButton({
    Key? key,
    this.onTap,
    this.borderSize = 0.5,
    this.radius = 20.0,
    this.borderColor = Colors.purple,
    this.foregroundColor = Colors.white,
    this.child,
  }) : super(key: key);

  final onTap;
  final radius;
  final borderSize;
  final borderColor;
  final foregroundColor;
  final child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: borderSize),
          color: foregroundColor,
          shape: BoxShape.circle,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              child: child ?? const SizedBox(),
              onTap: () async {
                if (onTap != null) {
                  onTap();
                }
              }),
        ),
      ),
    );
  }
}
