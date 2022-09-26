// ignore_for_file: prefer_const_constructors, avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class MyHome2Page extends StatefulWidget {
  const MyHome2Page({
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
  _MyHome2PageState createState() => _MyHome2PageState();
}

class _MyHome2PageState extends State<MyHome2Page> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: FutureBuilder(
        future: getAppointmentDataSource(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData
              ? SfDataGrid(source: snapshot.data, columns: getColumns())
              : Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                );
        },
      ),
    ));
  }

  Future<AppointmentDataGridSource> getAppointmentDataSource() async {
    var appointmentList = await generateAppointmentList();
    return AppointmentDataGridSource(appointmentList);
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
          columnName: 'ID',
          width: 70,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Text(' ID', overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          columnName: 'Client',
          width: 100,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child:
                  Text('Client', overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          columnName: 'Clinician',
          width: 100,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Text('Clinician',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          columnName: 'Status',
          width: 95,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child:
                  Text('Status', overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          columnName: 'amount',
          width: 95,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child:
                  Text('amount', overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          columnName: ' appointmentdate',
          width: 95,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: Text('appointmentdate',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          columnName: ' appointmentcreateddate',
          width: 95,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: Text('appointmentcreateddate',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          columnName: ' appointmenttime',
          width: 95,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: Text('appointmenttime',
                  overflow: TextOverflow.clip, softWrap: true))),
    ];
  }

  Future<List<Appointment>> generateAppointmentList() async {
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

    var decodedAppointments =
        json.decode(response.body).cast<Map<String, dynamic>>();
    List<Appointment> appointmentList = await decodedAppointments
        .map<Appointment>((json) => Appointment.fromJson(json))
        .toList();
    return appointmentList;
  }
}

class AppointmentDataGridSource extends DataGridSource {
  AppointmentDataGridSource(this.appointmentList) {
    buildDataGridRow();
  }
  late List<DataGridRow> dataGridRows;
  late List<Appointment> appointmentList;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[3].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[4].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[5].value.toString(),
            overflow: TextOverflow.ellipsis,
          )),
      Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[6].value.toString(),
            overflow: TextOverflow.ellipsis,
          )),
      Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[7].value.toString(),
            overflow: TextOverflow.ellipsis,
          ))
    ]);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = appointmentList.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'ID', value: dataGridRow.apptid),
        DataGridCell<String>(
            columnName: 'Client', value: dataGridRow.apptclient),
        DataGridCell<String>(
            columnName: 'Clinician', value: dataGridRow.assignedstaff),
        DataGridCell<String>(
            columnName: 'Status', value: dataGridRow.apptstatus),
        DataGridCell<String>(
            columnName: 'amount', value: dataGridRow.apptamount),
        DataGridCell<String>(
            columnName: ' appointmentdate', value: dataGridRow.appointmentdate),
        DataGridCell<String>(
            columnName: ' appointmentcreateddate',
            value: dataGridRow.appointmentcreateddate),
        DataGridCell<String>(
            columnName: ' appointmenttime', value: dataGridRow.apptfromtime),
      ]);
    }).toList(growable: false);
  }
}

class Appointment {
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      apptid: json['appt_id'],
      apptclient: json['appt_client'],
      assignedstaff: json['assigned_staff'],
      apptstatus: json['appt_status'],
      apptamount: json['appt_amount'],
      appointmentdate: json['appointment_date'],
      apptfromtime: json['appt_from_time'],
      appointmentcreateddate: json['appointment_created_date'],
    );
  }

  Appointment({
    required this.apptid,
    required this.apptclient,
    required this.assignedstaff,
    required this.apptstatus,
    required this.apptamount,
    required this.appointmentdate,
    required this.apptfromtime,
    required this.appointmentcreateddate,
  });
  String? apptid;
  String? apptclient;
  String? assignedstaff;
  String? apptstatus;
  String? apptamount;
  String? appointmentdate;
  String? apptfromtime;
  String? appointmentcreateddate;
}