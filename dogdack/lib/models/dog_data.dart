import "package:cloud_firestore/cloud_firestore.dart";

class DogData {
  DogData({
    this.imageUrl,
    this.imageFileName,
    this.name,
    this.gender,
    this.birth,
    this.kategorie,
    this.breed,
    this.weight,
    this.recommend,
    this.createdAt
  });

  final String? imageUrl; // 반려견 사진 Download URL
  final String? imageFileName; // Firebase Storage 에 저장된 반려견 사진 파일명
  final String? name; // 반려견 이름
  final String? gender; // 반려견 성별
  final String? birth; // 반려견 생일
  final String? kategorie; // 반려견 견종 분류
  final String? breed; // 반려견 견종
  final num? weight; // 반려견 몸무게
  final num? recommend; // 반려견 권장 산책 시간, 분단위
  final Timestamp? createdAt; // 데이터 생성일

  DogData.fromJson(Map<String, dynamic> json)
      : this(
    imageUrl: json['imageUrl']! as String,
    imageFileName: json['imageFileName'] as String,
    name: json['name']! as String,
    gender: json['gender']! as String,
    birth: json['birth']! as String,
    kategorie: json['kategorie']! as String,
    breed: json['breed']! as String,
    weight: json['weight']! as num,
    recommend: json['recommend'] as num,
    createdAt: json['createdAt']! as Timestamp,
  );

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'imageFileName': imageFileName,
      'name': name,
      'gender': gender,
      'birth': birth,
      'kategorie' : kategorie,
      'breed': breed,
      'weight' : weight,
      'recommend' : recommend,
      'createdAt': createdAt,
    };
  }
}
