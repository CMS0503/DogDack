import 'package:flutter/material.dart';

Center kategorieText(String str) {
  return Center(
    child: Text(
      str,
      style: TextStyle(
        color: Color(0xff644CAA),
        
      ),
    ),
  );
}

Text detailText(String str) {
  return Text(
    '${str}\n',
    style: TextStyle(
      color: Color(0xff504E5B),
    ),
  );
}

void FlutterDialog(BuildContext context) {
  showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          //Dialog Main Title
          title: Column(
            children: <Widget>[
              new Text("견종 분류 가이드"),
            ],
          ),
          //
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                kategorieText("논스포팅 그룹"),
                detailText("푸들(미니어쳐/스탠다드), 보스턴 테리어, 비숑프리제, 달마시안, 샤페이, 꼬똥 드 튤레아, 라사 압소, 시바이누, 프렌치 불독, 차우차우 등"),
                kategorieText("시각 하운드 그룹"),
                detailText("그레이하운드,  아프간 하운드, 보르조이, 살루키, 휘핏 등"),
                kategorieText("후각 하운드 그룹"),
                detailText("닥스훈트, 바셋 하운드, 비글 등"),
                kategorieText("테리어 그룹"),
                detailText("미니어쳐 슈나우저, 화이트 테리, 러셀 테리어, 불 테리어 등"),
                kategorieText("허딩 그룹"),
                detailText("셔틀랜드 쉽독, 보더콜리, 웰시코기, 저먼 셰퍼드 등"),
                kategorieText("토이 그룹"),
                detailText("말티즈, 시츄, 요크셔 테리어, 토이 푸들, 치와와, 포메라니안, 페키니즈 , 파피용, 퍼그 등"),
                kategorieText("스포팅 그룹"),
                detailText("리트리버, 스파니엘, 포인터, 세터 등"),
                kategorieText("워킹 그룹"),
                detailText("도베르만, 로트와일러, 사몸예드, 세인트 버나드, 시베리안 허스키, 말라뮤트, 복서, 마스티프, 아키타, 케인 코르소, 핀셔 등"),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('확인'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xff646CAA)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
            )
          ],
        );
      });
}

/*
desc: "논스포팅 그룹 \n"
"푸들(미니어쳐/스탠다드), 보스턴 테리어, 비숑프리제, 달마시안, 샤페이, 꼬똥 드 튤레아, 라사 압소, 시바이누, 프렌치 불독, 차우차우 \n"
"하운드 그룹 \n"*/
