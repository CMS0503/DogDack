import "package:cloud_firestore/cloud_firestore.dart";

class WalkData {
  WalkData({
    this.userPlace,
    this.userTime,
    this.userDistance,
    this.createdAt,
  });

  final String? userPlace;
  final int? userTime;
  final int? userDistance;
  final Timestamp? createdAt;

  WalkData.fromJson(Map<String, Object?> json)
      : this(
          userPlace: json['userPlace']! as String,
          userTime: json['userTime']! as int,
          userDistance: json['userDistance']! as int,
          createdAt: json['createdAt']! as Timestamp,
        );
  Map<String, Object?> toJson() {
    return {
      'userPlace': userPlace,
      'userTime': userTime,
      'userDistance': userDistance,
      'createdAt': createdAt,
    };
  }
}
