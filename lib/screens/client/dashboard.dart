// ignore_for_file: implementation_imports, prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_thera/screens/Questionaire/questionire.dart';
import 'package:my_thera/screens/client/amounts/amount.dart';
import 'package:my_thera/screens/client/appointment/appointmentrequest.dart';
import 'package:my_thera/screens/client/assesmnt/pending_assess.dart';
import 'package:my_thera/screens/client/badge.dart';
import 'package:my_thera/screens/client/graphs/mental_status.dart';
import 'package:my_thera/screens/client/graphs/test_graph.dart';
import 'package:my_thera/screens/settings/profile_update.dart';
import 'package:my_thera/screens/settings/settings.dart';
import 'package:my_thera/screens/pendingassesment/pendingassesment.dart';
import 'package:my_thera/screens/PendingQuestionaire/pendingquestionaire.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:badges/badges.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int len = 0;
  String clin = '';
  String status = '';
  int le = 0;
  int count = 0;
  int counts = 0;
  int a = 0;
  int b = 0;
  int c = 0;
  var amountdue;
  String currentDate = "";

  Future fetchResults() async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    var cliniccode = await storage.read(key: "clinic_code");
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/searchAppointment')
        .replace(queryParameters: {
      'clinic_code': cliniccode,
      'client_id': clientid,
      'status': 'WAITING FOR CLIENT'
    });
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
        'clinic_code': '$cliniccode'
      },
    );

    var resultsJson = json.decode(response.body);

    setState(() {
      len = resultsJson.length;
    });

    return resultsJson;
  }

  Future fetch() async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    var cliniccode = await storage.read(key: "clinic_code");
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/searchAppointment')
        .replace(queryParameters: {
      'clinic_code': cliniccode,
      'client_id': clientid,
      'status': 'OPEN'
    });
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
        'clinic_code': '$cliniccode'
      },
    );

    var resultsJson = json.decode(response.body);

    setState(() {
      le = resultsJson.length;
    });

    return resultsJson;
  }

  Future fetchResul() async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    var cliniccode = await storage.read(key: "clinic_code");
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/searchAppointment')
        .replace(queryParameters: {
      'clinic_code': cliniccode,
      'client_id': clientid,
      'status': 'WAITING FOR CLIENT'
    });
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
        'clinic_code': '$cliniccode'
      },
    );

    var resultsJson = json.decode(response.body);

    setState(() {
      len = resultsJson.length;
    });

    return resultsJson;
  }

  Future _getAmount() async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    var cliniccode = await storage.read(key: "clinic_code");
    print(cliniccode);
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/populate-data/');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
        'clinic_code': '$cliniccode'
      },
    );
    // print(response.body);
    Map<String, dynamic> json = jsonDecode(response.body)['data']['payments'];
    setState(() {
      amountdue = json['due'];
    });

    return (json);
  }

  Future _getReminder() async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    print(clientid);
    var cliniccode = await storage.read(key: "clinic_code");
    print(cliniccode);
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/populate-data/');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
        'clinic_code': '$cliniccode'
      },
    );
    // print(response.body);
    Map<String, dynamic> json = jsonDecode(response.body)['data']['reminders'];
    setState(() {
      count = json['count'];
    });

    return (json);
  }

  Future _getUsers() async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    print(clientid);
    var cliniccode = await storage.read(key: "clinic_code");
    print(cliniccode);
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/populate-data/');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
        'clinic_code': '$cliniccode'
      },
    );
    // print(response.body);
    var json = jsonDecode(response.body)['data']['clinician_visited'];
    setState(() {
      clin = json[0]['staff_name'];
    });
  }

  Future _getStatus() async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    print(clientid);
    var cliniccode = await storage.read(key: "clinic_code");
    print(cliniccode);
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/populate-data/');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
        'clinic_code': '$cliniccode'
      },
    );
    // print(response.body);
    var json = jsonDecode(response.body)['data']['latest_appt'];
    setState(() {
      status = json['appt_status'];
    });
    print(status);
  }

  Future _getGoals() async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    print(clientid);
    var cliniccode = await storage.read(key: "clinic_code");
    print(cliniccode);
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/populate-data/');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
        'clinic_code': '$cliniccode'
      },
    );
    // print(response.body);
    var json = jsonDecode(response.body)['data']['goals'];
    setState(() {
      a = json[0]['goal'].length;
      b = json[1]['goal'].length;
      c = a + b;
    });
  }

  Future fetchResult() async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");

    var cliniccode = await storage.read(key: "clinic_code");

    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/searchAppointment')
        .replace(queryParameters: {
      'clinic_code': cliniccode,
      'client_id': clientid,
      'appt_date': currentDate
    });
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
        'clinic_code': '$cliniccode'
      },
    );

    var resultsJson = json.decode(response.body);

    setState(() {
      counts = resultsJson.length;
    });
    print(counts);
    return resultsJson;
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
    fetchResults();
    fetchResult();
    _getAmount();
    _getReminder();
    fetchResul();
    _getGoals();
    _getStatus();
    fetch();
    var today = DateTime.now();
    var dateStr = DateFormat('yyyy-MM-dd');
    currentDate = dateStr.format(today);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color.fromARGB(255, 196, 222, 235),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Dashboard'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            makeDashboardItem("Today's Appointment", Icons.today, counts),
            makeDashboardItem2("Clinicians You Visit", Icons.visibility, clin),
            makeDashboardItem3("Pending Questionaires", Icons.message, le),
            makeDashboardItem4("Pending Assessments", Icons.assessment, len),
            makeDashboardItem5("Appointment Status", Icons.alarm, status),
            makeDashboardItem6("Goals", Icons.remember_me, c),
            makeDashboardItem7("Reminders Today", Icons.today, count),
            makeDashboardItem8("Amount Due", Icons.alarm, '\$$amountdue')
          ],
        ),
      ),
    );
  }

  Card makeDashboardItem(String title, IconData icon, int counts) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Badge(
          position: BadgePosition.topEnd(top: -9, end: -10),
          badgeColor: Colors.red,
          badgeContent: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            child: Text(
              counts.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          child: Container(
            decoration:
                BoxDecoration(color: const Color.fromARGB(255, 152, 194, 236)),
            child: new InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PendingQuestionaire(),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  SizedBox(height: 50.0),
                  Center(
                      child: Icon(
                    icon,
                    size: 40.0,
                    color: Colors.black,
                  )),
                  SizedBox(height: 20.0),
                  new Center(
                    child: new Text(title,
                        style:
                            new TextStyle(fontSize: 18.0, color: Colors.black)),
                  ),
                  SizedBox(height: 53.7),
                ],
              ),
            ),
          ),
        ));
  }

  Card makeDashboardItem2(String title, IconData icon, String clin) {
    return Card(
      elevation: 1.0,
      margin: new EdgeInsets.all(8.0),
      child: Container(
        decoration:
            BoxDecoration(color: const Color.fromARGB(255, 152, 194, 236)),
        child: new InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileUpdate(),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              SizedBox(height: 50.0),
              Center(
                  child: Icon(
                icon,
                size: 40.0,
                color: Colors.black,
              )),
              SizedBox(height: 20.0),
              new Center(
                child: new Text(title,
                    style: new TextStyle(fontSize: 18.0, color: Colors.black)),
              ),
              SizedBox(height: 13),
              Center(
                child: Badge(
                  toAnimate: true,
                  elevation: 15,
                  shape: BadgeShape.square,
                  badgeColor: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(8),
                  badgeContent: Text(clin,
                      style:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card makeDashboardItem3(String title, IconData icon, int le) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Badge(
          position: BadgePosition.topEnd(top: -9, end: -10),
          badgeColor: Colors.red,
          badgeContent: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            child: Text(
              le.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          child: Container(
            decoration:
                BoxDecoration(color: const Color.fromARGB(255, 152, 194, 236)),
            child: new InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PendingQuestionaire(),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  SizedBox(height: 50.0),
                  Center(
                      child: Icon(
                    icon,
                    size: 40.0,
                    color: Colors.black,
                  )),
                  SizedBox(height: 20.0),
                  new Center(
                    child: new Text(title,
                        style:
                            new TextStyle(fontSize: 18.0, color: Colors.black)),
                  ),
                  SizedBox(height: 53.7),
                ],
              ),
            ),
          ),
        ));
  }

  Card makeDashboardItem4(String title, IconData icon, int pend) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Badge(
          position: BadgePosition.topEnd(top: -9, end: -10),
          badgeColor: Colors.red,
          badgeContent: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            child: Text(
              pend.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          child: Container(
            decoration:
                BoxDecoration(color: const Color.fromARGB(255, 152, 194, 236)),
            child: new InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PendingAssesment(),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  SizedBox(height: 50.0),
                  Center(
                      child: Icon(
                    icon,
                    size: 40.0,
                    color: Colors.black,
                  )),
                  SizedBox(height: 20.0),
                  new Center(
                    child: new Text(title,
                        style:
                            new TextStyle(fontSize: 18.0, color: Colors.black)),
                  ),
                  SizedBox(height: 53.7),
                ],
              ),
            ),
          ),
        ));
  }

  Card makeDashboardItem5(String title, IconData icon, String clin) {
    return Card(
      elevation: 1.0,
      margin: new EdgeInsets.all(8.0),
      child: Container(
        decoration:
            BoxDecoration(color: const Color.fromARGB(255, 152, 194, 236)),
        child: new InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileUpdate(),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              SizedBox(height: 50.0),
              Center(
                  child: Icon(
                icon,
                size: 40.0,
                color: Colors.black,
              )),
              SizedBox(height: 20.0),
              new Center(
                child: new Text(title,
                    style: new TextStyle(fontSize: 18.0, color: Colors.black)),
              ),
              SizedBox(height: 13),
              Center(
                child: appointmentstatus(clin),
              ),
              //appointmentstatus(clin)
            ],
          ),
        ),
      ),
    );
  }

  Card makeDashboardItem6(String title, IconData icon, int c) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Badge(
          position: BadgePosition.topEnd(top: -9, end: -10),
          badgeColor: Colors.red,
          badgeContent: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            child: Text(
              c.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          child: Container(
            decoration:
                BoxDecoration(color: const Color.fromARGB(255, 152, 194, 236)),
            child: new InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PendingQuestionaire(),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  SizedBox(height: 50.0),
                  Center(
                      child: Icon(
                    icon,
                    size: 40.0,
                    color: Colors.black,
                  )),
                  SizedBox(height: 20.0),
                  new Center(
                    child: new Text(title,
                        style:
                            new TextStyle(fontSize: 18.0, color: Colors.black)),
                  ),
                  SizedBox(height: 53.7),
                ],
              ),
            ),
          ),
        ));
  }

  Card makeDashboardItem7(String title, IconData icon, int c) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Badge(
          position: BadgePosition.topEnd(top: -9, end: -10),
          badgeColor: Colors.red,
          badgeContent: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            child: Text(
              c.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          child: Container(
            decoration:
                BoxDecoration(color: const Color.fromARGB(255, 152, 194, 236)),
            child: new InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chart(),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  SizedBox(height: 50.0),
                  Center(
                      child: Icon(
                    icon,
                    size: 40.0,
                    color: Colors.black,
                  )),
                  SizedBox(height: 20.0),
                  new Center(
                    child: new Text(title,
                        style:
                            new TextStyle(fontSize: 18.0, color: Colors.black)),
                  ),
                  SizedBox(height: 53.7),
                ],
              ),
            ),
          ),
        ));
  }

  Card makeDashboardItem8(String title, IconData icon, var due) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
          decoration:
              BoxDecoration(color: const Color.fromARGB(255, 152, 194, 236)),
          child: new InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(
                    title: 'Amount',
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 50.0),
                Center(
                    child: Icon(
                  icon,
                  size: 40.0,
                  color: Colors.black,
                )),
                SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.black)),
                ),
                SizedBox(height: 13),
                Center(
                  child: Badge(
                    shape: BadgeShape.square,
                    borderRadius: BorderRadius.circular(8),
                    position: BadgePosition.topEnd(top: 9, end: 10),
                    badgeColor: Colors.red,
                    badgeContent: Container(
                      width: 70,
                      height: 30,
                      alignment: Alignment.center,
                      child: Text(
                        due,
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
