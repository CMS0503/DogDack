import 'package:flutter/material.dart';


class PetGoalWidget extends StatefulWidget {
  num goal;
  PetGoalWidget({required this.goal});


  @override
  State<PetGoalWidget> createState() => _PetGoalWidget();
}

class _PetGoalWidget extends State<PetGoalWidget> {

  TextStyle gery_style = TextStyle(
    fontFamily: 'bmjua',
    color: Color.fromARGB(255, 80, 78, 91),
    fontSize: 18,
  );

  TextStyle violet_style = TextStyle(
    fontFamily: 'bmjua',
    fontSize: 24,
    color :  Color.fromARGB(255, 100, 92, 170)
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
          Text("오늘 산책 목표 달성량", style: gery_style,),
          Text("${widget.goal}%", style: violet_style,)

        ],

      ),
    );
  }
}
