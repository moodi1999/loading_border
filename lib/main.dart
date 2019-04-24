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

    double offset = 100;

    double a = 0;
    double b = topLineOffset ;
    // a -> b

    double c = b + 10;
    double d = c + 100;

    // c -> d

    double e = d + 10;
    double f = e + 200;
    // e -> a

//    var aPlace = findOffsetPlace(a);
//    var bPlace = findOffsetPlace(b);
//    var cPlace = findOffsetPlace(c);
//    var dPlace = findOffsetPlace(d);
//    var ePlace = findOffsetPlace(e);

    draw(a, b);
    draw(c, d);
    draw(e, f);
    draw(f, topLeftOffset - 4);

    createFrame(canvas, width, height, borderRadius);
    canvas.drawPath(path, paint);
  }

  void draw(double firstPointOffset, double endPointOffset) {
    var firstPointPlace = findOffsetPlace(firstPointOffset);
    var endPointPlace = findOffsetPlace(endPointOffset);
    print(firstPointPlace);
    print(endPointPlace);

    var tempOffset;
    if (firstPointPlace == offsetPlace.topLine) {
      path.moveTo(borderRadius + firstPointOffset, 0);
      checkTopLine(endPointPlace, firstPointOffset, tempOffset, endPointOffset);
    } else if (firstPointPlace == offsetPlace.topRight) {
      var tempOffset = firstPointOffset - topLineOffset;
      gotToPointOnArc(offsetPlace.topRight, tempOffset);

      checkTopRight(
          endPointPlace, firstPointOffset, tempOffset, endPointOffset);
    } else if (firstPointPlace == offsetPlace.rightLine) {
      var tempOffset = firstPointOffset - topRightOffset;
      path.moveTo(width, borderRadius + tempOffset);

      checkRightLine(
          endPointPlace, firstPointOffset, tempOffset, endPointOffset);
    } else if (firstPointPlace == offsetPlace.bottomRight) {
      var tempOffset = firstPointOffset - rightLineOffset;
      gotToPointOnArc(offsetPlace.bottomRight, tempOffset);

      checkBottomRight(
          endPointPlace, firstPointOffset, tempOffset, endPointOffset);
    } else if (firstPointPlace == offsetPlace.bottomLine) {
      var tempOffset = firstPointOffset - bottomRightOffset;
      path.moveTo((width - borderRadius) - tempOffset, height);

      checkBottomLine(
          endPointPlace, firstPointOffset, tempOffset, endPointOffset);
    } else if (firstPointPlace == offsetPlace.bottomLeft) {
      var tempOffset = firstPointOffset - bottomLineOffset;
      gotToPointOnArc(offsetPlace.bottomLeft, tempOffset);

      checkBottomLeft(
          endPointPlace, firstPointOffset, tempOffset, endPointOffset);
    } else if (firstPointPlace == offsetPlace.leftLine) {
      var tempOffset = firstPointOffset - bottomLeftOffset;
      path.moveTo(0, (height - borderRadius) - tempOffset);

      checkLeftLine(
          endPointPlace, firstPointOffset, tempOffset, endPointOffset);
    } else if (firstPointPlace == offsetPlace.topLeft) {
      var tempOffset = firstPointOffset - leftLineOffset;
      gotToPointOnArc(offsetPlace.topLeft, tempOffset);

      checkTopLeft(endPointPlace, firstPointOffset, tempOffset, endPointOffset);
    }
  }

  void checkTopLine(offsetPlace endPointPlace, double firstPointOffset,
      tempOffset, double endPointOffset) {
    switch (endPointPlace) {
      case offsetPlace.topLine:
        if (firstPointOffset <= endPointOffset) {
          path.lineTo(borderRadius + endPointOffset, 0);
        } else {
          createTopLine();
          createTopRightArc();
          createRightLine();
          createBottomRightArc();
          createBottomLine();
          createBottomLeftArc();
          createLeftLine();
          createTopLeftArc();
          path.lineTo(borderRadius + endPointOffset, 0);
        }
        break;
      case offsetPlace.topRight:
        createTopLine();
        tempOffset = endPointOffset - topLineOffset;
        arcToPoint(offsetPlace.topRight, tempOffset);
        break;
      case offsetPlace.rightLine:
        createTopLine();
        createTopRightArc();
        tempOffset = endPointOffset - topRightOffset;
        path.lineTo(width, borderRadius + tempOffset);
        break;
      case offsetPlace.bottomRight:
        createTopLine();
        createTopRightArc();
        createRightLine();
        tempOffset = endPointOffset - rightLineOffset;
        arcToPoint(offsetPlace.bottomRight, tempOffset);
        break;
      case offsetPlace.bottomLine:
        createTopLine();
        createTopRightArc();
        createRightLine();
        createBottomRightArc();
        tempOffset = endPointOffset - bottomRightOffset;
        path.lineTo((width - borderRadius) - tempOffset, height);
        break;
      case offsetPlace.bottomLeft:
        createTopLine();
        createTopRightArc();
        createRightLine();
        createBottomRightArc();
        createBottomLine();
        tempOffset = endPointOffset - bottomLineOffset;
        arcToPoint(offsetPlace.bottomLeft, tempOffset);
        break;
      case offsetPlace.leftLine:
        createTopLine();
        createTopRightArc();
        createRightLine();
        createBottomRightArc();
        createBottomLine();
        createBottomLeftArc();
        tempOffset = endPointOffset - bottomLeftOffset;
        path.lineTo(0, (height - borderRadius) - tempOffset);
        break;
      case offsetPlace.topLeft:
        createTopLine();
        createTopRightArc();
        createRightLine();
        createBottomRightArc();
        createBottomLine();
        createBottomLeftArc();
        createLeftLine();
        tempOffset = endPointOffset - leftLineOffset;
        arcToPoint(offsetPlace.topLeft, tempOffset);
    }
  }

  void checkTopRight(offsetPlace endPointPlace, double firstPointOffset,
      tempOffset, double endPointOffset) {
    switch (endPointPlace) {
      case offsetPlace.topRight:
        if(firstPointOffset <= endPointOffset){
          tempOffset = endPointOffset - topLineOffset;
          arcToPoint(offsetPlace.topRight, tempOffset);
        }else{
          tempOffset = endPointOffset - topLineOffset;
          print(tempOffset);

          createTopRightArc();
          createRightLine();
          createBottomRightArc();
          createBottomLine();
          createBottomLeftArc();
          createLeftLine();
          createTopLeftArc();
          createTopLine();

          tempOffset = endPointOffset - topLineOffset;
          print(tempOffset);

          arcToPoint(offsetPlace.topRight, tempOffset);
        }

        break;
      case offsetPlace.rightLine:
        createTopRightArc();
        tempOffset = endPointOffset - topRightOffset;
        path.lineTo(width, borderRadius + tempOffset);
        break;
      case offsetPlace.bottomRight:
        createTopRightArc();
        createRightLine();
        tempOffset = endPointOffset - rightLineOffset;
        arcToPoint(offsetPlace.bottomRight, tempOffset);
        break;
      case offsetPlace.bottomLine:
        createTopRightArc();
        createRightLine();
        createBottomRightArc();
        tempOffset = endPointOffset - bottomRightOffset;
        path.lineTo((width - borderRadius) - tempOffset, height);
        break;
      case offsetPlace.bottomLeft:
        createTopRightArc();
        createRightLine();
        createBottomRightArc();
        createBottomLine();
        tempOffset = endPointOffset - bottomLineOffset;
        arcToPoint(offsetPlace.bottomLeft, tempOffset);
        break;
      case offsetPlace.leftLine:
        createTopRightArc();
        createRightLine();
        createBottomRightArc();
        createBottomLine();
        createBottomLeftArc();
        tempOffset = endPointOffset - bottomLeftOffset;
        path.lineTo(0, (height - borderRadius) - tempOffset);
        break;
      case offsetPlace.topLeft:
        createTopRightArc();
        createRightLine();
        createBottomRightArc();
        createBottomLine();
        createBottomLeftArc();
        createLeftLine();
        tempOffset = endPointOffset - leftLineOffset;
        arcToPoint(offsetPlace.topLeft, tempOffset);
        break;
      case offsetPlace.topLine:
        createTopRightArc();
        createRightLine();
        createBottomRightArc();
        createBottomLine();
        createBottomLeftArc();
        createLeftLine();
        createTopLeftArc();
        tempOffset = borderRadius + endPointOffset;
        path.lineTo(tempOffset, 0);
        break;
    }
  }

  void checkRightLine(offsetPlace endPointPlace, double firstPointOffset,
      tempOffset, double endPointOffset) {
    switch (endPointPlace) {
      case offsetPlace.rightLine:
        tempOffset = endPointOffset - topRightOffset;
        path.lineTo(width, borderRadius + tempOffset);
        break;
      case offsetPlace.bottomRight:
        createRightLine();
        tempOffset = endPointOffset - rightLineOffset;
        arcToPoint(offsetPlace.bottomRight, tempOffset);
        break;
      case offsetPlace.bottomLine:
        createRightLine();
        createBottomRightArc();
        tempOffset = endPointOffset - bottomRightOffset;
        path.lineTo((width - borderRadius) - tempOffset, height);
        break;
      case offsetPlace.bottomLeft:
        createRightLine();
        createBottomRightArc();
        createBottomLine();
        tempOffset = endPointOffset - bottomLineOffset;
        arcToPoint(offsetPlace.bottomLeft, tempOffset);
        break;
      case offsetPlace.leftLine:
        createRightLine();
        createBottomRightArc();
        createBottomLine();
        createBottomLeftArc();
        tempOffset = endPointOffset - bottomLeftOffset;
        path.lineTo(0, (height - borderRadius) - tempOffset);
        break;
      case offsetPlace.topLeft:
        createRightLine();
        createBottomRightArc();
        createBottomLine();
        createBottomLeftArc();
        createLeftLine();
        tempOffset = endPointOffset - leftLineOffset;
        arcToPoint(offsetPlace.topLeft, tempOffset);
        break;
      case offsetPlace.topLine:
        createRightLine();
        createBottomRightArc();
        createBottomLine();
        createBottomLeftArc();
        createLeftLine();
        createTopLeftArc();
        path.lineTo(borderRadius + endPointOffset, 0);
        break;
      case offsetPlace.topRight:
        createRightLine();
        createBottomRightArc();
        createBottomLine();
        createBottomLeftArc();
        createLeftLine();
        createTopLeftArc();
        createTopLine();
        tempOffset = endPointOffset - topLineOffset;
        arcToPoint(offsetPlace.topRight, tempOffset);
        break;
    }
  }

  void checkBottomRight(offsetPlace endPointPlace, double firstPointOffset,
      tempOffset, double endPointOffset) {
    switch (endPointPlace) {
      case offsetPlace.bottomRight:
        tempOffset = endPointOffset - rightLineOffset;
        arcToPoint(offsetPlace.bottomRight, tempOffset);
        break;
      case offsetPlace.bottomLine:
        createBottomRightArc();
        tempOffset = endPointOffset - bottomRightOffset;
        path.lineTo((width - borderRadius) - tempOffset, height);
        break;
      case offsetPlace.bottomLeft:
        createBottomRightArc();
        createBottomLine();
        tempOffset = endPointOffset - bottomLineOffset;
        arcToPoint(offsetPlace.bottomLeft, tempOffset);
        break;
      case offsetPlace.leftLine:
        createBottomRightArc();
        createBottomLine();
        createBottomLeftArc();
        tempOffset = endPointOffset - bottomLeftOffset;
        path.lineTo(0, (height - borderRadius) - tempOffset);
        break;
      case offsetPlace.topLeft:
        createBottomRightArc();
        createBottomLine();
        createBottomLeftArc();
        createLeftLine();
        tempOffset = endPointOffset - leftLineOffset;
        arcToPoint(offsetPlace.topLeft, tempOffset);
        break;
      case offsetPlace.topLine:
        createBottomRightArc();
        createBottomLine();
        createBottomLeftArc();
        createLeftLine();
        createTopLeftArc();
        tempOffset = borderRadius + endPointOffset;
        path.lineTo(tempOffset, 0);
        break;
      case offsetPlace.topRight:
        createBottomRightArc();
        createBottomLine();
        createBottomLeftArc();
        createLeftLine();
        createTopLeftArc();
        createTopLine();
        tempOffset = endPointOffset - topLineOffset;
        arcToPoint(offsetPlace.topRight, tempOffset);
        break;
      case offsetPlace.rightLine:
        createBottomRightArc();
        createBottomLine();
        createBottomLeftArc();
        createLeftLine();
        createTopLeftArc();
        createTopLine();
        createTopRightArc();
        tempOffset = endPointOffset - topRightOffset;
        path.lineTo(width, borderRadius + tempOffset);
        break;
    }
  }

  void checkBottomLine(offsetPlace endPointPlace, double firstPointOffset,
      tempOffset, double endPointOffset) {
    switch (endPointPlace) {
      case offsetPlace.bottomLine:
        tempOffset = endPointOffset - bottomRightOffset;
        path.lineTo((width - borderRadius) - tempOffset, height);
        break;
      case offsetPlace.bottomLeft:
        createBottomLine();
        tempOffset = endPointOffset - bottomLineOffset;
        arcToPoint(offsetPlace.bottomLeft, tempOffset);
        break;
      case offsetPlace.leftLine:
        createBottomLine();
        createBottomLeftArc();
        tempOffset = endPointOffset - bottomLeftOffset;
        path.lineTo(0, (height - borderRadius) - tempOffset);
        break;
      case offsetPlace.topLeft:
        createBottomLine();
        createBottomLeftArc();
        createLeftLine();
        tempOffset = endPointOffset - leftLineOffset;
        arcToPoint(offsetPlace.topLeft, tempOffset);
        break;
      case offsetPlace.topLine:
        createBottomLine();
        createBottomLeftArc();
        createLeftLine();
        createTopLeftArc();
        tempOffset = borderRadius + endPointOffset;
        path.lineTo(tempOffset, 0);
        break;
      case offsetPlace.topRight:
        createBottomLine();
        createBottomLeftArc();
        createLeftLine();
        createTopLeftArc();
        createTopLine();
        tempOffset = endPointOffset - topLineOffset;
        arcToPoint(offsetPlace.topRight, tempOffset);
        break;
      case offsetPlace.rightLine:
        createBottomLine();
        createBottomLeftArc();
        createLeftLine();
        createTopLeftArc();
        createTopLine();
        createTopRightArc();
        tempOffset = endPointOffset - topRightOffset;
        path.lineTo(width, borderRadius + tempOffset);
        break;
      case offsetPlace.bottomRight:
        createBottomLine();
        createBottomLeftArc();
        createLeftLine();
        createTopLeftArc();
        createTopLine();
        createTopRightArc();
        createRightLine();
        tempOffset = endPointOffset - rightLineOffset;
        arcToPoint(offsetPlace.bottomRight, tempOffset);
        break;
    }
  }

  void checkBottomLeft(offsetPlace endPointPlace, double firstPointOffset,
      tempOffset, double endPointOffset) {
    switch (endPointPlace) {
      case offsetPlace.bottomLeft:
        tempOffset = endPointOffset - bottomLineOffset;
        arcToPoint(offsetPlace.bottomLeft, tempOffset);
        break;
      case offsetPlace.leftLine:
        createBottomLeftArc();
        tempOffset = endPointOffset - bottomLeftOffset;
        path.lineTo(0, (height - borderRadius) - tempOffset);
        break;
      case offsetPlace.topLeft:
        createBottomLeftArc();
        createLeftLine();
        tempOffset = endPointOffset - leftLineOffset;
        arcToPoint(offsetPlace.topLeft, tempOffset);
        break;
      case offsetPlace.topLine:
        createBottomLeftArc();
        createLeftLine();
        createTopLeftArc();
        tempOffset = borderRadius + endPointOffset;
        path.lineTo(tempOffset, 0);
        break;
      case offsetPlace.topRight:
        createBottomLeftArc();
        createLeftLine();
        createTopLeftArc();
        createTopLine();
        tempOffset = endPointOffset - topLineOffset;
        arcToPoint(offsetPlace.topRight, tempOffset);
        break;
      case offsetPlace.rightLine:
        createBottomLeftArc();
        createLeftLine();
        createTopLeftArc();
        createTopLine();
        createTopRightArc();
        tempOffset = endPointOffset - topRightOffset;
        path.lineTo(width, borderRadius + tempOffset);
        break;
      case offsetPlace.bottomRight:
        createBottomLeftArc();
        createLeftLine();
        createTopLeftArc();
        createTopLine();
        createTopRightArc();
        createRightLine();
        tempOffset = endPointOffset - rightLineOffset;
        arcToPoint(offsetPlace.bottomRight, tempOffset);
        break;
      case offsetPlace.bottomLine:
        createBottomLeftArc();
        createLeftLine();
        createTopLeftArc();
        createTopLine();
        createTopRightArc();
        createRightLine();
        createBottomRightArc();
        tempOffset = endPointOffset - bottomRightOffset;
        path.lineTo((width - borderRadius) - tempOffset, height);
        break;
    }
  }

  void checkLeftLine(offsetPlace endPointPlace, double firstPointOffset,
      tempOffset, double endPointOffset) {
    switch (endPointPlace) {
      case offsetPlace.leftLine:
        tempOffset = endPointOffset - bottomLeftOffset;
        path.lineTo(0, (height - borderRadius) - tempOffset);
        break;
      case offsetPlace.topLeft:
        createLeftLine();
        tempOffset = endPointOffset - leftLineOffset;
        arcToPoint(offsetPlace.topLeft, tempOffset);
        break;
      case offsetPlace.topLine:
        createLeftLine();
        createTopLeftArc();
        tempOffset = borderRadius + endPointOffset;
        path.lineTo(tempOffset, 0);
        break;
      case offsetPlace.topRight:
        createLeftLine();
        createTopLeftArc();
        createTopLine();
        tempOffset = endPointOffset - topLineOffset;
        arcToPoint(offsetPlace.topRight, tempOffset);
        break;
      case offsetPlace.rightLine:
        createLeftLine();
        createTopLeftArc();
        createTopLine();
        createTopRightArc();
        tempOffset = endPointOffset - topRightOffset;
        path.lineTo(width, borderRadius + tempOffset);
        break;
      case offsetPlace.bottomRight:
        createLeftLine();
        createTopLeftArc();
        createTopLine();
        createTopRightArc();
        createRightLine();
        tempOffset = endPointOffset - rightLineOffset;
        arcToPoint(offsetPlace.bottomRight, tempOffset);
        break;
      case offsetPlace.bottomLine:
        createLeftLine();
        createTopLeftArc();
        createTopLine();
        createTopRightArc();
        createRightLine();
        createBottomRightArc();
        tempOffset = endPointOffset - bottomRightOffset;
        path.lineTo((width - borderRadius) - tempOffset, height);
        break;
      case offsetPlace.bottomLeft:
        createLeftLine();
        createTopLeftArc();
        createTopLine();
        createTopRightArc();
        createRightLine();
        createBottomRightArc();
        createBottomLine();

        tempOffset = endPointOffset - bottomLineOffset;
        arcToPoint(offsetPlace.bottomLeft, tempOffset);
        break;
    }
  }

  void checkTopLeft(offsetPlace endPointPlace, double firstPointOffset,
      tempOffset, double endPointOffset) {
    switch (endPointPlace) {
      case offsetPlace.topLeft:
        tempOffset = endPointOffset - leftLineOffset;
        arcToPoint(offsetPlace.topLeft, tempOffset);
        break;
      case offsetPlace.topLine:
        createTopLeftArc();
        tempOffset = borderRadius + endPointOffset;
        path.lineTo(tempOffset, 0);
        break;
      case offsetPlace.topRight:
        createTopLeftArc();
        createTopLine();
        tempOffset = endPointOffset - topLineOffset;
        arcToPoint(offsetPlace.topRight, tempOffset);
        break;
      case offsetPlace.rightLine:
        createTopLeftArc();
        createTopLine();
        createTopRightArc();
        tempOffset = endPointOffset - topRightOffset;
        path.lineTo(width, borderRadius + tempOffset);
        break;
      case offsetPlace.bottomRight:
        createTopLeftArc();
        createTopLine();
        createTopRightArc();
        createRightLine();
        tempOffset = endPointOffset - rightLineOffset;
        arcToPoint(offsetPlace.bottomRight, tempOffset);
        break;
      case offsetPlace.bottomLine:
        createTopLeftArc();
        createTopLine();
        createTopRightArc();
        createRightLine();
        createBottomRightArc();
        tempOffset = endPointOffset - bottomRightOffset;
        path.lineTo((width - borderRadius) - tempOffset, height);
        break;
      case offsetPlace.bottomLeft:
        createTopLeftArc();
        createTopLine();
        createTopRightArc();
        createRightLine();
        createBottomRightArc();
        createBottomLine();

        tempOffset = endPointOffset - bottomLineOffset;
        arcToPoint(offsetPlace.bottomLeft, tempOffset);
        break;
      case offsetPlace.leftLine:
        createTopLeftArc();
        createTopLine();
        createTopRightArc();
        createRightLine();
        createBottomRightArc();
        createBottomLine();
        createBottomLeftArc();

        tempOffset = endPointOffset - bottomLeftOffset;
        path.lineTo(0, (height - borderRadius) - tempOffset);
        break;
    }
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
        tempX = width - borderRadius;
        tempY = -borderRadius;
        break;
      case offsetPlace.bottomRight:
        tempPi = 2 * pi;
        tempX = width - borderRadius;
        tempY = height - borderRadius;
        break;
      case offsetPlace.bottomLeft:
        tempPi = (3 * pi) / 2;
        tempX = -borderRadius;
        tempY = height - borderRadius;
        break;
      case offsetPlace.topLeft:
        tempPi = pi;
        tempX = -borderRadius;
        tempY = -borderRadius;
        break;

      default:
        throw arcPlace.toString() + " - > is not an arc";
        break;
    }

    var arcPointCor =
        findPointOnArc(borderRadius, tempPi - (arcSize * arcAngles));

    double x = tempX + arcPointCor.dx.abs();
    double y = tempY + arcPointCor.dy.abs();

    path.arcToPoint(Offset(x.abs(), y.abs()),
        radius: Radius.circular(borderRadius));
  }

  void gotToPointOnArc(
    offsetPlace arcPlace,
    double arcSize,
  ) {
    var tempPi;
    var tempX;
    var tempY;
    switch (arcPlace) {
      case offsetPlace.topRight:
        tempPi = pi / 2;
        tempX = width - borderRadius;
        tempY = -borderRadius;
        break;
      case offsetPlace.bottomRight:
        tempPi = 2 * pi;
        tempX = width - borderRadius;
        tempY = height - borderRadius;
        break;
      case offsetPlace.bottomLeft:
        tempPi = (3 * pi) / 2;
        tempX = -borderRadius;
        tempY = height - borderRadius;
        break;
      case offsetPlace.topLeft:
        tempPi = pi;
        tempX = -borderRadius;
        tempY = -borderRadius;
        break;

      default:
        throw arcPlace.toString() + " - > is not an arc";
        break;
    }

    var arcPointCor =
        findPointOnArc(borderRadius, tempPi - (arcSize * arcAngles));

    double x = tempX + arcPointCor.dx.abs();
    double y = tempY + arcPointCor.dy.abs();

    path.moveTo(x.abs(), y.abs());
  }

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

  void createLeftLine() {
    path.lineTo(0, borderRadius);
  }

  void createBottomLeftArc() {
    path.arcToPoint(Offset(0, height - borderRadius),
        radius: Radius.circular(borderRadius));
  }

  void createBottomLine() {
    path.lineTo(borderRadius, height);
  }

  void createBottomRightArc() {
    path.arcToPoint(Offset(width - borderRadius, height),
        radius: Radius.circular(borderRadius));
  }

  void createRightLine() {
    path.lineTo(width, heightLineSize + borderRadius);
  }

  void createTopRightArc() {
    path.arcToPoint(Offset(width, borderRadius),
        radius: Radius.circular(borderRadius));
  }

  void createTopLine() {
    path.lineTo(width - borderRadius, 0);
  }

  void createTopLeftArc() {
    path.arcToPoint(Offset(borderRadius, 0),
        radius: Radius.circular(borderRadius));
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
