import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  AppointmentPageState createState() => AppointmentPageState();
}

class AppointmentPageState extends State<AppointmentPage> {
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
    print(response.body);
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
                  return const CircularProgressIndicator();
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
                  columnSpacing: 18,
                  horizontalMargin: 10,
                  showCheckboxColumn: true,
                  rows: List.generate(
                    snapshot.data!.length,
                    (index) {
                      var appt = snapshot.data![index];
                      return DataRow(cells: [
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
                        DataCell(
                          Text(
                            appt.apptstatus,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            '\$' + appt.apptamount,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
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

// List<Appointments> apointmentsFromJson(String str) => List<Appointments>.from(
//     json.decode(str).map((x) => Appointments.fromJson(x)));

// String apointmentsToJson(List<Appointments> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Appointments {
  Appointments({
    required this.apptamount,
    required this.assignedstaff,
    required this.apptstatus,
    required this.appointmentdate,
    required this.apptfromtime,
  });
  String apptamount;
  String assignedstaff;
  String apptstatus;
  String appointmentdate;
  String apptfromtime;

  factory Appointments.fromJson(Map<String, dynamic> json) => Appointments(
        apptamount: json['appt_amount'],
        assignedstaff: json['assigned_staff'],
        apptstatus: json['appt_status'],
        appointmentdate: json['appointment_date'],
        apptfromtime: json['appt_from_time'],
      );

  Map<String, dynamic> toJson() => {
        "appt_amount": apptamount,
        "appt_status": apptstatus,
        "assigned_staff": assignedstaff,
        "appointment_date": appointmentdate,
        "appt_from_time": apptfromtime,
      };
}
