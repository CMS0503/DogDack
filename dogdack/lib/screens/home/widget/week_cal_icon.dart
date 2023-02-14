import 'package:dogdack/screens/chart/widget/progress_graph.dart';
import 'package:flutter/material.dart';

class CalIconWidget extends StatefulWidget {
  Color calColor;
  Color iconClolor;
  CalIconWidget({required this.calColor, required this.iconClolor});

  @override
  State<CalIconWidget> createState() => _CalIconWidgetState();
}

class _CalIconWidgetState extends State<CalIconWidget> {




  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          width: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 5,
                height: 6,
                decoration: BoxDecoration(
                  color: widget.calColor,
                ),
              ),
              Container(
                width: 5,
                height: 6,
                decoration: BoxDecoration(
                  color: widget.calColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 47,
          height: 47,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: widget.calColor, width: 4),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(children: [
            SizedBox(
              height: 8,
            ),
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: widget.calColor,
              ),
            ),
            Icon(
              Icons.pets_outlined,
              size: 25,
              color: widget.iconClolor,
            )
          ]),
        ),
      ],
    );
  }
}
