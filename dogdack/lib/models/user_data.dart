import "package:cloud_firestore/cloud_firestore.dart";

class UserData {
  UserData({this.userText, this.createdAt});

  final String? userText;
  final Timestamp? createdAt;

  UserData.fromJson(Map<String, Object?> json)
      : this(
          userText: json['userText']! as String,
          createdAt: json['createdAt']! as Timestamp,
        );
  Map<String, Object?> toJson() {
    return {
      'userText': userText,
      'createdAt': createdAt,
    };
  }
}
