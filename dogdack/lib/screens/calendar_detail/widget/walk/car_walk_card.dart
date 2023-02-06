import 'package:dogdack/commons/logo_widget.dart';
import 'package:dogdack/screens/calendar_detail/widget/walk/cal_walk_text.dart';
import 'package:flutter/material.dart';


class CalWalkCardWidget extends StatefulWidget {


  @override
  State<CalWalkCardWidget> createState() => _CalWalkCardWidget();
}

class _CalWalkCardWidget extends State<CalWalkCardWidget> {

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return   Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        child: Container(
          width: width * 0.9,
          height: height * 0.25,
          child: Row(
            children: <Widget>[
              // 지도
              Container(
                width: width * 0.45,
                height: height * 0.2,
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 80, 78, 91),
                    borderRadius: BorderRadius.circular(16.0)),
              ),
              // 산책 정보
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: Column(
                  children: <Widget>[
                    Flexible(child: CalDetailTextWidget(title: "산책 장소", text: "데이터 베이스",)),
                    Flexible(child: CalDetailTextWidget(title: "이동 거리",text: "데이터 베이스")),
                    Flexible(child: CalDetailTextWidget(title: "산책 시간",text: "데이터 베이스")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
