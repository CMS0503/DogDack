import 'package:flutter/material.dart';

class CalDetailTextWidget extends StatefulWidget {
  final title;
  final text;


  CalDetailTextWidget({required this.title, required this.text});

  @override
  State<CalDetailTextWidget> createState() => _CalDetailTextWidgetState();
}

class _CalDetailTextWidgetState extends State<CalDetailTextWidget> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Column(
      children: <Widget>[
        Container(
            width: width * 0.2,
            height: height * 0.03,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 100, 92, 170),
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Text(
                "${widget.title}",
                style: TextStyle(
                  fontFamily: 'bmjua',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            )),
        Padding(
          padding: EdgeInsets.only(top: 3),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 5),
                child:  Container(
                  width: width * 0.25,
                  height: height * 0.02,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color.fromARGB(255, 100, 92, 170)))),
                  child: Container(
                    child: Text(
                      "${widget.text}",
                      style: TextStyle(
                        fontFamily: 'bmjua',
                        fontSize: 14,
                        color: Color.fromARGB(255, 80, 78, 91),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ],
    );
  }
}
