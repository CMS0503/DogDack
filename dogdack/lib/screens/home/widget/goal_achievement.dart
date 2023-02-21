import 'package:dogdack/screens/chart/widget/progress_graph.dart';
import 'package:flutter/material.dart';


class GoalAchievementWidget extends StatelessWidget {
  int this_data;


  GoalAchievementWidget({required this.this_data});
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    Color p = Color.fromARGB(255, 160, 132, 202);
    Color g = Color.fromARGB(255, 229, 229, 230);
    Color grey = Color.fromARGB(255, 80, 78, 91);
    List<Color> colorList = [
      g,
      g,
      g,
      g,
      g,
      g,
      g,
      g,
      g,
      g,

    ];
    int index = 0;
    int percent_index = 0;
    //디비에서 갖고 오는 데이터
    int data = this_data;
    if(data<99){
      for (int i = 0; i < colorList.length; i++) {
        if ((data >= (i * 10) && data < (i + 1) * 10)) {
          percent_index = i;
          break;
        }
        colorList[i] = p;
      }
    }else{
      colorList.fillRange(0, colorList.length,p);
    }

    return Center(
      child: Container(
          width: width * 0.4,
          height: height * 0.05,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Container(
                width: width * 0.8,
                height: height * 0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ProgressWidget(color: colorList[index++]),
                    ProgressWidget(color: colorList[index++]),
                    ProgressWidget(color: colorList[index++]),
                    ProgressWidget(color: colorList[index++]),
                    ProgressWidget(color: colorList[index++]),
                    ProgressWidget(color: colorList[index++]),
                    ProgressWidget(color: colorList[index++]),
                    ProgressWidget(color: colorList[index++]),
                    ProgressWidget(color: colorList[index++]),
                    ProgressWidget(color: colorList[index++]),

                  ],
                ),
              ),
            ),
          )),
    );
  }
}
