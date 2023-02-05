import "package:cloud_firestore/cloud_firestore.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as d;

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
