import "package:cloud_firestore/cloud_firestore.dart";

class WalkData {
  WalkData({
    this.userPlace,
    this.userTime,
    this.userDistance,
    this.userDiary,
    this.createdAt,
  });

  final String? userPlace;
  final int? userTime;
  final int? userDistance;
  final String? userDiary;
  final Timestamp? createdAt;

  WalkData.fromJson(Map<String, Object?> json)
      : this(
          userPlace: json['userPlace']! as String,
          userDiary: json['userDiary']! as String,
          userTime: json['userTime']! as int,
          userDistance: json['userDistance']! as int,
          createdAt: json['createdAt']! as Timestamp,
        );
  Map<String, Object?> toJson() {
    return {
      'userPlace': userPlace,
      'userTime': userTime,
      'userDistance': userDistance,
      'userDiary': userDiary,
      'createdAt': createdAt,
    };
  }
}
