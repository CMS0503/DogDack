import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:get/get.dart';

class ChartController extends GetxController {
  final userController = Get.put(UserController());

  // 강아지 이름 key: 이름, values: 아이디
  Map dogNames = {};

  // 강아지 이름 key: 이름, values: 권장 산책 시간
  Map dogGoal = {};

  // key: 강아지 이름, value: 강아지 두달 동안의 데이터
  // value map => key: 시간, 거리 목표, value => double  값 리스트
  Map<String, Map<String, List<double>>> chartData = {};

  // 선택된 강아지 id
  RxString chartSelectedId = ''.obs;

  // 선택된 강아지 이름
  RxString chartSelectedName = ''.obs;

  // 선택된 강아지 권장 산책시간
  int goalTime = 0;

  // 두달 날짜 채움
  List<String> dateList = [];

  // 강아지 별 데이터가 있는 날짜
  Map<String, List> dogsDate = {};

  RxString selectedDateValue = ''.obs;
//강아지 이름
  String name = '';


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
  Future<Map> getNames() async {
    var dogDoc = await FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets')
        .orderBy('name')
        .get();
    for (int i = 0; i < dogDoc.docs.length; i++) {
      String name = dogDoc.docs[i]['name'].toString();
      if (!dogNames.keys.toList().contains(name)) {
        dogNames[name] = dogDoc.docs[i].id.toString();
        dogGoal[name] = dogDoc.docs[i]['recommend'].toInt();
      }
    }
    if (dogNames.keys.length == 1){
      chartSelectedName.value = dogNames.keys.toList().first;
      // goalTime.value = dogGoal.values.toList().first;
    }


    return dogNames;
  }

// 두달동안의 데이터를 불러온다.
  Future<void> getData() async {
    for (int i = 0; i < dogNames.values.toList().length; i++) {
      List<double> twoMonthHour = List<double>.filled(60, 0.000001);
      List<double> twoMonthDistance = List<double>.filled(60, 0.000001);
      List<double> twoMonthGoal = List<double>.filled(60, 0.000001);
      Map<String, List<double>> temp = {};
      CollectionReference refCurDogWalk = FirebaseFirestore.instance
          .collection('Users/${userController.loginEmail}/Pets/')
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
        if (!dogNames.values.isNull) {


          dogsDate[dogNames.values.toList()[i].toString()] = tempList;

          for (int j = 0; j < snapshot.docs.length; j++) {
            tempList.add((snapshot.docs[j]['startTime'])
                .toDate()
                .toString()
                .substring(0, 10));
          }

          for (int j = 0; j < dateList.length; j++) {
            if (dogsDate[dogNames.values.toList()[i].toString()]!.length != 0) {

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
        }
      });
      temp['hour'] = twoMonthHour;
      temp['distance'] = twoMonthDistance;
      temp['goal'] = twoMonthGoal;
      chartData[dogNames.values.toList()[i].toString()] = temp;
    } // 강아지 별 for문
  }
}
