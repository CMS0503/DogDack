import 'package:flutter/material.dart';

class CalDetailDateWidget extends StatefulWidget {
  final time;

  CalDetailDateWidget({required this.time});

  @override
  State<CalDetailDateWidget> createState() => _CalDetailDateWidget();
}

class _CalDetailDateWidget extends State<CalDetailDateWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(
      "${widget.time}",
      style: TextStyle(
          fontFamily: 'bmjua',
          fontSize: 16,
          color: Color.fromARGB(255, 80, 78, 91)),
    );
  }
}
