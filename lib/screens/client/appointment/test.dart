// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class JsonDataGrid extends StatefulWidget {
  const JsonDataGrid({Key? key}) : super(key: key);

  @override
  JsonDataGridState createState() => JsonDataGridState();
}

bool showLoadingIndicator = false;
List<Appointment> paginatedDataSource = [];
int rowsPerPage = 10;
late JsonDataGridSource jsonDataGridSource;
List<Appointment> appointmentlist = [];

Future generateAppointmentList() async {
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
  var list = json.decode(response.body).cast<Map<String, dynamic>>();
  appointmentlist = await list
      .map<Appointment>((json) => Appointment.fromJson(json))
      .toList();

  jsonDataGridSource = JsonDataGridSource(appointmentlist);

  return appointmentlist;
}

class JsonDataGridState extends State<JsonDataGrid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text('Appointments'),
        ),
        body: SfDataPagerTheme(
          data: SfDataPagerThemeData(
            itemColor: Colors.white,
            selectedItemColor: const Color.fromARGB(255, 152, 194, 236),
            itemBorderRadius: BorderRadius.circular(5),
            backgroundColor: Colors.lightBlue,
          ),
          child: FutureBuilder(
              future: generateAppointmentList(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return snapshot.hasData
                    ? LayoutBuilder(builder: (context, constraints) {
                        return Column(children: [
                          SizedBox(
                              height: constraints.maxHeight - 60,
                              width: constraints.maxWidth,
                              child: buildStack(constraints)),
                          SizedBox(
                              height: 60,
                              width: constraints.maxWidth,
                              child: SfDataPager(
                                  pageCount:
                                      (appointmentlist.length / rowsPerPage)
                                          .ceil()
                                          .toDouble(),
                                  direction: Axis.horizontal,
                                  delegate: jsonDataGridSource))
                        ]);
                      })
                    : const Center(
                        child: CircularProgressIndicator(strokeWidth: 3));
              }),
        ));
  }

  Widget buildDataGrid() {
    return SfDataGrid(
        columns: getColumns(),
        source: jsonDataGridSource,
        columnWidthMode: ColumnWidthMode.fill);
  }

  Widget buildStack(BoxConstraints constraints) {
    List<Widget> _getChildren() {
      final List<Widget> stackChildren = [];
      stackChildren.add(buildDataGrid());

      if (showLoadingIndicator) {
        stackChildren.add(Container(
            color: Colors.black12,
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: const Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(strokeWidth: 3))));
      }

      return stackChildren;
    }

    return Stack(children: _getChildren());
  }

  List<GridColumn> getColumns() {
    return [
      GridColumn(
        columnName: 'Date',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text(
            'Date',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'Time',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text(
            'Time',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'Clinician',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text(
            'Clinician',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'Status',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Status'),
        ),
      ),
      GridColumn(
        columnName: 'Amount',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text(
            'Amount',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
    ];
  }
}

class JsonDataGridSource extends DataGridSource {
  JsonDataGridSource(List<Appointment> appointmentlist) {
    buildDataGridRow(appointmentlist);
  }

  List<DataGridRow> dataGridRows = [];

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    print(
        'Handle PageChange called and  oldPageIndex: $oldPageIndex  newPageIndex: $newPageIndex');
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < appointmentlist.length) {
      if (endIndex > appointmentlist.length) {
        endIndex = appointmentlist.length;
      }

      paginatedDataSource = appointmentlist
          .getRange(startIndex, endIndex)
          .toList(growable: false);
      buildDataGridRow(paginatedDataSource);
      notifyListeners();
    } else {
      paginatedDataSource = [];
    }

    return true;
  }

  void buildDataGridRow(List<Appointment> productlist) {
    dataGridRows = productlist.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'Date', value: dataGridRow.appointmentdate),
        DataGridCell<String>(
            columnName: 'Time', value: dataGridRow.apptfromtime),
        DataGridCell<String>(
            columnName: 'Clinician', value: dataGridRow.assignedstaff),
        DataGridCell<String>(
            columnName: 'Status', value: dataGridRow.apptstatus),
        DataGridCell<String>(
          columnName: 'Amount',
          value: '\$${dataGridRow.apptamount}',
        ),
      ]);
    }).toList(growable: false);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5.0),
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(1.0),
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[3].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[4].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }
}

class Appointment {
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      apptid: json['appt_id'] ?? '',
      apptclient: json['appt_client'] ?? '',
      assignedstaff: json['assigned_staff'] ?? "",
      apptstatus: json['appt_status'] ?? '',
      apptamount: json['appt_amount'] ?? "",
      appointmentdate: json['appointment_date'] ?? '',
      apptfromtime: json['appt_from_time'] ?? '',
      appointmentcreateddate: json['appointment_created_date'] ?? '',
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
  String apptid;
  String apptclient;
  String assignedstaff;
  String apptstatus;
  String apptamount;
  String appointmentdate;
  String apptfromtime;
  String appointmentcreateddate;
}
