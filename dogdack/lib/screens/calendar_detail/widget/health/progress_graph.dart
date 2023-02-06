import 'package:flutter/material.dart';

class ProgressWidget extends StatefulWidget {

  Color color;
  ProgressWidget({required this.color});
  @override
  State<ProgressWidget> createState() =>
      _ProgressWidget();
}

class _ProgressWidget extends State<ProgressWidget> {


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return  Container(
        width: width * 0.03,
        height: height * 0.06,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(20),
        ),
      );
  }
}
