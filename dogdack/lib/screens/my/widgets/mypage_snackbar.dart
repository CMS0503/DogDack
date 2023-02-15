// 스낵 바 오류 종류
import 'package:flutter/material.dart';

enum SnackBarErrorType {
  ImageNotExist, // 이미지가 입력되지 않음
  NameNotExist, // 반려견 이름이 입력되지 않음
  BirthNotExist, // 반려견 생일이 입력되지 않음
  BreedNotExist, // 반려견 견종이 입력되지 않음
  KategorieNotExist, // 반려견 카테고리가 입력되지 않음
  NameOverflow, // 반려견 이름이 제한 글자(10글자) 를 초과함
  BreedOverflow, // 반려견 견종이 제한 글자(20글자) 를 초과함
  PhoneNumberNotExist, // 전화번호가 입력되지 않았을 경우
  NameAlreadyExist, // 반려견 이름이 이미 존재하는 경우
  PasswordNotExist, // 공유 비밀번호가 입력되지 않았을 경우
  InvalidLogin, // 공유 로그인 정보가 유효하지 않음
  EmailNotExist, // 존재하지 않는 이메일 입니다.
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
        msg = '강아지 견종을 등록 하세요!';
        break;
      case SnackBarErrorType.KategorieNotExist:
        msg = '강아지 분류를 등록 하세요!';
        break;
      case SnackBarErrorType.NameOverflow:
        msg = '이름은 10글자 까지 입력 가능해요!';
        break;
      case SnackBarErrorType.BreedOverflow:
        msg = '견종은 20글자 까지 입력 가능해요!';
        break;
      case SnackBarErrorType.PhoneNumberNotExist:
        msg = '전화 번호를 입력하지 않았어요!';
        break;
      case SnackBarErrorType.NameAlreadyExist:
        msg = '같은 이름의 댕댕이가 이미 있어요!\n다른 이름으로 입력하세요!';
        break;
      case SnackBarErrorType.PasswordNotExist:
        msg = '비밀번호를 입력하지 않았어요!';
        break;
      case SnackBarErrorType.InvalidLogin:
        msg = '잘못된 입력입니다!';
        break;
      case SnackBarErrorType.EmailNotExist:
        msg = '입력하신 이메일에 해당하는 유저가 없어요!';
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