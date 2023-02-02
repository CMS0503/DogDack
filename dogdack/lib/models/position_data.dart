import "package:cloud_firestore/cloud_firestore.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as d;

/*
class PosData {
  PosData({this.lat, this.lng});

  final String? lat;
  final String? lng;

  PosData.fromJson(Map<String, dynamic> json)
      : this(
    lat: json['lat']!,
    lng: json['lng']!,
  );
  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}
 */

class PosData {
  Timestamp? timestamp;
  String? lat;
  String? lng;

  PosData({this.timestamp, this.lat, this.lng});

  PosData.fromJson(Map<String, dynamic> json)
      : this(
    timestamp: json['timestamp']!,
    lat: json['lat']!,
    lng: json['lng']!,
  );

  Map<String, dynamic> toJson() {
    return {
      'Timestamp': timestamp,
      'lat': lat,
      'lng': lng,
    };
  }
}

void getDist(d.Distance distance, LatLng curPos, LatLng nextPos, List<Marker> markers, double? total) {

  if(markers.length == 1){
    curPos = LatLng(nextPos.latitude, nextPos.longitude);
  } else {
    total = total! + distance(
        d.LatLng(curPos.latitude, curPos.longitude),
        d.LatLng(nextPos.latitude, nextPos.longitude)
    );
    curPos = LatLng(nextPos.latitude, nextPos.longitude);
  }
}