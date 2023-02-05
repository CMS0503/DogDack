// 스낵 바 오류 종류
import 'package:flutter/material.dart';

enum SnackBarErrorType {
  ImageNotExist, // 이미지가 입력되지 않음
  NameNotExist, // 반려견 이름이 입력되지 않음
  BirthNotExist, // 반려견 생일이 입력되지 않음
  BreedNotExist, // 반려견 견종이 입력되지 않음
}

class MyPageSnackBar {
  // 싱글톤 패턴
  // MyPageSnackBar() 생성자로 유일한 객체를 생성
  MyPageSnackBar._privateConstructor();
  static final MyPageSnackBar _instance = MyPageSnackBar._privateConstructor();

  factory MyPageSnackBar() {
    return _instance;
  }

  // 정보 입력 관련 스낵 바 오류 알림
  notfoundDogData(BuildContext context, SnackBarErrorType errorType) {
    String msg = '';

    switch (errorType) {
      case SnackBarErrorType.ImageNotExist:
        msg = '강아지 사진을 등록 하세요!';
        break;
      case SnackBarErrorType.NameNotExist:
        msg = '강아지 이름을 등록 하세요!';
        break;
      case SnackBarErrorType.BirthNotExist:
        msg = '강아지 생일을 등록 하세요!';
        break;
      case SnackBarErrorType.BreedNotExist:
        msg = '강아지 견종을 등록 하세요';
        break;
    }

    // 하단에 알림창을 띄움
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    ));
  }
}