import 'package:dogdack/screens/calendar_detail/widget/walk/cal_walk_text.dart';
import 'package:flutter/material.dart';


class DiaryWidget extends StatefulWidget {
  String diary_image;
  String? diary_text;

  DiaryWidget({required this.diary_image, required this.diary_text});



  @override
  State<DiaryWidget> createState() => _DiaryWidget();
}

class _DiaryWidget extends State<DiaryWidget> {

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    Color grey = Color.fromARGB(255, 80, 78, 91);
    return   Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        child: Container(
          width: width * 0.9,
          height: height * 0.25,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  child: Image.network(widget.diary_image, loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){
                    if(loadingProgress == null){
                      return child;
                    }
                    return Center(
                      child: Image.asset('images/login/login_image.png')
                    );
                  },
                  ),),
                // child: Container(
                //   width: 130,
                //   height: 130,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //   ),
                //   child: Image.network(widget.diary_image, height: 130, width: 130,loadingBuilder: ,)
                // ),
              ),
              Text("${widget.diary_text}", style: TextStyle(
                fontFamily: 'bmjua',
                color: grey,
                fontSize: 18
              ),)

            ],
          ),
        ),
      ),
    );
  }
}
