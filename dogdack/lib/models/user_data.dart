import "package:cloud_firestore/cloud_firestore.dart";

class UserData {
  UserData({
    this.phoneNumber,
  });

  final String? phoneNumber; // 반려견 사진 Download URL

  UserData.fromJson(Map<String, dynamic> json)
      : this(
    phoneNumber: json['phoneNumber']! as String,
  );

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
    };
  }
}
