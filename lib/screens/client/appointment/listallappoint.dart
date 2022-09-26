import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_thera/screens/PendingQuestionaire/pendingquestionaire.dart';
import 'package:my_thera/screens/client/appointment/appointmentrequest.dart';
import 'package:my_thera/screens/client/assesmnt/newassess.dart';

import 'package:my_thera/screens/client/assesmnt/pending_assess.dart';
import 'package:my_thera/screens/client/badge.dart';
import 'package:my_thera/screens/client/payment/biiling_payment.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import '../billing.dart';
import 'package:my_thera/screens/Questionaire/questionire.dart';

class Listall extends StatefulWidget {
  const Listall({Key? key}) : super(key: key);

  @override
  ListallState createState() => ListallState();
}

class ListallState extends State<Listall> {
  @override
  void initState() {
    super.initState();
    fetchResults();
  }

  String amt = 'WAITING FOR PAYMENT';
  String amts = 'CONFIRMED';
  Future<List<Appointments>> fetchResults() async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    print(clientid);
    var cliniccode = await storage.read(key: "clinic_code");
    print(cliniccode);
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/searchAppointment')
        .replace(queryParameters: {
      'clinic_code': cliniccode,
      'client_id': clientid,
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

    return applist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment'),
        backgroundColor: const Color.fromARGB(255, 152, 194, 236),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Appointmentrequest()));
            },
            child: const Text(
              '+ Request Appointment',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
            ),
          ),
        ],
      ),
      body: ListView(children: [
        Column(
          children: [
            FutureBuilder<List<Appointments>>(
              initialData: const <Appointments>[],
              future: fetchResults(),
              builder: (context, snapshot) {
                if (snapshot.hasError ||
                    snapshot.data == null ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.red,
                  ));
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dividerThickness: 10,
                    dataRowHeight: 80,
                    showBottomBorder: true,
                    headingTextStyle: const TextStyle(
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
                      // DataColumn(
                      //     label: Text('Action',
                      //         style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    columnSpacing: 14,
                    horizontalMargin: 10,
                    showCheckboxColumn: false,
                    rows: List.generate(
                      snapshot.data!.length,
                      (index) {
                        var appt = snapshot.data![index];
                        return DataRow(
                            onSelectChanged: (a) {
                              //  Navigator.of(context).push(MaterialPageRoute(
                              //       builder: (context) => QuestionairePage(
                              //             appt_id: appt.appt_id,
                              //             firstvisit: appt.firstvisit,
                              //           )));
                              // ENTER CALLBACK HERE (It's not restricted to use the bool)

                              if (appt.apptstatus == 'NEW') {
                                Alert(
                                  context: context,
                                  type: AlertType.info,
                                  // title: "Appointment Status",
                                  desc: "Waiting for Appointment approval",
                                  buttons: [
                                    DialogButton(
                                      child: const Text(
                                        "ok",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/dashboard'),
                                      width: 120,
                                    )
                                  ],
                                ).show();
                              }
                              if (appt.apptstatus == 'OPEN') {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PendingQuestionaire()));
                              }
                              if (appt.apptstatus == 'WAITING') {
                                Alert(
                                  context: context,
                                  type: AlertType.info,
                                  // title: "Appointment Status",
                                  desc: "Waiting for Clinician approval",
                                  buttons: [
                                    DialogButton(
                                      child: const Text(
                                        "ok",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/dashboard'),
                                      width: 120,
                                    )
                                  ],
                                ).show();
                              }
                              if (appt.apptstatus == 'WAITING FOR CLIENT') {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AssessmentDetail(
                                          appt_id: appt.appt_id,
                                          asmt_app_id: appt.appt_id,
                                          asmt_type: appt.asmt_type,
                                        )));
                              }
                              if (appt.apptstatus == 'WAITING FOR PAYMENT') {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Billinf()));
                              }
                              if (appt.apptstatus ==
                                  'WAITING FOR INSURANCE CNFRM') {
                                Alert(
                                  context: context,
                                  type: AlertType.info,
                                  // title: "Appointment Status",
                                  desc: "Waiting for insurance approval",
                                  buttons: [
                                    DialogButton(
                                      child: const Text(
                                        "ok",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/dashboard'),
                                      width: 120,
                                    )
                                  ],
                                ).show();
                              }
                              if (appt.apptstatus == 'CONFIRMED') {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         PendingQuestionaire()));
                                Alert(
                                  context: context,
                                  type: AlertType.info,
                                  // title: "Appointment Status",
                                  desc:
                                      "Your appointment is Confirmed, Please  visit Waiting Room on your appointment date",
                                  buttons: [
                                    DialogButton(
                                      child: const Text(
                                        "ok",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/dashboard'),
                                      width: 120,
                                    )
                                  ],
                                ).show();
                              }
                            },
                            cells: [
                              DataCell(
                                Text(
                                  appt.appointmentdate,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  appt.apptfromtime,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  appt.apptstaff,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              DataCell(appointmentstatus(appt.apptstatus)),
                              DataCell(
                                Text(
                                  '\$${appt.apptamount}',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              //   DataCell(
                              //     const Icon(
                              //       Icons.edit,
                              //       color: Color.fromARGB(255, 12, 11, 11),
                              //     ),
                              //     // placeholder: true,
                              //     onTap: () {
                              //       if (appt.apptstatus == 'NEW') {
                              //                Alert(
                              //   context: context,
                              //   type: AlertType.info,
                              //   // title: "Appointment Status",
                              //   desc: "Waiting for Appointment approval",
                              //   buttons: [
                              //     DialogButton(
                              //       child: const Text(
                              //         "ok",
                              //         style: TextStyle(
                              //             color: Colors.white, fontSize: 20),
                              //       ),
                              //       onPressed: () =>
                              //           Navigator.pushNamed(context, '/dashboard'),
                              //       width: 120,
                              //     )
                              //   ],
                              // ).show();
                              //       }
                              //       if (appt.apptstatus == 'OPEN') {
                              //         Navigator.of(context).push(MaterialPageRoute(
                              //             builder: (context) =>
                              //                 Clinicianvisit()));
                              //       }
                              //       if (appt.apptstatus == 'WAITING') {
                              //         Alert(
                              //   context: context,
                              //   type: AlertType.info,
                              //   // title: "Appointment Status",
                              //   desc: "Waiting for Clinician approval",
                              //   buttons: [
                              //     DialogButton(
                              //       child: const Text(
                              //         "ok",
                              //         style: TextStyle(
                              //             color: Colors.white, fontSize: 20),
                              //       ),
                              //       onPressed: () =>
                              //           Navigator.pushNamed(context, '/dashboard'),
                              //       width: 120,
                              //     )
                              //   ],
                              // ).show();
                              //       }
                              //       if (appt.apptstatus == 'WAITING FOR CLIENT') {
                              //         Navigator.of(context).push(MaterialPageRoute(
                              //             builder: (context) =>
                              //                 Clinicianvisit()));
                              //       }
                              //       if (appt.apptstatus == 'WAITING FOR PAYMENT') {
                              //         Navigator.of(context).push(MaterialPageRoute(
                              //             builder: (context) =>
                              //                 Clinicianvisit()));
                              //       }
                              //       if (appt.apptstatus == 'WAITING FOR INSURANCE CNFRM') {
                              //         Alert(
                              //   context: context,
                              //   type: AlertType.info,
                              //   // title: "Appointment Status",
                              //   desc: "Waiting for insurance approval",
                              //   buttons: [
                              //     DialogButton(
                              //       child: const Text(
                              //         "ok",
                              //         style: TextStyle(
                              //             color: Colors.white, fontSize: 20),
                              //       ),
                              //       onPressed: () =>
                              //           Navigator.pushNamed(context, '/dashboard'),
                              //       width: 120,
                              //     )
                              //   ],
                              // ).show();
                              //       }
                              //       if (appt.apptstatus == 'CONFIRMED') {
                              //         // Navigator.of(context).push(MaterialPageRoute(
                              //         //     builder: (context) =>
                              //         //         PendingQuestionaire()));
                              //         Alert(
                              //   context: context,
                              //   type: AlertType.info,
                              //   // title: "Appointment Status",
                              //   desc: "Your appointment is Confirmed, Please  visit Waiting Room on your appointment date",
                              //   buttons: [
                              //     DialogButton(
                              //       child: const Text(
                              //         "ok",
                              //         style: TextStyle(
                              //             color: Colors.white, fontSize: 20),
                              //       ),
                              //       onPressed: () =>
                              //           Navigator.pushNamed(context, '/dashboard'),
                              //       width: 120,
                              //     )
                              //   ],
                              // ).show();
                              //       }
                              //     },
                              //   ),
                            ]);
                      },
                    ).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ]),
    );
  }
}

List<Appointments> apointmentsFromJson(String str) => List<Appointments>.from(
    json.decode(str).map((x) => Appointments.fromJson(x)));

String apointmentsToJson(List<Appointments> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Appointments {
  Appointments(
      {required this.apptamount,
      required this.apptstatus,
      required this.appointmentdate,
      required this.apptfromtime,
      required this.appt_id,
      required this.apptstaff,
      required this.firstvisit,
      required this.asmt_type});
  String apptamount;

  String apptstatus;
  String appointmentdate;
  String apptfromtime;
  String apptstaff;
  int appt_id;
  bool firstvisit;
  int asmt_type;

  factory Appointments.fromJson(Map<String, dynamic> json) => Appointments(
      apptamount: json['appt_amount'],
      apptstatus: json['appt_status'],
      apptstaff: json['assigned_staff'] ?? '',
      appointmentdate: json['appointment_date'],
      apptfromtime: json['appt_from_time'],
      appt_id: json['id'],
      firstvisit: json['is_first_visit'],
      asmt_type: json['appt_assessment_type']);

  Map<String, dynamic> toJson() => {
        "appt_amount": apptamount,
        "appt_status": apptstatus,
        "appointment_date": appointmentdate,
        "appt_from_time": apptfromtime,
      };
}
