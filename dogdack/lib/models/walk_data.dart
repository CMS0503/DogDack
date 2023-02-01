import "package:cloud_firestore/cloud_firestore.dart";

class WalkData {
  String? distance;
  String? time;

  WalkData({this.distance, this.time});

  WalkData.fromJson(Map<String, dynamic> json)
      : this(
    distance: json['distance']!,
    time: json['time']!,
  );

  Map<String, dynamic> toJson() {
    return {
      'distance': distance,
      'time': time,
    };
  }
}

