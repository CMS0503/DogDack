import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/dog_data.dart';

class HomePageBarChartController extends GetxController {
  //실제 문서 수 카운트
  List<double> timeWalkCntListRealCnt = List.filled(25, 0);
  //비율을 계산하여 아래 리스트에 저장
  List<double> timeWalkCntList = List.filled(25, 0);

  void calculatorHomeChartData (String curDogID, CollectionReference refCurDogWalk) async {
    // 강아지의 모든 산책 정보를 불러옴
    final docWalkData = await refCurDogWalk.get();
    timeWalkCntListRealCnt = List.filled(25, 0);
    timeWalkCntList= List.filled(25, 0);

    for(int i = 0; i < docWalkData.docs.length; i++) {
      var _startTimeStamp = docWalkData.docs[i]['startTime'];
      DateTime _selele = _startTimeStamp.toDate();
      int sdfasefase = int.parse(DateFormat.H().format(_selele).toString());
      timeWalkCntListRealCnt[sdfasefase]++;
    }

    int maxCnt = 0;

    for(int i = 0; i < 25; i++) {
      if(maxCnt < timeWalkCntListRealCnt.elementAt(i)) {
        maxCnt = timeWalkCntListRealCnt.elementAt(i).toInt();
      }
    }

    if(maxCnt == 0) {
      timeWalkCntList = List.filled(25, 0);
    } else {
      for(int i = 0; i < 25; i++) {
        double inputDate = timeWalkCntListRealCnt.elementAt(i) / maxCnt;
        timeWalkCntList[i] = inputDate * 100;
      }
    }

    update();
  }
}

class HomePageCalendarController extends GetxController {
  late QueryDocumentSnapshot<DogData> queryDocumentSnapshotDog;

  DateTime sunday = DateTime(0);
  DateTime monday = DateTime(0);
  DateTime tuesday = DateTime(0);
  DateTime wednesday = DateTime(0);
  DateTime thursday = DateTime(0);
  DateTime friday = DateTime(0);
  DateTime saturday = DateTime(0);

  bool isAutoFlag = true;

  void autoFlagUpdate() {
    update();
  }
}