import "package:cloud_firestore/cloud_firestore.dart";

class WalkData {
  WalkData({this.name, this.startTime, this.endTime, this.place, this.distance, this.time});

  final String? name; // 반려견 이름
  //좌표 리스트
  final Timestamp? startTime; // 산책 시작 시간
  final Timestamp? endTime; // 산책 종료 시간
  final String? place; // 대표 산책 장소
  final int? distance; // 이동 거리
  final String? time;



  WalkData.fromJson(Map<String, dynamic> json)
      : this(
    name: json['name']! as String,
    startTime: json['startTime']! as Timestamp,
    endTime: json['endTime']! as Timestamp,
    place: json['place']! as String,
    distance: json['distance']! as int,
    time: json['time']! as String,
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'startTime': startTime,
      'endTime': endTime,
      'place': place,
      'distance': distance,
      'time': time,
    };
  }
}

