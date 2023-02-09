import 'package:dogdack/screens/chart/widget/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartPage extends StatefulWidget {
  Color graph_coolor;
  List<double> points;

  ChartPage({required this.graph_coolor, required this.points});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Container(
      padding: EdgeInsets.only(top:10),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
                width: width * 0.7,
                height: height * 0.15,
                child:  CustomPaint(
                  size: Size(300, 300),
                  painter: LineChart(
                    // points: day_points,
                    points: widget.points,
                    pointSize: 5.0,
                    pointColor: widget.graph_coolor,
                    lineColor: widget.graph_coolor,
                    lineWidth: 3.0,
                    maxValueIndex: 0,
                    minValueIndex: 0,
                  ),
                ),

            ),
          ],
        ),
      ),
    );
  }
}
