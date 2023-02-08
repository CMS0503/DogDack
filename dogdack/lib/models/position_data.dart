import "package:cloud_firestore/cloud_firestore.dart";

class PosData {
  List<GeoPoint>? loc;


  PosData({this.loc});

  PosData.fromJson(Map<String, dynamic> json)
      : this(
    loc: json['loc']!,
  );

  Map<String, dynamic> toJson() {
    return {
      'loc': loc,
    };
  }
}
