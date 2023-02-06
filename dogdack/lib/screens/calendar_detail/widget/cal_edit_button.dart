import 'package:flutter/material.dart';

class CalEditButtonWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Container(
      child: IconButton(
        icon: Icon(Icons.edit),
        color: Color.fromARGB(255, 80, 78, 91),
        onPressed: (){}, // 편집 화면으로 가야 함
      ),

    );
  }
}
