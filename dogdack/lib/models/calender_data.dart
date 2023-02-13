class CalenderData {
  CalenderData({
    this.isWalk,
    this.beauty,
    this.bath,
    this.imageUrl,
    this.diary,
  });

  final bool? isWalk; // 산책 여부
  final bool? beauty; // 미용 여부
  final bool? bath; // 목욕 여부
  final List<String>? imageUrl; // 오늘의 일기 사진 URL
  final String? diary; // 오늘의 일기 내용
  // final String? distance; // 이동 거리

  CalenderData.fromJson(Map<String, dynamic> json)
      : this(
          isWalk: json['isWalk']! as bool,
          beauty: json['beauty']! as bool,
          bath: json['bath']! as bool,
          imageUrl: json['imageUrl']! as List<String>,
          diary: json['diary']! as String,
          // distance: json['distance'] as String,
        );

  Map<String, dynamic> toJson() {
    return {
      'isWalk': isWalk,
      'beauty': beauty,
      'bath': bath,
      'imageUrl': imageUrl,
      'diary': diary,
      // 'distance': distance,
    };
  }
}
