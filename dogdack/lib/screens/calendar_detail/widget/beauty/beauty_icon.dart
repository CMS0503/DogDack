import 'package:flutter/material.dart';

class BeautyWidget extends StatefulWidget {
  Color hair_color;
  Color bath_color;

  BeautyWidget({required this.hair_color, required this.bath_color});

  @override
  State<BeautyWidget> createState() => _BeautyWidgetState();
}

class _BeautyWidgetState extends State<BeautyWidget> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    return Row(
      children: <Widget>[
        // 목욕
        Padding(
          padding: EdgeInsets.only(left: 30, right: 7),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: widget.bath_color, width: 3)),
            child:  Icon(
              Icons.bathtub_outlined,
              color: widget.hair_color,
            ),
          ),



        ),
        // 헤어
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle, border: Border.all(color: widget.hair_color, width: 3)),
          child:  Icon(
            Icons.cut_outlined,
            color: widget.hair_color,
          ),

        ),

      ],
    );
  }
}
