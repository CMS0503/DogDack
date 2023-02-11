import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';

class HomePageBarChart extends StatefulWidget {
  HomePageBarChart({super.key});

  @override
  State<HomePageBarChart> createState() => _HomePageBarChartState();
}

class _HomePageBarChartState extends State<HomePageBarChart> {
  final Duration animDuration = const Duration(milliseconds: 500);

  //GetXController
  final homeChartController = Get.put(HomePageBarChartController());

  // 하단 타이틀 명 : 6시 12시 6시
  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff504E5B),
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 6: text = const Text('6am', style: style); break;
      case 12: text = const Text('12pm', style: style); break;
      case 18: text = const Text('6pm', style: style); break;
      default: text = const Text('', style: style); break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  // 그래프 수치 데이터
  BarChartData walkData() {
    return BarChartData(
      //그래프를 터치했을 때 데이터가 나오지 않도록 함
      barTouchData: BarTouchData(enabled: false),
      //그래프 하단에 데이터 정보가 나오도록 함
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 50,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      //테두리가 없도록 함
      borderData: FlBorderData(
        show: false,
      ),
      //실제 데이터가 입력된 부분
      barGroups: showingGroups(),
      //??
      gridData: FlGridData(show: false),
    );
  }

  // 그룹을 만드는 함수
  BarChartGroupData makeGroupData(int x, double y, {bool isTouched = false, Color? barColor, double width = 5, List<int> showTooltips = const [],}) {
    barColor ??= Colors.pink;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: Color(0xff644CAA),
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: Colors.white,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  //막대 그래프 y 축 데이터
  List<BarChartGroupData> showingGroups() {
    //반환할 리스트
    List<BarChartGroupData> retList = [];

    //y축 데이터가 0일 때 기본으로 보여줄 막대 그래프의 길이를 정의
    double initYAxisData = 5.0;
    //실제로 보여줄 막대 그래프 y축 데이터의 길이
    List<double> yList = List.filled(25, initYAxisData);
    for(int i = 0; i < 25; i++) {
      yList[i] += homeChartController.timeWalkCntList.elementAt(i);
    }

    //반환할 리스트 업데이트
    for(int i = 0; i < 25; i++) {
      retList.add(makeGroupData(i, yList.elementAt(i)));
    }

    return retList;
  }

  // 새로고침
  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(animDuration + const Duration(milliseconds: 100));
    await refreshState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    refreshState();
    return Container(
      height: size.height * 0.12,
      child: BarChart(walkData(), swapAnimationDuration: animDuration),
    );
  }
}