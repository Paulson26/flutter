// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_thera/colors/colors.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  double value = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text("Waiting Room"),
        ),
        body: Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 20),
            child: Column(children: [
              Container(
                child: Text(
                  "Wait for Clinician to join!",
                  style: TextStyle(fontSize: 18),
                ),
                margin: EdgeInsets.all(20),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  color: Color.fromARGB(107, 7, 234, 11),
                  strokeWidth: 5,
                ),
              ),
            ])));
  }

  void downloadData() {
    new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (value == 1) {
          timer.cancel();
        } else {
          value = value + 0.1;
        }
      });
    });
  }
}
