import 'package:flutter/material.dart';

enum CalendarSnackBarErrorType {
  NoDog,
  TimeError,
}

class CalendarSnackBar {
  CalendarSnackBar._privateConstructor();
  static final CalendarSnackBar _instance =
      CalendarSnackBar._privateConstructor();

  factory CalendarSnackBar() {
    return _instance;
  }

  notfoundCalendarData(
      BuildContext context, CalendarSnackBarErrorType errorType) {
    String msg = '';

    // field 적합하지 않을 때 팝업
    switch (errorType) {
      case CalendarSnackBarErrorType.NoDog:
        msg = '강아지를 등록해 주세요!';
        break;
      case CalendarSnackBarErrorType.TimeError:
        msg = '산책 시간을 확인해 주세요';
        break;
    }
    // 팝업 닫기
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: '다시',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    ));
  }
}
