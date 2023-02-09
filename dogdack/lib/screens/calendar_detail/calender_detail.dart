import 'package:dogdack/screens/calendar_detail/widget/beauty/beauty_icon.dart';
import 'package:dogdack/screens/calendar_detail/widget/diary/diary_widget.dart';
import 'package:dogdack/screens/calendar_detail/widget/cal_detail_date.dart';
import 'package:dogdack/screens/calendar_detail/widget/cal_detail_title.dart';
import 'package:dogdack/screens/calendar_detail/widget/cal_edit_button.dart';
import 'package:dogdack/screens/calendar_detail/widget/walk/cal_walk_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controllers/input_controller.dart';
import '../../controllers/mypage_controller.dart';

class CalenderDetail extends StatefulWidget {


  @override
  State<CalenderDetail> createState() => _CalenderDetailState();
}

class _CalenderDetailState extends State<CalenderDetail> {
  final controller = Get.put(InputController());
  final mypageStateController = Get.put(MyPageStateController());


// 캘린더에서 받아온 데이터
  String docId = '짬뽕';
  bool bath = false;
  bool beauty = false;
  String diary = "오늘의 일기";
  late String imageUrl = 'images/login/login_image.png';

  ////////////////////////////////////파이어 베이스 연결 끝/////////////////////////////////////////////////////


  @override
  Widget build(BuildContext context) {
    Color grey = Color.fromARGB(255, 80, 78, 91);
    Color violet = Color.fromARGB(255, 100, 92, 170);
    late Color hair_color = grey;
    late Color bath_color = grey;

    if(controller.beauty == true){
      hair_color = violet;
    }else{
      hair_color = grey;
    }
    if(controller.bath == true){
      bath_color = violet;
    }else{
      bath_color = grey;
    }
    if(controller.imageUrl.length!=0){
      imageUrl = controller.imageUrl[0];
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: grey,
        ),
        title: Text(
          mypageStateController.myPageStateType == MyPageStateType.Create
              ? '추가하기'
              : '캘린더 상세페이지',
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
                  CalDetailTitleWidget(name: "짬뽕이", title: "산책"),
                  CalEditButtonWidget(),
                ]),
            //날짜
            Padding(
              padding: EdgeInsets.only(left: 18, bottom: 15),
              child: Column(
                children: [
                  // 등록한 날짜가 나와야 함
                  CalDetailDateWidget(
                      time:
                          "${controller.date.year}년 ${controller.date.month}월 ${controller.date.day}일 ${controller.date.hour}시 ${controller.date.second}분에서"),
                  CalDetailDateWidget(
                      time:
                          "${controller.date.year}년 ${controller.date.month}월 ${controller.date.day}일 ${controller.date.hour}시 ${controller.date.second}분까지")
                ],
              ),
            ),
            // 산책 카드
            CalWalkCardWidget(
                distance: controller.distance,
                imageUrl: imageUrl,
                place: controller.place,
                totalTimeMin: controller.time),
            CalDetailTitleWidget(name: "짬뽕이", title: "뷰티도장"),
            BeautyWidget(hair_color: hair_color, bath_color: bath_color),
            CalDetailTitleWidget(name: "짬뽕이", title: "오늘의 일기"),
            DiaryWidget(diary_image: imageUrl, diary_text: controller.diary),
          ],
        ),
      ),
    );
  }
}
