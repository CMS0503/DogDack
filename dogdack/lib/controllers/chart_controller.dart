import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChartController extends GetxController {
  final petsRef = FirebaseFirestore.instance
      .collection('Users/${'imcsh313@naver.com'}/Pets');

  // 강아지 이름 key: 이름, values: 아이디
  Map dogNames = {};

  // key: 강아지 이름, value: 강아지 두달 동안의 데이터
  // value map => key: 시간, 거리 목표, value => double  값 리스트
  Map<String, Map<String, List<double>>> chartData = {};

  // 선택된 강아지 id
  RxString chartSelectedId = ''.obs;
  // 선택된 강아지 이름
  RxString chartSelectedName = ''.obs;

  // 두달 날짜 채움
  List<String> dateList = [];

  // 강아지 별 데이터가 있는 날짜
  Map<String, List> dogsDate = {};

  RxString selectedDateValue = ''.obs;



  List<double> hour_points = [];

  Future<void> setData() async {
    fillDate();
    await getData();
  }

  void fillDate() {
    for (int i = 0; i < 60; i++) {
      String temp = DateTime.now().subtract(Duration(days: 59 - i)).toString();
      dateList.add(temp.substring(0, 10));
    }
  }

// 데리고 있는 강아지 리스트를 불러온다.
  Future<void> getNames() async {
    var dogDoc = await petsRef.orderBy('name').get();
    for (int i = 0; i < dogDoc.docs.length; i++) {
      String name = dogDoc.docs[i]['name'].toString();
      if (!dogNames.keys.toList().contains(name)) {
        dogNames[name] = dogDoc.docs[i].id.toString();
      }
    }
    if (dogNames.values.toList().length != 0) {
      chartSelectedId.value = dogNames.values.toList()[0];
      chartSelectedName.value= dogNames.keys.toList()[0];
    }
  }

// 두달동안의 데이터를 불러온다.
  Future<void> getData() async {
    for (int i = 0; i < dogNames.values.toList().length; i++) {
      List<double> twoMonthHour = List<double>.filled(60, 1);
      List<double> twoMonthDistance = List<double>.filled(60, 1);
      List<double> twoMonthGoal = List<double>.filled(60, 1);
      Map<String, List<double>> temp = {};
      CollectionReference refCurDogWalk = FirebaseFirestore.instance
          .collection('Users/imcsh313@naver.com/Pets/')
          .doc(dogNames.values.toList()[i].toString())
          .collection('Walk');

      await refCurDogWalk
          .where('startTime',
          isGreaterThan: DateTime.now().subtract(Duration(days: 60)))
          .orderBy('startTime', descending: false)
          .get()
          .then((QuerySnapshot snapshot) {
        List<String> tempList = [];
        //(강아지 : [가지고 있는 데이트 리스트])
        dogsDate[dogNames.values.toList()[i].toString()] = tempList;
        for (int j = 0; j < snapshot.docs.length; j++) {
          tempList.add((snapshot.docs[j]['startTime'])
              .toDate()
              .toString()
              .substring(0, 10));
        }
        for (int j = 0; j < dateList.length; j++) {
          if (dogsDate[dogNames.values.toList()[i].toString()]!.isNotEmpty) {

            for (int k = 0;
            k < dogsDate[dogNames.values.toList()[i].toString()]!.length;
            k++) {
              if (dogsDate[dogNames.values.toList()[i].toString()]![k] ==
                  (dateList[j])) {
                twoMonthHour[j] = snapshot.docs[k]['totalTimeMin'].toDouble();
                twoMonthDistance[j] = snapshot.docs[k]['distance'].toDouble();
                twoMonthGoal[j] = snapshot.docs[k]['goal'].toDouble();
              }
            }
          }
        }

      });

      temp['hour'] = twoMonthHour;
      temp['distance'] = twoMonthDistance;
      temp['goal'] = twoMonthGoal;
      chartData[dogNames.values.toList()[i].toString()] = temp;


    } // 강아지 별 for문
  }




}
