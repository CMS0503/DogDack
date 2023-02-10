import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';

class HomePageBarChart extends StatefulWidget {
  const HomePageBarChart({Key? key}) : super(key: key);

  @override
  State<HomePageBarChart> createState() => _HomePageBarChartState();
}

class _HomePageBarChartState extends State<HomePageBarChart> {
  //Duration
  final Duration animDuration = const Duration(microseconds: 100);

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
          color: isTouched ? Colors.blueAccent : Colors.black26,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.green)
              : const BorderSide(color: Colors.white, width: 0),
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

  // 데이터 리스트
  List<BarChartGroupData> showingGroups() => List.generate(25, (i) {
    switch (i) {
      case 0: return makeGroupData(0, homeChartController.timeWalkCntList.elementAt(0));
      case 1: return makeGroupData(1, homeChartController.timeWalkCntList.elementAt(1));
      case 2: return makeGroupData(2, homeChartController.timeWalkCntList.elementAt(2));
      case 3: return makeGroupData(3, homeChartController.timeWalkCntList.elementAt(3));
      case 4: return makeGroupData(4, homeChartController.timeWalkCntList.elementAt(4));
      case 5: return makeGroupData(5, homeChartController.timeWalkCntList.elementAt(5));
      case 6: return makeGroupData(6, homeChartController.timeWalkCntList.elementAt(6));
      case 7: return makeGroupData(7, homeChartController.timeWalkCntList.elementAt(7));
      case 8: return makeGroupData(8, homeChartController.timeWalkCntList.elementAt(8));
      case 9: return makeGroupData(9, homeChartController.timeWalkCntList.elementAt(9));
      case 10: return makeGroupData(10, homeChartController.timeWalkCntList.elementAt(10));
      case 11: return makeGroupData(11, homeChartController.timeWalkCntList.elementAt(11));
      case 12: return makeGroupData(12, homeChartController.timeWalkCntList.elementAt(12));
      case 13: return makeGroupData(13, homeChartController.timeWalkCntList.elementAt(13));
      case 14: return makeGroupData(14, homeChartController.timeWalkCntList.elementAt(14));
      case 15: return makeGroupData(15, homeChartController.timeWalkCntList.elementAt(15));
      case 16: return makeGroupData(16, homeChartController.timeWalkCntList.elementAt(16));
      case 17: return makeGroupData(17, homeChartController.timeWalkCntList.elementAt(17));
      case 18: return makeGroupData(18, homeChartController.timeWalkCntList.elementAt(18));
      case 19: return makeGroupData(19, homeChartController.timeWalkCntList.elementAt(19));
      case 20: return makeGroupData(20, homeChartController.timeWalkCntList.elementAt(20));
      case 21: return makeGroupData(21, homeChartController.timeWalkCntList.elementAt(21));
      case 22: return makeGroupData(22, homeChartController.timeWalkCntList.elementAt(22));
      case 23: return makeGroupData(23, homeChartController.timeWalkCntList.elementAt(23));
      case 24: return makeGroupData(24, homeChartController.timeWalkCntList.elementAt(24));
      default: return throw Error();
    }
  });

  // 새로고침
  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(animDuration);
    await refreshState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: GetBuilder<HomePageBarChartController> (
        builder: (_) {
          print('00000000000000000000000000 : ${homeChartController.timeWalkCntList.elementAt(0)}');
          return BarChart(walkData(), swapAnimationDuration: animDuration);
        },
      ),
    );
  }
}