import 'package:flutter/material.dart';
import 'package:my_thera/colors/colors.dart';

class ListApp1 extends StatefulWidget {
  @override
  _ListApp1State createState() => _ListApp1State();
}

class _ListApp1State extends State<ListApp1> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Appointments'),
          backgroundColor: primaryBlack,
        ),
        body: ListView(
          children: [_createDataTable()],
        ),
      ),
    );
  }
}

DataTable _createDataTable() {
  return DataTable(
    columns: _createColumns(),
    rows: _createRows(),
    dividerThickness: 5,
    dataRowHeight: 80,
    showBottomBorder: true,
    headingTextStyle:
        TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    headingRowColor:
        MaterialStateProperty.resolveWith((states) => Colors.black),
  );
}

List<DataColumn> _createColumns() {
  return [
    DataColumn(label: Text('ID'), tooltip: 'Book identifier'),
    DataColumn(label: Text('Clinician')),
    DataColumn(label: Text('Date'))
  ];
}

List<DataRow> _createRows() {
  return [
    DataRow(cells: [
      DataCell(Text('AET1546GF')),
      DataCell(Text('Johnson', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text('08/07/2022'))
    ]),
    DataRow(cells: [
      DataCell(Text('BEFART413H')),
      DataCell(Text('Thomson')),
      DataCell(Text('10/08/2022'))
    ])
  ];
}
