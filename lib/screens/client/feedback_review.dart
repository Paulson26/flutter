// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:my_thera/screens/client/feedback/Application_feedback.dart';
import 'package:my_thera/screens/client/feedback/Clinic_feedback.dart';
import 'package:my_thera/screens/client/feedback/Clinician_feedback.dart';

class ReviewsDemo extends StatefulWidget {
  @override
  State<ReviewsDemo> createState() => ReviewsDemoState();
}

class ReviewsDemoState extends State<ReviewsDemo> {
  String singleValue = "Text alignment right";
  String verticalGroupValue = "Pending";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Feedbacks'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(5.0),
          children: <Widget>[
            makeDashboardItem("Clinician Feedback", Icons.rate_review_outlined),
            makeDashboardItem2(
                "Application Feedback", Icons.rate_review_outlined),
            makeDashboardItem3("Clinic Feedback", Icons.rate_review_outlined),
          ],
        ),
      ),
    );
  }

  Card makeDashboardItem(String title, IconData icon) {
    return Card(
        elevation: 20.0,
        margin: const EdgeInsets.all(5.0),
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 152, 194, 236)),
          child: new InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewsClinician(),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                const SizedBox(height: 50.0),
                Center(
                    child: Icon(
                  icon,
                  size: 40.0,
                  color: Colors.black,
                )),
                const SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                          const TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }

  Card makeDashboardItem2(String title, IconData icon) {
    return Card(
        elevation: 20.0,
        margin: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
              color: const Color.fromARGB(255, 152, 194, 236)),
          child: new InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewsApplication(),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                const SizedBox(height: 50.0),
                Center(
                    child: Icon(
                  icon,
                  size: 40.0,
                  color: Colors.black,
                )),
                const SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                          const TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }

  Card makeDashboardItem3(String title, IconData icon) {
    return Card(
        elevation: 20.0,
        margin: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
              color: const Color.fromARGB(255, 152, 194, 236)),
          child: new InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewsClinic(),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                const SizedBox(height: 50.0),
                Center(
                    child: Icon(
                  icon,
                  size: 40.0,
                  color: Colors.black,
                )),
                const SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                          const TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }
}
