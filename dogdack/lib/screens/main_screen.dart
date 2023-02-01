import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//navigator
import 'package:dogdack/navigators/home_navigator.dart';
import 'package:dogdack/navigators/calender_navigator.dart';
import 'package:dogdack/navigators/walk_navigator.dart';
import 'package:dogdack/navigators/mypage_navigator.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentTabIndex = 0;

  void _tabSelect(int tabIndex) {
    setState(() {
      _currentTabIndex = tabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Stack(children: [
        Offstage(
          offstage: _currentTabIndex != 0,
          child: const HomeNavigator(tabIndex: 0),
        ),
        Offstage(
          offstage: _currentTabIndex != 1,
          child: const CalenderNavigator(tabIndex: 1),
        ),
        Offstage(
          offstage: _currentTabIndex != 2,
          child: const WalkNavigator(tabIndex: 2),
        ),
        Offstage(
          offstage: _currentTabIndex != 3,
          child: const MyPageNavigator(tabIndex: 3),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '캘린더',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            label: '산책',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 100, 92, 170),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        unselectedLabelStyle: const TextStyle(fontFamily: 'bmjua'),
        selectedLabelStyle: const TextStyle(fontFamily: 'bmjua'),
        elevation: 0,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentTabIndex,
        onTap: (value) => _tabSelect(value),
      ),
    );
  }
}
