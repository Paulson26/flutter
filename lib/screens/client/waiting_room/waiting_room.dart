// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, prefer_const_constructors, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

//imported google's material design library
class WaitingRoom extends StatefulWidget {
  WaitingRoom({Key? key, required this.apptdate}) : super(key: key);
  final apptdate;
  @override
  State<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {
  @override
  void initState() {
    super.initState();

    fetchApp();

    var today = DateTime.now();
    var dateStr = DateFormat('MM-dd-yyyy');
    currentDate = dateStr.format(today);
  }

  var appt_id;
  var clientid;
  late String currentDate;
  String clientname = "";
  String clinicianname = "";
  String time = "";
  String mode = "";
  int id = 0;
  bool available = false;
  var apptclntid;
  Future fetchApp() async {
    const storage = FlutterSecureStorage();
    var client_id = await storage.read(key: "client_id");
    var myJwt = await storage.read(key: "jwt");
    var cliniccode = await storage.read(key: "clinic_code");
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/waitingroom/')
        .replace(queryParameters: {
      'clinic_code': cliniccode,
      //'asmt_app_id': widget.appt_id.toString(),
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
    //print(response.body);

    var resultsJson = json.decode(response.body);
    print(resultsJson);
    // print(apptid);

    // print(clientresultsJson);

    for (var i = 0; i < resultsJson.length; i++) {
      if (client_id.toString() == resultsJson[i]['appt_client_id'].toString()) {
        appt_id = resultsJson[i]['id'];
        print(appt_id.toString());
      }
    }
    final clienturi = Uri.parse('http://10.0.2.2:8000/api/v1/searchvideo/')
        .replace(
            queryParameters: {'appt_id': appt_id.toString(), 'mode': 'video'});

    final clientresponse = await http.get(
      clienturi,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
        'clinic_code': '$cliniccode'
      },
    );
    var clientresultsJson = json.decode(clientresponse.body);
    //print(clientresultsJson);
    setState(() {
      clientname = resultsJson[0]['appt_client'];
      clinicianname = resultsJson[0]['assigned_staff'];
      time = resultsJson[0]['appt_from_time'];
      mode = resultsJson[0]['appt_mode'];
      apptclntid = resultsJson[0]['appt_client_id'];
      id = resultsJson[0]['id'];
      clientid = client_id;
      // print(clientid);
      available = clientresultsJson['available'];
    });
    return resultsJson;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.apptdate == currentDate) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Waiting Room'),
          centerTitle: true,
        ), //AppBar
        body: Center(
          /** Card Widget **/
          child: Card(
            elevation: 50,
            shadowColor: Colors.black,
            color: Color.fromARGB(255, 255, 255, 255),
            child: SizedBox(
              width: 300,
              height: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const CircleAvatar(
                      // backgroundColor: Colors.green[500],
                      radius: 100,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://cdn.dribbble.com/users/1056119/screenshots/4724342/media/60a82e6716c45f64a9850c7eee0183dc.gif"), //NetworkImage
                        radius: 100,
                      ), //CircleAvatar
                    ), //CircleAvatar
                    const SizedBox(
                      height: 25,
                    ), //SizedBox
                    Text(
                      'Client name: $clientname',
                      style: TextStyle(
                        fontSize: 15,
                        // color: Colors.green[900],
                        fontWeight: FontWeight.w500,
                      ), //Textstyle
                    ), //Text
                    const SizedBox(
                      height: 15,
                    ), //SizedBox
                    Text(
                      'Clinician name: $clinicianname',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 5, 5, 5),
                      ), //Textstyle
                    ), //Text
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Time: $time',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Color.fromARGB(255, 7, 7, 7),
                      ), //Textstyle
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Mode: $mode',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 15, 15, 15),
                      ), //Textstyle
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    if (apptclntid.toString().compareTo(clientid.toString()) ==
                        0)
                      if (available == true)
                        SizedBox(
                          //height: 30,
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () => 'Null',
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(255, 237, 106, 31))),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.video_call_rounded,
                                    size: 40.00,
                                    color: Colors.white,
                                  ),
                                  //Text('Visit')
                                ],
                              ),
                            ),
                          ),
                        ) //SizedBox
                  ],
                ),
              ), //Padding
            ), //SizedBox
          ), //Card
        ), //Center
      );
    } else {
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
                    "Your appointment is Confirmed, Please  visit here on your appointment date",
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
      //MaterialApp
    }
  }
}
