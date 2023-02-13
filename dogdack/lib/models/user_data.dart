import "package:cloud_firestore/cloud_firestore.dart";

class UserData {
  UserData({
    this.phoneNumber,
    this.password,
    this.isHost,
    this.hostEmail,
  });

  final String? phoneNumber; // 유저 전화번호
  final String? password; // 유저 비밀번호
  final bool? isHost; // 호스트 계정으로 접속할 건지 여부
  final String? hostEmail;

  UserData.fromJson(Map<String, dynamic> json)
      : this(
    phoneNumber: json['phoneNumber']! as String,
    password: json['password']! as String,
    isHost: json['isHost']! as bool,
    hostEmail: json['hostEmail']! as String,
  );

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'password': password,
      'isHost': isHost,
      'hostEmail': hostEmail,
    };
  }
}
