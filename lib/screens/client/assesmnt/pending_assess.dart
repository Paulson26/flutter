import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_thera/screens/client/assesmnt/newassess.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_thera/screens/client/badge.dart';

class PendingAssesment extends StatefulWidget {
  const PendingAssesment({
    Key? key,
  }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _PendingAssesmentState createState() => _PendingAssesmentState();
}

class _PendingAssesmentState extends State<PendingAssesment> {
  Future<List<Appointments>> fetchResults() async {
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

    var resultsJson = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Appointments> applist = await resultsJson
        .map<Appointments>((json) => Appointments.fromJson(json))
        .toList();
    print(resultsJson);
    return applist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            FutureBuilder<List<Appointments>>(
              initialData: const <Appointments>[],
              future: fetchResults(),
              builder: (context, snapshot) {
                if (snapshot.hasError ||
                    snapshot.data == null ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  print(snapshot.connectionState);
                  return Center(child: CircularProgressIndicator());
                }

                return DataTable(
                  dividerThickness: 5,
                  dataRowHeight: 80,
                  showBottomBorder: true,
                  headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.black),
                  columns: const [
                    DataColumn(
                        label: Text('Date',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Time',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Clinician',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    DataColumn(
                        label: Text('Amount',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  columnSpacing: 35,
                  horizontalMargin: 10,
                  showCheckboxColumn: false,
                  rows: List.generate(
                    snapshot.data!.length,
                    (index) {
                      var appt = snapshot.data![index];
                      return DataRow(
                          onSelectChanged: (a) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AssessmentDetail(
                                      appt_id: appt.appt_id,
                                      asmt_app_id: appt.appt_id,
                                      asmt_type: appt.asmt_type,
                                    )));
                            // ENTER CALLBACK HERE (It's not restricted to use the bool)
                          },
                          cells: [
                            DataCell(
                              Text(
                                appt.appointmentdate,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                appt.apptfromtime,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                appt.assignedstaff,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            // DataCell(
                            //   Text(
                            //     appt.apptstatus,
                            //     style: TextStyle(
                            //       fontStyle: FontStyle.italic,
                            //     ),
                            //   ),
                            // ),
                            DataCell(appointmentstatus(appt.apptstatus)),
                            DataCell(
                              Text(
                                '\$${appt.apptamount}',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AssessmentDetail(
                                          appt_id: appt.appt_id,
                                          asmt_app_id: appt.appt_id,
                                          asmt_type: appt.asmt_type,
                                        )));
                              },
                            ),
                          ]);
                    },
                  ).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Appointments {
  Appointments({
    required this.apptamount,
    required this.assignedstaff,
    required this.apptstatus,
    required this.appointmentdate,
    required this.apptfromtime,
    required this.appt_id,
    required this.firstvisit,
    required this.asmt_type,
  });
  String apptamount;
  String assignedstaff;
  String apptstatus;
  String appointmentdate;
  String apptfromtime;
  int appt_id;
  bool firstvisit;
  int asmt_type;

  factory Appointments.fromJson(Map<String, dynamic> json) => Appointments(
      apptamount: json['appt_amount'],
      assignedstaff: json['assigned_staff'],
      apptstatus: json['appt_status'],
      appointmentdate: json['appointment_date'],
      apptfromtime: json['appt_from_time'],
      appt_id: json['id'],
      firstvisit: json['is_first_visit'],
      asmt_type: json['appt_assessment_type']);

  Map<String, dynamic> toJson() => {
        "appt_amount": apptamount,
        "appt_status": apptstatus,
        "assigned_staff": assignedstaff,
        "appointment_date": appointmentdate,
        "appt_from_time": apptfromtime,
      };
}
