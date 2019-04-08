import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "paht",
      home: SafeArea(child: buildScaffold()),
    );
  }

  Scaffold buildScaffold() {
    return Scaffold(
      appBar: AppBar(),
      body: buildMainPage(),
    );
  }

  Container buildMainPage() {
    return Container(
      color: Colors.lightGreen,
      child: Center(
        child: loadingBorderWidget(),
      ),
    );
  }

  Widget loadingBorderWidget() {
    return Container(
      width: 300,
      height: 80,
      child: CustomPaint(
          painter: MyPainter(),
          child: Center(
            child: Text("hi"),
          )),
    );
  }
}

enum offsetPlace {
  topLine,
  topRight,
  rightLine,
  bottomRight,
  bottomLine,
  bottomLeft,
  leftLine,
  topLeft
}

class MyPainter extends CustomPainter {


  @override
  void paint(Canvas canvas, Size size) {
    var height = size.height;
    var width = size.width;
    var fEmptySpaceSize = 15.0;
    var borderRadius = 7.0;
    var widthLineSize = width - (2 * borderRadius);
    var heightLineSize = height - (2 * borderRadius);
    var arcSize = (pi * borderRadius) / 2; // 2 * (pi * borderRadius) / 4
    var arcAngles = (pi / 2) / arcSize;

    var topLineOffset = widthLineSize;
    var topRightOffset = topLineOffset + arcSize;

    var rightLineOffset = topRightOffset + heightLineSize;

    var bottomRightOffset = rightLineOffset + arcSize;
    var bottomLineOffset = bottomRightOffset + widthLineSize;
    var bottomLeftOffset = bottomLineOffset + arcSize;

    var leftLineOffset = bottomLeftOffset + heightLineSize;

    var topLeftOffset = leftLineOffset + arcSize;

    // rightLineOffset should be equal to maxOffset

    double linesMaxOffs = widthLineSize * 2 + heightLineSize * 2;
    double arcsMaxOffs = arcSize * 4;
    double maxOffset = topLeftOffset;

    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    createFrame(canvas, width, height, borderRadius);
  }

  void createFrame(
      Canvas canvas, double width, double height, double borderRadius) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawRRect(
        RRect.fromLTRBR(0, 0, width, height, Radius.circular(borderRadius)),
        paint);
  }

  void findOffsetPlace(double offset){

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
