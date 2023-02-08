import 'package:flutter/material.dart';


class DayGraphWidget extends StatefulWidget {
  String name;
  DayGraphWidget({required this.name});


  @override
  State<DayGraphWidget> createState() => _DayGraphWidget();
}

class _DayGraphWidget extends State<DayGraphWidget> {
  DateTime date = DateTime.now();

  TextStyle gery_style = TextStyle(
    fontFamily: 'bmjua',
    color: Color.fromARGB(255, 80, 78, 91),
    fontSize: 18,
  );


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return  Container(
      width: width,
      height: height * 0.07,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("${date.month}월 ${date.day}일 ${widget.name} 산책 시간", style: gery_style,),

        ],

      ),
    );
  }
}
