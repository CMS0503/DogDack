import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as ll;

import '../../../controllers/walk_controller.dart';

class myMap extends StatefulWidget {
  late final String title;
  late String receiveData = '';
  Map? location;

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<myMap> {
  // late GoogleMapController _controller;
  final Completer<GoogleMapController> _controller = Completer();
  final walkController = Get.put(WalkController());

  late CameraPosition? _initialPosition;

  // 지도 클릭 시 표시할 장소에 대한 마커 목록
  final List<Marker> markers = [];

  List<LatLng> latlng = [];

  final ll.Distance distance = const ll.Distance();
  late LatLng temp;
  double? totalDistance = 0;

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
      if (service.uuid.toString() == walkController.serviceUUID) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.uuid.toString() ==
              walkController.characteristicUUID) {
            await characteristic.setNotifyValue(true);
            String stringValue = '';
            characteristic.value.listen((value) {
              print('listen: ${value}');
              try {
                stringValue = utf8.decode(value).toString();
              } catch (e) {
                print('Error in decoding(my_map.dart): $e');
              }

              widget.receiveData += stringValue;
              // 한번 갱신 될 때마다
              // 시작 전
              if (!walkController.isRunning.value) {
                widget.receiveData = '';
              } else if (widget.receiveData.contains('{') &&
                  widget.receiveData.contains('}')) {
                // 시작 후
                try {
                  int start = widget.receiveData.indexOf('{');
                  int end = widget.receiveData.indexOf('}') + 1;

                  widget.receiveData = widget.receiveData.substring(start, end);

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
                    walkController.distance = totalDistance;
                  }

                  latlng.add(currentPosition);
                  walkController.addData(
                      currentPosition.latitude, currentPosition.longitude);
                  print('totaldistance: $totalDistance');
                  setState(() {});
                } catch (e) {
                  print('Error in set position - $e');
                }
              }
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
      body: Stack(
        children: [
          GoogleMap(
              // liteModeEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: _initialPosition!,
              mapType: MapType.normal,
              onMapCreated: (mapController) {
                if (_controller.isCompleted == false) {
                  _controller.complete(mapController);
                }
              },
              markers: markers.toSet(),
              polylines: {
                Polyline(
                  polylineId: const PolylineId('route'),
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
                child: Obx(
                  () => Stack(
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
                          style: const TextStyle(
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
                          '$totalDistance m',
                          // 'data',
                          style: const TextStyle(
                              fontSize: 30,
                              color: Color.fromARGB(255, 80, 78, 91)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

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
  const OutlineCircleButton({
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
