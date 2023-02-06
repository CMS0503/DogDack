import 'package:flutter/material.dart';

class CalDetailTitleWidget extends StatefulWidget {
  final title;
  final name;

  CalDetailTitleWidget({required this.title, required this.name});

  @override
  State<CalDetailTitleWidget> createState() => _CalDetailTitleWidgetState();
}

class _CalDetailTitleWidgetState extends State<CalDetailTitleWidget> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: <Widget>[
          Container(
            width: 5,
            height: 36,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 100, 92, 170),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20)
            ,child: Text(
              "${widget.name} ${widget.title}",
              style: TextStyle(
                fontFamily: 'bmjua',
                fontSize: 32,
                color: Color.fromARGB(255, 100, 92, 170)
              ),
            ),
          )
        ],
      ),
    );
  }
}
