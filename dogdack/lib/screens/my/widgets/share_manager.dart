import 'package:flutter/material.dart';

class ShareManager extends StatefulWidget {
  const ShareManager({Key? key}) : super(key: key);

  @override
  State<ShareManager> createState() => _ShareManagerState();
}

class _ShareManagerState extends State<ShareManager> {


  @override
  Widget build(BuildContext context) {
    // 디바이스 사이즈 크기 정의
    final Size size = MediaQuery.of(context).size;

    // 반려견 정보 표시 카드의 너비, 높이 정의
    final double petInfoWidth = size.width * 0.8;
    final double petInfoHeight = size.height * 0.15;

    return Container(
      child: Center(
        child: Container(
          height: petInfoHeight,
          width: petInfoWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                blurRadius: 5.0,
                spreadRadius: 0.0,
                offset: const Offset(0, 7),
              )
            ],
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(petInfoWidth * 0.05, 0, petInfoWidth * 0.05, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {

                    },
                    child: Text('공유 계정 로그인'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xff646CAA)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {

                    },
                    child: Text('공유 계정 설정'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xff646CAA)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
