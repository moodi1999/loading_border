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
          painter: MyPainter(80, 300),
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
  double height;
  double width;
  double borderRadius;
  double widthLineSize;
  double heightLineSize;
  double arcSize;
  double fEmptySpaceSize = 15.0;

  double topLineOffset;
  double topRightOffset;
  double rightLineOffset;
  double bottomRightOffset;
  double bottomLineOffset;
  double bottomLeftOffset;
  double leftLineOffset;
  double topLeftOffset;

  double arcAngles;

  Path path;

  MyPainter(this.height, this.width) {
    borderRadius = 7.0;
    widthLineSize = width - (2 * borderRadius);
    heightLineSize = height - (2 * borderRadius);
    arcSize = (pi * borderRadius) / 2; // 2 * (pi * borderRadius) / 4
    arcAngles = (pi / 2) / arcSize;

    topLineOffset = widthLineSize;
    topRightOffset = topLineOffset + arcSize;

    rightLineOffset = topRightOffset + heightLineSize;

    bottomRightOffset = rightLineOffset + arcSize;
    bottomLineOffset = bottomRightOffset + widthLineSize;
    bottomLeftOffset = bottomLineOffset + arcSize;

    leftLineOffset = bottomLeftOffset + heightLineSize;

    topLeftOffset = leftLineOffset + arcSize;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // rightLineOffset should be equal to maxOffset

    double linesMaxOffs = widthLineSize * 2 + heightLineSize * 2;
    double arcsMaxOffs = arcSize * 4;
    double maxOffset = topLeftOffset;

    path = Path();
    path.moveTo(borderRadius, 0);
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    double a = 0;
    double b = 280;
    // a -> b

    double c;
    double d;
    // c -> d

    double e;
    // e -> a

//    var aPlace = findOffsetPlace(a);
//    var bPlace = findOffsetPlace(b);
//    var cPlace = findOffsetPlace(c);
//    var dPlace = findOffsetPlace(d);
//    var ePlace = findOffsetPlace(e);

    draw(a, b);

    createFrame(canvas, width, height, borderRadius);
    canvas.drawPath(path, paint);
  }

  void draw(double firstPointOffset, double endPointOffset) {
    var firstPointPlace = findOffsetPlace(firstPointOffset);
    var endPointPlace = findOffsetPlace(endPointOffset);
    var tempOffset;
    if (firstPointPlace == offsetPlace.topLine) {
      //
      path.moveTo(borderRadius + firstPointOffset, 0);
      //
      switch (endPointPlace) {
        case offsetPlace.topLine:
          path.lineTo(borderRadius + firstPointOffset, 0);
          break;
        case offsetPlace.topRight:
          tempOffset = endPointOffset - topLineOffset;
          arcToPoint(offsetPlace.topRight, tempOffset);
          break;
        case offsetPlace.rightLine:
          break;
        case offsetPlace.bottomRight:
          break;

        case offsetPlace.bottomLine:
          break;
        case offsetPlace.bottomLeft:
          break;
        case offsetPlace.leftLine:
          break;
        case offsetPlace.topLeft:
      }
    } else if (firstPointPlace == offsetPlace.topRight) {}
  }

  void arcToPoint(
    offsetPlace arcPlace,
    double arcSize,
  ) {
    var tempPi;
    var tempX;
    var tempY;
    switch (arcPlace) {
      case offsetPlace.topRight:
        tempPi = pi / 2;
        break;
      case offsetPlace.bottomRight:
        tempPi = 2 * pi;

        break;
      case offsetPlace.bottomLeft:
        tempPi = (3 * pi) / 2;

        break;
      case offsetPlace.topLeft:
        tempPi = (pi / 2);
        break;

      default:
        break;
    }

    var arcPointCor =
        findPointOnArc(borderRadius, tempPi - (arcSize * arcAngles));

    double x = tempX + arcPointCor.dx.abs();
    double y = tempY + arcPointCor.dy.abs();

    path.arcToPoint(Offset(x.abs(), y.abs()),
        radius: Radius.circular(borderRadius));
  }

  void drawLine(offsetPlace linePlace) {}

  Offset findPointOnArc(radius, angle) {
    return Offset(radius * cos(angle), radius * sin(angle));
  }

  offsetPlace findOffsetPlace(double offset) {
    if (offset <= topLineOffset) {
      return offsetPlace.topLine;
    } else if (offset <= topRightOffset) {
      return offsetPlace.topRight;
    } else if (offset <= rightLineOffset) {
      return offsetPlace.rightLine;
    } else if (offset <= bottomRightOffset) {
      return offsetPlace.bottomRight;
    } else if (offset <= bottomLineOffset) {
      return offsetPlace.bottomLine;
    } else if (offset <= bottomLeftOffset) {
      return offsetPlace.bottomLeft;
    } else if (offset <= leftLineOffset) {
      return offsetPlace.leftLine;
    } else {
      return offsetPlace.topLeft;
    }
  }

  void createFrame(
      Canvas canvas, double width, double height, double borderRadius) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    canvas.drawRRect(
        RRect.fromLTRBR(0, 0, width, height, Radius.circular(borderRadius)),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
