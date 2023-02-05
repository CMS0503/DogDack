import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as ll;

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

  List<LatLng> latlng = [];

  final ll.Distance distance = ll.Distance();
  late LatLng temp;
  double? totalDistance = 0;

  // 타이머 변수
  // late Timer _timer;
  // int _timeCount = 0;
  // bool walkController.isRunning = false;

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
              if (!walkController.isRunning.value) {
                // 시작 전
                widget.receiveData = '';
              } else if (stringValue.contains('}') &&
                  widget.receiveData.contains('{')) {
                // 시작 후
                widget.location = jsonDecode(widget.receiveData);
                walkController.setCurrentLocation(
                    widget.location!['lat'], widget.location!["lon"]);
                print(
                    'walkController location: ${walkController.lat} ${walkController.lon}');
                widget.receiveData = '';
                LatLng currentPosition = LatLng(
                  walkController.lat,
                  walkController.lon,
                );
                googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      zoom: 17,
                      target: currentPosition,
                    ),
                  ),
                );

                if (latlng.length > 1) {
                  totalDistance = totalDistance! +
                      calTotalDistance(
                          ll.LatLng(
                              latlng.last.latitude, latlng.last.longitude),
                          ll.LatLng(currentPosition.latitude,
                              currentPosition.longitude));
                }

                latlng.add(currentPosition);
                print('totaldistance: ${totalDistance}');
                setState(() {});
                // WalkPageState parent =
                //     context.findAncestorStateOfType<WalkPageState>()!;
                // parent.setState(() {});
              }
              widget.receiveData = '';
            });
          }
        }
      }
    }
  }

  double calTotalDistance(ll.LatLng p1, ll.LatLng p2) {
    return distance.as(ll.LengthUnit.Meter, p1, p2);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            GoogleMap(
                // liteModeEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: _initialPosition!,
                mapType: MapType.normal,
                onMapCreated: (mapController) {
                  _controller.complete(mapController);
                },
                markers: markers.toSet(),
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
              padding: EdgeInsets.fromLTRB(size.height * 0.01,
                  size.height * 0.53, size.height * 0.01, 0),
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
                        // 재생버튼
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
                              child: walkController.isRunning.value
                                  ? Icon(Icons.pause,
                                      color: Theme.of(context).primaryColor)
                                  : Icon(Icons.play_arrow,
                                      color: Theme.of(context).primaryColor)),
                        ),
                        // 산책 시간
                        Align(
                          alignment: Alignment(
                            Alignment.centerLeft.x + size.width * 0.0005,
                            Alignment.center.y,
                          ),
                          child: Text(
                            '${walkController.timeCount ~/ 360000} : ${walkController.timeCount ~/ 6000} : ${(walkController.timeCount % 6000) ~/ 100}',
                            // (_timeCount ~/ 100).toString() + ' 초',
                            style: TextStyle(
                                fontSize: 30,
                                color: Color.fromARGB(255, 80, 78, 91)),
                          ),
                        ),
                        // 산책 거리
                        Align(
                          alignment: Alignment(
                            Alignment.centerRight.x - size.width * 0.0005,
                            Alignment.center.y,
                          ),
                          child: Text(
                            totalDistance.toString() + ' m',
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
          ],
        ),
      ),
      // floatingActionButton: Stack(
      //   children: <Widget>[
      //     // 초기화 버튼
      //     Align(
      //       alignment: Alignment(
      //           Alignment.topLeft.x + 0.13, Alignment.topLeft.y + 0.1),
      //       child: FloatingActionButton(
      //         heroTag: "1",
      //         onPressed: () {
      //           markers.clear();
      //           latlng.clear();
      //           FirebaseFirestore.instance
      //               .collection(
      //                   '${FirebaseAuth.instance.currentUser!.email}_position')
      //               .get()
      //               .then((snapshot) {
      //             for (DocumentSnapshot ds in snapshot.docs) {
      //               ds.reference.delete();
      //             }
      //           });
      //           // _controller.animateCamera(CameraUpdate.zoomOut());
      //           setState(() {
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) => WalkPage(tabIndex: 2)));
      //           });
      //         },
      //         tooltip: '초기화',
      //         child: const Icon(Icons.refresh),
      //       ),
      //     ),
      //
      //     // DB 데이터로 좌표 찍기
      //     Align(
      //       alignment: Alignment(
      //           Alignment.topLeft.x + 0.13, Alignment.topLeft.y + 0.4),
      //       child: FloatingActionButton(
      //         heroTag: "2",
      //         onPressed: () async {
      //           totalDistance = 0;
      //           await for (var snapshot in FirebaseFirestore.instance
      //               .collection(
      //                   '${FirebaseAuth.instance.currentUser!.email}_position_test')
      //               .orderBy('Timestamp', descending: true)
      //               .snapshots()) {
      //             for (var messege in snapshot.docs) {
      //               addMarker(LatLng(double.parse(messege.data()['lat']),
      //                   double.parse(messege.data()['lng'])));
      //
      //               if (markers.length == 1) {
      //                 temp = LatLng(double.parse(messege.data()['lat']),
      //                     double.parse(messege.data()['lng']));
      //               } else {
      //                 totalDistance = totalDistance! +
      //                     distance(
      //                         ll.LatLng(temp.latitude, temp.longitude),
      //                         ll.LatLng(double.parse(messege.data()['lat']),
      //                             double.parse(messege.data()['lng'])));
      //                 temp = LatLng(double.parse(messege.data()['lat']),
      //                     double.parse(messege.data()['lng']));
      //               }
      //
      //               latlng.add(LatLng(double.parse(messege.data()['lat']),
      //                   double.parse(messege.data()['lng'])));
      //
      //               _polylines.add(Polyline(
      //                 polylineId: PolylineId(messege.data().toString()),
      //                 visible: true,
      //                 points: latlng,
      //                 color: Colors.blue,
      //               ));
      //             }
      //           }
      //         },
      //         tooltip: '좌표 찍기',
      //         child: Icon(Icons.access_time_filled),
      //       ),
      //     ),
      //
      //     // 이동거리, 시간 DB 저장 버튼
      //     Align(
      //       alignment: Alignment(
      //           Alignment.topLeft.x + 0.13, Alignment.topLeft.y + 0.7),
      //       child: FloatingActionButton(
      //         heroTag: "3",
      //         onPressed: () => setState(() {
      //           FirebaseFirestore.instance
      //               .collection(
      //                   '${FirebaseAuth.instance.currentUser!.email}_walk')
      //               .withConverter(
      //                 fromFirestore: (snapshot, options) =>
      //                     WalkData.fromJson(snapshot.data()!),
      //                 toFirestore: (value, options) => value.toJson(),
      //               )
      //               .add(WalkData(
      //                 distance: totalDistance?.toInt(),
      //                 time: (_timeCount ~/ 100).toString(),
      //               ));
      //         }),
      //         child: Icon(Icons.add),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   super.dispose();
  // }

  // void _start() {
  //   _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
  //     setState(() {
  //       _timeCount++;
  //     });
  //   });
  // }

  // void _pause() {
  //   _timer.cancel();
  // }

  void _clickPlayButton() {
    walkController.updateWalkingState();

    if (walkController.isRunning.value) {
      print('timer start');
      walkController.startTimer();
    } else {
      print('timer stop');
      walkController.pauseTimer();
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
