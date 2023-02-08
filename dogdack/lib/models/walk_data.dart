import 'package:cloud_firestore/cloud_firestore.dart';

class WalkData {
  WalkData({
    this.geolist,
    this.startTime,
    this.endTime,
    this.totalTimeMin,
    this.isAuto,
    this.place,
    this.distance,
    this.goal,
  });

  final List<GeoPoint>? geolist;
  final Timestamp? startTime; // 산책 시작 시간
  final Timestamp? endTime; // 산책 종료 시간
  final num? totalTimeMin; // 실제로 산책한 시간. 분 단위 (일시정지 있는 경우 필요)
  final bool? isAuto; // 해당 산책 Document 기록이 자동입력인지 수동입력인지
  final String? place; // 대표 산책 장소
  final num? distance; // 이동 거리
  final num? goal;

  WalkData.fromJson(Map<String, dynamic> json)
      : this(
          geolist: json['geolist']! as List<GeoPoint>,
          startTime: json['startTime']! as Timestamp,
          endTime: json['endTime']! as Timestamp,
          totalTimeMin: json['totalTimeMin'] as num,
          isAuto: json['isAuto'] as bool,
          place: json['place']! as String,
          distance: json['distance']! as num,
          goal: json['goal'] as num,
        );

  Map<String, dynamic> toJson() {
    return {
      'geolist': geolist,
      'startTime': startTime,
      'endTime': endTime,
      'totalTimeMin': totalTimeMin,
      'isAuto': isAuto,
      'place': place,
      'distance': distance,
      'goal': goal,
    };
  }
}
