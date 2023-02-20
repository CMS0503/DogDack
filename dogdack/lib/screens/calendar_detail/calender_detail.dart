import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:dogdack/controllers/walk_controller.dart';
import 'package:dogdack/screens/calendar_detail/widget/beauty/beauty_icon.dart';
import 'package:dogdack/screens/calendar_detail/widget/diary/diary_widget.dart';
import 'package:dogdack/screens/calendar_detail/widget/cal_detail_title.dart';
import 'package:dogdack/screens/calendar_detail/widget/cal_edit_button.dart';
import 'package:dogdack/screens/calendar_detail/widget/diary/diary_widget_net.dart';
import 'package:dogdack/screens/calendar_detail/widget/walk/cal_walk_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/input_controller.dart';
import '../../controllers/mypage_controller.dart';

class CalenderDetail extends StatefulWidget {
  const CalenderDetail({super.key});

  @override
  State<CalenderDetail> createState() => _CalenderDetailState();
}

class _CalenderDetailState extends State<CalenderDetail> {
  final controller = Get.put(InputController());
  final mypageStateController = Get.put(MyPageStateController());
  final walkController = Get.put(WalkController());
  final userController = Get.put(UserController());

  Future<void> getImage() async {
    var dogDoc = await FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets')
        .doc(controller.dognames[controller.selectedValue].toString())
        .collection('Calendar')
        .doc(DateFormat('yyMMdd').format(controller.date))
        .get()
        .then((value) {
      imgList = value['imageUrl'];
      if (imgList.isNotEmpty) {
        imageUrl = imgList[0].toString();
      }
    });
  }

  Future<void> setDate() async {
    String docId = controller.dognames[controller.selectedValue.toString()];
    // walk 경로
    CollectionReference walkRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets/$docId/Walk');

    await walkRef.get().then(
      (value) async {
        // print('cal_walk_card 안 : ${userController.loginEmail}');
        // 달력에서 선택한 날짜
        var selectedDay = controller.date;
        var startOfToday = Timestamp.fromDate(selectedDay);
        var endOfToday =
            Timestamp.fromDate(selectedDay.add(const Duration(days: 1)));

        // 선택한 날짜의 산책 데이터를 내림차순 정렬(최신 데이터가 위로 오게)
        await walkRef
            .where("startTime",
                isGreaterThanOrEqualTo: startOfToday, isLessThan: endOfToday)
            .orderBy("startTime", descending: true)
            .get()
            .then(
          (QuerySnapshot snapshot) async {
            print('cal_walk_card 안 snapshot: ${snapshot.docs}');
            // 장소, 거리, 시간 데이터
            controller.startTime = snapshot.docs[0]['startTime'];
            controller.endTime = snapshot.docs[0]['endTime'];

            // 여기 geodata 수정해야 될 거 같은데, 송빈님이랑 상의하기
          },
        );
      },
    );
    // .then((value) {
    //   setState(() {});
    // });
  }

  @override
  void initState() {
    getImage().then((value) {
      setDate().then((value) {
        setState(() {
          startTime = controller.startTime.toDate();
          endTime = controller.endTime.toDate();
        });
      });
      // setState(() {
      //   startTime = walkController.walkStartTime.toDate();
      //   endTime = walkController.walkEndTime.toDate();
      // });
    });

    super.initState();
  }

// 캘린더에서 받아온 데이터임
  String docId = '짬뽕';
  bool bath = false;
  bool beauty = false;
  String diary = "오늘의 일기";
  List<Object?> imgList = [];
  var imageUrl = '';
  // DateTime startTime = Timestamp.now().toDate();
  // DateTime endTime = Timestamp.now().toDate();
  DateTime startTime = DateTime.fromMillisecondsSinceEpoch(
      (DateTime.now().millisecondsSinceEpoch +
              DateTime.now().timeZoneOffset.inMilliseconds)
          .toInt());
  DateTime endTime = DateTime.fromMillisecondsSinceEpoch(
      (DateTime.now().millisecondsSinceEpoch +
              DateTime.now().timeZoneOffset.inMilliseconds)
          .toInt());

  ////////////////////////////////////파이어 베이스 연결 끝/////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    Color grey = const Color.fromARGB(255, 80, 78, 91);
    Color violet = const Color.fromARGB(255, 100, 92, 170);
    late Color hairColor = grey;
    late Color bathColor = grey;

    if (controller.beauty.value == true) {
      hairColor = violet;
    } else {
      hairColor = grey;
    }
    if (controller.bath.value == true) {
      bathColor = violet;
    } else {
      bathColor = grey;
    }

    Widget imageWidge =
        DiaryWidget(diaryImage: imageUrl, diaryText: controller.diary.value);

    if (imageUrl.isNotEmpty) {
      imageWidge = DiaryNetWidget(
          diaryImage: imageUrl, diaryText: controller.diary.value);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: grey,
        ),
        title: Text(
          mypageStateController.myPageStateType == MyPageStateType.Create
              ? ''
              : '',
          style: TextStyle(
            color: grey,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //산책 타이틀 +  편집 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CalDetailTitleWidget(
                    name: controller.selectedValue, title: "발자취"),
                CalEditButtonWidget(),
              ],
            ),
            //날짜
            Padding(
              padding: const EdgeInsets.only(left: 18, bottom: 15),
              child: Column(
                children: <Widget>[
                  Text(
                      "${startTime.year}년 ${startTime.month}월 ${startTime.day}일 ${startTime.hour}시 ${startTime.minute}분부터"),
                  Text(
                      "${endTime.year}년 ${endTime.month}월 ${endTime.day}일 ${endTime.hour}시 ${endTime.minute}분까지"),
                ],
              ),
            ),
            // 산책 카드
            CalWalkCardWidget(
              distance: controller.distance,
              // 나중에 여러개로 바꿔야됨
              imageUrl: imageUrl,
              place: controller.place,
              totalTimeMin: controller.time,
            ),
            CalDetailTitleWidget(
              name: controller.selectedValue,
              title: "뷰티도장",
            ),

            BeautyWidget(
              hair_color: hairColor,
              bath_color: bathColor,
            ),
            CalDetailTitleWidget(
              name: controller.selectedValue,
              title: "오늘의 일기",
            ),
            // 나중에 여러개로 바꿔야됨
            imageWidge,
          ],
        ),
      ),
    );
  }
}
