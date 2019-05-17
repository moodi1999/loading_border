import 'dart:math';

import 'package:flutter/material.dart';

class LoadingBorder extends StatefulWidget {
  double width;
  double height;
  double borderRadius;
  double strokeWidth;
  Color strokeColor;
  Widget child;
  int animationSpeed;

  LoadingBorder(
      {@required this.width,
      @required this.height,
      @required this.borderRadius,
      @required this.strokeWidth,
      @required this.strokeColor,
      @required this.animationSpeed,
      @required this.child});

  @override
  _LoadingBorderState createState() => _LoadingBorderState();
}

class _LoadingBorderState extends State<LoadingBorder>
    with TickerProviderStateMixin<LoadingBorder> {
  AnimationController controller;
  Animation<double> animation;
  double _maxOffset;

  double findMaxOffset() {
    double widthLineOffset = 2 * (widget.width - (2 * widget.borderRadius));
    double heightLineOffset = 2 * (widget.height - (2 * widget.borderRadius));
    double arcSizeOffset = 2 * pi * widget.borderRadius;
    return widthLineOffset + heightLineOffset + arcSizeOffset;
  }

  @override
  void initState() {
    super.initState();
    _maxOffset = findMaxOffset();
    controller = new AnimationController(
        vsync: this, duration: Duration(seconds: widget.animationSpeed));
    animation = new Tween(begin: 0.0, end: _maxOffset).animate(controller);
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return loadingBorderWidget();
        },
        child: Container(height: 100, width: 400, color: Colors.black),
      ),
    );
  }

  Widget loadingBorderWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      child: CustomPaint(
          painter: LoadingPainter(animation.value, widget.width, widget.height,
              widget.borderRadius, widget.strokeWidth, widget.strokeColor),
          child: Center(
            child: widget.child,
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

class LoadingPainter extends CustomPainter {
  double offset;
  double width;
  double height;
  double borderRadius;
  Color strokeColor;
  double strokeWidth;

  double widthLineSize;
  double heightLineSize;
  double arcSize;
  double arcAngles;

  double topLineOffset;
  double topRightOffset;
  double rightLineOffset;
  double bottomRightOffset;
  double bottomLineOffset;
  double bottomLeftOffset;
  double leftLineOffset;
  double topLeftOffset;

  Path path;

  LoadingPainter(this.offset, this.width, this.height, this.borderRadius,
      this.strokeWidth, this.strokeColor) {
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

    double firstEmptySize = 20;

    double secondEmptySize = 18;
    double thirdEmptySize = 10;
    double lineBetweenLastTwo = 14;

    path = Path();
    path.moveTo(borderRadius, 0);

    Paint paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    double offset = this.offset;


    /*
    * you can create a box here with given offsets and draw
    *
    * */


    double a = 10 + firstEmptySize + offset;
    double b = rightLineOffset + offset;

    double c = bottomRightOffset + offset;
    double d = bottomLineOffset - widthLineSize/2 - 10 + offset;

    double c1 = bottomLineOffset - widthLineSize/2 + offset;
    double d1 = bottomLeftOffset  + offset;

    double e = bottomLeftOffset + 20 + offset;
    double f = topLeftOffset + offset;

    draw(a, b);
    draw(c, d);
    draw(c1, d1);
    draw(e, f);



//    double a = firstEmptySize + offset;
//    double b = bottomRightOffset + offset;
//    // a -> b
//
//    double c = b + secondEmptySize;
//    double d = c + lineBetweenLastTwo;
//    // c -> d
//
//    double e = d + thirdEmptySize;
//    double f = topLeftOffset + offset;
//    // e -> a
//
//    draw(a, b);
//    draw(c, d);
//    draw(e, f);

//    createFrame(canvas, width, height, borderRadius);
    canvas.drawPath(path, paint);
  }

  void draw(double firstPointOffset, double endPointOffset) {
    if (firstPointOffset > topLeftOffset) {
      firstPointOffset = firstPointOffset - topLeftOffset;
    }
    if (endPointOffset > topLeftOffset) {
      endPointOffset = endPointOffset - topLeftOffset;
    }
    var firstPointPlace = findOffsetPlace(firstPointOffset);
    var endPointPlace = findOffsetPlace(endPointOffset);

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
        if (firstPointOffset <= endPointOffset) {
          tempOffset = endPointOffset - topLineOffset;
          arcToPoint(offsetPlace.topRight, tempOffset);
        } else {
          createTopRightArc();
          createRightLine();
          createBottomRightArc();
          createBottomLine();
          createBottomLeftArc();
          createLeftLine();
          createTopLeftArc();
          createTopLine();

          tempOffset = endPointOffset - topLineOffset;
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
        if (firstPointOffset <= endPointOffset) {
          tempOffset = endPointOffset - topRightOffset;
          path.lineTo(width, borderRadius + tempOffset);
        } else {
          createRightLine();
          createBottomRightArc();
          createBottomLine();
          createBottomLeftArc();
          createLeftLine();
          createTopLeftArc();
          createTopLine();
          createTopRightArc();

          tempOffset = endPointOffset - topRightOffset;
          path.lineTo(width, borderRadius + tempOffset);
        }

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
        if (firstPointOffset <= endPointOffset) {
          tempOffset = endPointOffset - rightLineOffset;
          arcToPoint(offsetPlace.bottomRight, tempOffset);
        } else {
          createBottomRightArc();
          createBottomLine();
          createBottomLeftArc();
          createLeftLine();
          createTopLeftArc();
          createTopLine();
          createTopRightArc();
          createRightLine();

          tempOffset = endPointOffset - rightLineOffset;
          arcToPoint(offsetPlace.bottomRight, tempOffset);
        }

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
        if (firstPointOffset <= endPointOffset) {
          tempOffset = endPointOffset - bottomRightOffset;
          path.lineTo((width - borderRadius) - tempOffset, height);
        } else {
          createBottomLine();
          createBottomLeftArc();
          createLeftLine();
          createTopLeftArc();
          createTopLine();
          createTopRightArc();
          createRightLine();
          createBottomRightArc();

          tempOffset = endPointOffset - bottomRightOffset;
          path.lineTo((width - borderRadius) - tempOffset, height);
        }

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
        if (firstPointOffset <= endPointOffset) {
          tempOffset = endPointOffset - bottomLineOffset;
          arcToPoint(offsetPlace.bottomLeft, tempOffset);
        } else {
          createBottomLeftArc();
          createLeftLine();
          createTopLeftArc();
          createTopLine();
          createTopRightArc();
          createRightLine();
          createBottomRightArc();
          createBottomLine();

          tempOffset = endPointOffset - bottomLineOffset;
          arcToPoint(offsetPlace.bottomLeft, tempOffset);
        }
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
        if (firstPointOffset <= endPointOffset) {
          tempOffset = endPointOffset - bottomLeftOffset;
          path.lineTo(0, (height - borderRadius) - tempOffset);
        } else {
          createLeftLine();
          createTopLeftArc();
          createTopLine();
          createTopRightArc();
          createRightLine();
          createBottomRightArc();
          createBottomLine();
          createBottomLeftArc();
          tempOffset = endPointOffset - bottomLeftOffset;
          path.lineTo(0, (height - borderRadius) - tempOffset);
        }

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
        if (firstPointOffset <= endPointOffset) {
          tempOffset = endPointOffset - leftLineOffset;
          arcToPoint(offsetPlace.topLeft, tempOffset);
        } else {
          createTopLeftArc();
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
  bool shouldRepaint(LoadingPainter oldDelegate) {
    return offset != oldDelegate.offset;
  }
}
