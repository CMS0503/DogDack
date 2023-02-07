import 'package:flutter/material.dart';


class PetProfileWidget extends StatefulWidget {
  String name;
  num birth;
  PetProfileWidget({required this.name, required this.birth});


  @override
  State<PetProfileWidget> createState() => _PetProfileWidget();
}

class _PetProfileWidget extends State<PetProfileWidget> {

  TextStyle gery_style = TextStyle(
    fontFamily: 'bmjua',
    color: Color.fromARGB(255, 80, 78, 91),
    fontSize: 18,
  );

  TextStyle violet_style = TextStyle(
    fontFamily: 'bmjua',
    fontSize: 24,
    color :  Color.fromARGB(255, 100, 92, 170)
  );

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return  Container(
      width: width,
      height: height * 0.07,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("${widget.name}", style: violet_style,),
          Text("함께한지 ${widget.birth}일", style: gery_style,)

        ],

      ),
    );
  }
}
