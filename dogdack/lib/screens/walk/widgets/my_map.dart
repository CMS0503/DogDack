import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/screens/walk/walk_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as d;

import '../../../models/walk_data.dart';
import '../controller/walk_controller.dart';

class myMap extends StatefulWidget {
  late final String title;
  late String receiveData = '';
  Map? location;

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<myMap> {
  // late GoogleMapController _controller;
  Completer<GoogleMapController> _controller = Completer();
  final walkController = Get.put(WalkController());

  late CameraPosition? _initialPosition;

  // 지도 클릭 시 표시할 장소에 대한 마커 목록
  final List<Marker> markers = [];

  final Set<Polyline> _polylines = {};
  List<LatLng> latlng = [];

  final d.Distance distance = d.Distance();
  late LatLng temp;
  double? total = 0;

  // 타이머 변수
  late Timer _timer;
  int _timeCount = 0;
  bool _isRunning = false;

  // List<String> _lapTimeList = [];

  addMarker(cordinate) {
    setState(() {
      markers.add(Marker(
          position: cordinate, markerId: MarkerId(cordinate.toString())));
    });
  }

  @override
  void initState() {
    print("init state map");
    // 이 값은 지도가 시작될 때 첫 번째 위치입니다.
    _initialPosition = CameraPosition(
      target: LatLng(walkController.lat, walkController.lon),
      zoom: 17,
    );
    updatePosition();
  }

  void updatePosition() async {
    GoogleMapController googleMapController = await _controller.future;
    for (BluetoothService service in walkController.services!) {
      if (service.uuid.toString() == walkController.serviceUuid) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.uuid.toString() ==
              walkController.characteristicUuid) {
            characteristic.setNotifyValue(true);
            characteristic.value.listen((value) {
              String stringValue = utf8.decode(value).toString();
              widget.receiveData += stringValue;
              // 한번 갱신 될 때마다
              if (stringValue.contains('}')) {
                widget.location = jsonDecode(widget.receiveData);
                walkController.setCurrentLocation(
                    widget.location!['lat'], widget.location!["lon"]);
                print(
                    'gps: ${widget.location!['lat']} ${widget.location!["lon"]}');
                print(
                    'walkController location: ${walkController.lat} ${walkController.lon}');
                widget.receiveData = '';

                googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      zoom: 17,
                      target: LatLng(
                        walkController.lat,
                        walkController.lon,
                      ),
                    ),
                  ),
                );
                latlng.add(LatLng(walkController.lat, walkController.lon));
                setState(() {});
              }
            });
          }
        }
      }
    }
  }

  // void getPolyPoints() async{
  //   PolylinePoints polylinePoints = PolylinePoints;
  // }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
            // liteModeEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialPosition!,
            mapType: MapType.normal,
            onMapCreated: (mapController) {
              _controller.complete(mapController);
            },
            markers: markers.toSet(),

            //   // getDist(distance, temp, cordinate, markers, total);
            //
            //   // 좌표간 거리 계산
            //   if (markers.length == 1) {
            //     temp = LatLng(cordinate.latitude, cordinate.longitude);
            //   } else {
            //     total = total! +
            //         distance(d.LatLng(temp.latitude, temp.longitude),
            //             d.LatLng(cordinate.latitude, cordinate.longitude));
            //
            //     temp = LatLng(cordinate.latitude, cordinate.longitude);
            //   }
            //
            //   latlng.add(LatLng(double.parse(cordinate.latitude.toString()),
            //       double.parse(cordinate.longitude.toString())));
            //
            //   // 폴리라인
            //   _polylines.add(Polyline(
            //     polylineId: PolylineId(cordinate.toString()),
            //     visible: true,
            //     points: latlng,
            //     color: Colors.blue,
            //   ));
            // },
            polylines: {
              Polyline(
                polylineId: PolylineId('route'),
                visible: true,
                width: 5,
                points: latlng,
                color: Colors.blue,
              ),
            }),
        Padding(
          padding: EdgeInsets.fromLTRB(
              size.height * 0.01, size.height * 0.53, size.height * 0.01, 0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 3.0)),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: size.height * 0.1,
                // color: Colors.white,
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
                              ? Icon(Icons.pause,
                                  color: Theme.of(context).primaryColor)
                              : Icon(Icons.play_arrow,
                                  color: Theme.of(context).primaryColor)),
                    ),
                    Align(
                      alignment: Alignment(
                        Alignment.centerLeft.x + size.width * 0.0005,
                        Alignment.center.y,
                      ),
                      child: Text(
                        '${_timeCount ~/ 360000} : ${_timeCount ~/ 6000} : ${(_timeCount % 6000) ~/ 100}',
                        // (_timeCount ~/ 100).toString() + ' 초',
                        style: TextStyle(
                            fontSize: 30,
                            color: Color.fromARGB(255, 80, 78, 91)),
                      ),
                    ),
                    Align(
                      alignment: Alignment(
                        Alignment.centerRight.x - size.width * 0.0005,
                        Alignment.center.y,
                      ),
                      child: Text(
                        total.toString() + ' m',
                        // 'data',
                        style: TextStyle(
                            fontSize: 30,
                            color: Color.fromARGB(255, 80, 78, 91)),
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
                          builder: (context) => WalkPage(tabIndex: 2)));
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
              child: Icon(Icons.access_time_filled),
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
              child: Icon(Icons.add),
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
  OutlineCircleButton({
    Key? key,
    this.onTap,
    this.borderSize = 0.5,
    this.radius = 20.0,
    this.borderColor = const Color.fromARGB(255, 100, 92, 170),
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
              child: child ?? SizedBox(),
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
