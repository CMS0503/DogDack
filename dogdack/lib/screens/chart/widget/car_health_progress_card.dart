import 'package:dogdack/screens/chart/widget/progress_graph.dart';
import 'package:flutter/material.dart';


class CalHealthProgressCardWidget extends StatefulWidget {
  int this_data;
  int last_data;
  String date_text;
  String message;

  CalHealthProgressCardWidget({required this.this_data, required this.last_data, required this.message, required this.date_text});
  @override
  State<CalHealthProgressCardWidget> createState() =>
      _CalHealthProgressCardWidget();
}

class _CalHealthProgressCardWidget extends State<CalHealthProgressCardWidget> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    Color p = Color.fromARGB(255, 221, 137, 189);
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
      g,
      g,
      g,
      g,
      g,
      g,
      g,
      g,
      g,
      g
    ];
    int index = 0;
    int percent_index = 0;
    //디비에서 갖고 오는 데이터
    int data = widget.this_data;
    if(data<99){
    for (int i = 0; i <= colorList.length; i++) {
      if ((data >= (i * 5) && data < (i + 1) * 5)) {
        percent_index = i;
        break;
      }
      colorList[i] = p;
    }
  }else{
      colorList.fillRange(0, colorList.length,p);
    }

    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        child: Container(
            width: width * 0.9,
            height: height * 0.23,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Container(
                        width: width * 0.3,
                        height: height * 0.035,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 221, 137, 189),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                          child: Text(
                            "산책 목표 달성률",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'bmjua',
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10, top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [Text(
                          "${widget.this_data}",
                          style: const TextStyle(
                              fontFamily: 'bmjua',
                              fontSize: 26,
                              color: Color.fromARGB(255, 221, 137, 189)),
                        ),
                          const Text(
                            "%",
                            style: TextStyle(
                                fontFamily: 'bmjua',
                                fontSize: 18,
                                color: Color.fromARGB(255, 221, 137, 189)),
                          ),

                      ]
                      ),
                    ),
                  ],
                ),

                // 그래프
                Center(
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
                          ProgressWidget(color: colorList[index++]),
                          ProgressWidget(color: colorList[index++]),
                          ProgressWidget(color: colorList[index++]),
                          ProgressWidget(color: colorList[index++]),
                          ProgressWidget(color: colorList[index++]),
                          ProgressWidget(color: colorList[index++]),
                          ProgressWidget(color: colorList[index++]),
                          ProgressWidget(color: colorList[index++]),
                          ProgressWidget(color: colorList[index++]),
                          ProgressWidget(color: colorList[index]),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 5),
                  child: Column(
                    children: [
                      const SizedBox(height: 15,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "저번${widget.date_text}보다 목표 산책 달성량이 ",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'bmjua',
                                color: grey),
                          ),
                          Text(
                            "${widget.last_data}% ",
                            style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'bmjua',
                                color: Color.fromARGB(255, 221, 137, 189)),
                          ),
                          Text(
                            "${widget.message}",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'bmjua',
                                color: grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
