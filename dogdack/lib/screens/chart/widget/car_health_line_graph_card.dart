import 'package:dogdack/screens/chart/widget/line_chart_page.dart';
import 'package:flutter/material.dart';


class CalHealthCardWidget extends StatefulWidget {
  Color color;
  String title;
  String message;
  double this_data;
  double last_data;
  String date_text;
  String unit;
  Widget x_value;

  List<double> points;

  CalHealthCardWidget(
      {required this.color,
      required this.title,
      required this.message,
      required this.points,
      required this.this_data,
      required this.last_data,
      required this.date_text,
      required this.unit,
      required this.x_value});

  @override
  State<CalHealthCardWidget> createState() => _CalHealthCardWidget();
}

class _CalHealthCardWidget extends State<CalHealthCardWidget> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    Color grey = Color.fromARGB(255, 80, 78, 91);
    int day = 0;

    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        child: Container(
            width: width * 0.9,
            height: height * 0.28,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Container(
                        width: width * 0.3,
                        height: height * 0.035,
                        decoration: BoxDecoration(
                            color: widget.color,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            "${widget.title}",
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
                          children: <Widget>[

                        Text(
                          "${widget.this_data}",
                          style: TextStyle(
                              fontFamily: 'bmjua',
                              fontSize: 26,
                              color: widget.color),
                        ),
                        Text(
                          "${widget.unit}",
                          style: TextStyle(
                              fontFamily: 'bmjua',
                              fontSize: 18,
                              color: widget.color),
                        ),
                      ]),
                    ),
                  ],
                ),
                // 그래프
                ChartPage(graph_coolor: widget.color, points: widget.points),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Center(child: widget.x_value),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10, bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "저번${widget.date_text}보다 ${widget.title} ",
                        style: TextStyle(
                            fontSize: 14, fontFamily: 'bmjua', color: grey),
                      ),
                      Text(
                        "${widget.last_data}${widget.unit} ",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'bmjua',
                            color: widget.color),
                      ),
                      Text(
                        "${widget.message}",
                        style: TextStyle(
                            fontSize: 14, fontFamily: 'bmjua', color: grey),
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
