import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/home_controller.dart';
import 'package:dogdack/screens/home/widget/calculator_week.dart';
import 'package:dogdack/screens/home/widget/calendar_list_detail.dart';
import 'package:dogdack/screens/home/widget/week_cal_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/mypage_controller.dart';
import '../../../controllers/user_controller.dart';

class CalenderListView extends StatefulWidget {
  CalenderListView({super.key});

  @override
  State<CalenderListView> createState() => _CalenderListViewState();
}

class _CalenderListViewState extends State<CalenderListView> {
  //GetXController
  final homeCalendarController = Get.put(HomePageCalendarController());
  final userController = Get.put(UserController());

  //현재 확인 중인 주가 오늘이 속해있는 주라면 오른쪽(미래) 이동 버튼을 비활성화 하기 위해 다음 플래그 변수를 사용함.
  //endOfWeek == true(초기 상태) : 오늘이 속한 주를 확인 중 이므로 오른쪽 이동 버튼 비활성화
  //endOfWeek == false : 과거 주를 확인 중이므로 오른쪽 이동 버튼 활성화
  bool endOfWeek = true;

  //토요일 기준 몇년 몇월 몇주차인지
  int satYear = 0;
  int satMonth = 0;
  int satWeek = 0;

  //현재를 기준으로 왼쪽 화살표를 몇 번 눌렀는가 카운트
  //왼쪽 화살표 1씩 증가, 오른쪽 화살표 1씩 감소
  //미래 이동 불가 -> leftBtnCnt = 0 이 최솟값
  int btnManagerIdx = 0;

  void updateHomeCalendarVar(int btnManagerIdx) {
    var _today = DateTime.now(); // 오늘 날짜
    var _varDayDuration = Timestamp.fromDate(_today.subtract(Duration(days: btnManagerIdx * 7))); // 토요일 날짜를 담을 변수
    var _searchDay = Timestamp.fromDate(_varDayDuration.toDate().add(Duration(days: 0)));

    for(int i = 0; i < 7; i++) { // 1일씩 더해가면서 토요일인 날짜를 찾음
      _searchDay = Timestamp.fromDate(_varDayDuration.toDate().add(Duration(days: i)));
      String _searchDayWeek = DateFormat.E().format(_searchDay.toDate()).toString();
      if(_searchDayWeek.compareTo('Sat') == 0)
        break;
    }

    //일월화수목금토 실제 날짜를 찾아서 저장
    homeCalendarController.saturday = Timestamp.fromDate(_searchDay.toDate().subtract(Duration(days: 0))).toDate();
    homeCalendarController.friday = Timestamp.fromDate(_searchDay.toDate().subtract(Duration(days: 1))).toDate();
    homeCalendarController.thursday = Timestamp.fromDate(_searchDay.toDate().subtract(Duration(days: 2))).toDate();
    homeCalendarController.wednesday = Timestamp.fromDate(_searchDay.toDate().subtract(Duration(days: 3))).toDate();
    homeCalendarController.tuesday = Timestamp.fromDate(_searchDay.toDate().subtract(Duration(days: 4))).toDate();
    homeCalendarController.monday = Timestamp.fromDate(_searchDay.toDate().subtract(Duration(days: 5))).toDate();
    homeCalendarController.sunday = Timestamp.fromDate(_searchDay.toDate().subtract(Duration(days: 6))).toDate();

    //토요일이 몇년 몇월 몇주차에 해당하는지
    satYear = homeCalendarController.saturday.year;
    satMonth = homeCalendarController.saturday.month;
    satWeek = CalculatorWeek().weekOfMonthForStandard(homeCalendarController.saturday);
  }

  Future<dynamic> delayState() async {
    homeCalendarController.isAutoFlag = false;
    homeCalendarController.autoFlagUpdate();
    await Future<dynamic>.delayed(const Duration(milliseconds: 5000));
    homeCalendarController.isAutoFlag = true;
    homeCalendarController.autoFlagUpdate();
  }

  @override
  void initState() {
    super.initState();
    updateHomeCalendarVar(btnManagerIdx);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(size.width * 0.1, 0, size.width * 0.1, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                InkWell(
                  child: Icon(Icons.arrow_circle_left_outlined, size: size.width * 0.1, color: Color(0xff644CAA),),
                  onTap: () {
                    btnManagerIdx++;
                    endOfWeek = false;
                    setState(() {
                      updateHomeCalendarVar(btnManagerIdx);
                    });
                    delayState();
                  },
                ),
                Text('${satYear}년 ${satMonth}월 ${satWeek}주차 발자취',
                style: TextStyle(
                  fontSize: 18
                ),),
                !endOfWeek
                  ? InkWell(
                      child: Icon(Icons.arrow_circle_right_outlined, size: size.width * 0.1, color: Color(0xff644CAA),),
                      onTap: () {
                        btnManagerIdx--;
                        if(btnManagerIdx == 0) {
                          endOfWeek = true;
                        }
                        if(btnManagerIdx < 0) {
                          btnManagerIdx = 0;
                        }
                        setState(() {
                            updateHomeCalendarVar(btnManagerIdx);
                          });
                          delayState();
                        },
                      )
                    : Icon(
                        Icons.arrow_circle_right_outlined,
                        size: size.width * 0.1,
                        color: Colors.grey,
                      ),
              ],
            ),
          ),
          SizedBox(height: 10),
          CalendarListDetail(),

          // CalIconWidget()
        ],
      ),
    );
  }
}