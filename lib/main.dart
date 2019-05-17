import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_border/loading_border.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Color color = Color(0xFF079C85);

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
      color: Colors.white,
      child: Center(
        child: loadingBorderWidget(),
      ),
    );
  }

  Widget loadingBorderWidget() {
    return LoadingBorder(
      width: 260,
      height: 50,
      borderRadius: 10,
      strokeColor: color,
      strokeWidth: 3.0,
      animationSpeed: 10,
      child: Text("Loading..."),
    );
  }
}
