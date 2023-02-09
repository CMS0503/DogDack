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

    switch (errorType) {
      case CalendarSnackBarErrorType.NoDog:
        msg = '강아지 사진을 등록 하세요!';
        break;
      case CalendarSnackBarErrorType.TimeError:
        msg = '산책 시간을 확인해 주세요';
        break;
    }
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
