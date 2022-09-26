// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_thera/screens/Questionaire/questionire.dart';

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Appointments'),
      ),
      body: FutureBuilder(
        future: fetchResults(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: PaginatedDataTable(
                columnSpacing: 15,
                horizontalMargin: 40,
                rowsPerPage: 10,
                showCheckboxColumn: false,
                source: dataSource(snapshot.data),
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text('Clinician')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Amount')),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  DataTableSource dataSource(List<Appointments> appointmentList) =>
      MyData(dataList: appointmentList, context: context);
}

// List<Appointments> apointmentsFromJson(String str) => List<Appointments>.from(
//     json.decode(str).map((x) => Appointments.fromJson(x)));

// String apointmentsToJson(List<Appointments> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Appointments {
  Appointments(
      {required this.apptamount,
      required this.assignedstaff,
      required this.apptstatus,
      required this.appointmentdate,
      required this.apptfromtime,
      required this.appt_id,
      required this.firstvisit});
  String apptamount;
  String assignedstaff;
  String apptstatus;
  String appointmentdate;
  String apptfromtime;
  int appt_id;
  bool firstvisit;

  factory Appointments.fromJson(Map<String, dynamic> json) => Appointments(
        apptamount: json['appt_amount'] ?? "",
        assignedstaff: json['assigned_staff'] ?? "",
        apptstatus: json['appt_status'],
        appointmentdate: json['appointment_date'],
        apptfromtime: json['appt_from_time'],
        appt_id: json['id'],
        firstvisit: json['is_first_visit'],
      );

  Map<String, dynamic> toJson() => {
        "appt_amount": apptamount,
        "appt_status": apptstatus,
        "assigned_staff": assignedstaff,
        "appointment_date": appointmentdate,
        "appt_from_time": apptfromtime,
      };
}

class MyData extends DataTableSource {
  MyData({required this.dataList, required BuildContext context});
  final List<Appointments> dataList;
  late BuildContext context;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => dataList.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(
      onSelectChanged: (value) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuestionairePage(
                    appt_id: dataList[index].appt_id,
                    firstvisit: dataList[index].firstvisit,
                  ))),
      cells: [
        DataCell(
          Text(dataList[index].appointmentdate.toString()),
        ),
        DataCell(
          Text(dataList[index].apptfromtime),
        ),
        DataCell(
          Text(dataList[index].assignedstaff),
        ),
        DataCell(
          Text(dataList[index].apptstatus),
        ),
        DataCell(
          Text(dataList[index].apptamount),
        ),
      ],
    );
  }
}
